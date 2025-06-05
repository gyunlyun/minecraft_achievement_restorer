import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/world.dart';
import '../models/world_list.dart';
import '../services/processor_service.dart';
import '../services/language_service.dart';
import '../widgets/world_list_item.dart';
import '../widgets/progress_dialog.dart';
import '../generated/l10n/app_localizations.dart';

/// Main screen for the Minecraft Achievement Restorer
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

enum SortType { name, date }

class _MainScreenState extends State<MainScreen> {
  final ProcessorService _processor = ProcessorService();
  WorldList? _worldList;
  final Set<World> _selectedWorlds = {};
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  SortType _sortType = SortType.name;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clear any progress callback to prevent adding events to closed streams
    _processor.clearProgressCallback();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only scan worlds once when the widget is first built
    if (_worldList == null && !_isLoading) {
      _scanWorlds();
    }
  }

  Future<void> _scanWorlds() async {
    final l10n = AppLocalizations.of(context);

    // Set localized strings for the processor service
    _processor.setLocalizedStrings(
      scanningWorlds: () => l10n.scanningWorlds,
      scanningPath: (path) => l10n.scanningPath(path),
      checkingWorld: (worldName) => l10n.checkingWorld(worldName),
      foundWorlds: (count) => l10n.foundWorlds(count),
      minecraftNotFound: l10n.minecraftNotFound,
      startingProcessing: l10n.startingProcessing,
      processingWorldCount: (count) => l10n.processingWorldCount(count),
      processingWorld: (worldName) => l10n.processingWorld(worldName),
      completedWorld: (worldName) => l10n.completedWorld(worldName),
      failedWorld: (worldName, error) => l10n.failedWorld(worldName, error),
      allProcessingComplete: (count) => l10n.allProcessingComplete(count),
      partialProcessingComplete: (successful, failed) => l10n.partialProcessingComplete(successful, failed),
      createdBackup: (filename) => l10n.createdBackup(filename),
      modifiedLevelDat: l10n.modifiedLevelDat,
    );

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _selectedWorlds.clear();
    });

    try {
      final worldList = await _processor.scanWorlds();
      setState(() {
        _worldList = worldList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _toggleWorldSelection(World world, bool? selected) {
    setState(() {
      if (selected == true) {
        _selectedWorlds.add(world);
      } else {
        _selectedWorlds.remove(world);
      }
    });
  }

  void _selectAllWorlds() {
    setState(() {
      if (_worldList != null) {
        _selectedWorlds.addAll(_worldList!.validWorlds);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedWorlds.clear();
    });
  }

  void _changeSortType(SortType sortType) {
    setState(() {
      if (_sortType == sortType) {
        // If same sort type, toggle order
        _sortAscending = !_sortAscending;
      } else {
        // If different sort type, use default order
        _sortType = sortType;
        _sortAscending = sortType == SortType.name ? true : false; // Name: A-Z, Date: newest first
      }
    });
  }

  WorldList? _getSortedAndFilteredWorlds() {
    if (_worldList == null) return null;

    // First apply sorting
    WorldList sortedList;
    switch (_sortType) {
      case SortType.name:
        sortedList = _worldList!.sortedByName(ascending: _sortAscending);
        break;
      case SortType.date:
        sortedList = _worldList!.sortedByDate(ascending: _sortAscending);
        break;
    }

    // Then apply filtering
    return sortedList.filterByName(_searchQuery);
  }

  Future<void> _processSelectedWorlds() async {
    final l10n = AppLocalizations.of(context);

    if (_selectedWorlds.isEmpty) {
      _showErrorDialog(l10n.noWorldsSelected, l10n.noWorldsSelectedDescription);
      return;
    }

    final confirmed = await _showConfirmationDialog();
    if (!confirmed) return;

    // Set localized strings for the processor service before processing
    _processor.setLocalizedStrings(
      scanningWorlds: () => l10n.scanningWorlds,
      scanningPath: (path) => l10n.scanningPath(path),
      checkingWorld: (worldName) => l10n.checkingWorld(worldName),
      foundWorlds: (count) => l10n.foundWorlds(count),
      minecraftNotFound: l10n.minecraftNotFound,
      startingProcessing: l10n.startingProcessing,
      processingWorldCount: (count) => l10n.processingWorldCount(count),
      processingWorld: (worldName) => l10n.processingWorld(worldName),
      completedWorld: (worldName) => l10n.completedWorld(worldName),
      failedWorld: (worldName, error) => l10n.failedWorld(worldName, error),
      allProcessingComplete: (count) => l10n.allProcessingComplete(count),
      partialProcessingComplete: (successful, failed) => l10n.partialProcessingComplete(successful, failed),
      createdBackup: (filename) => l10n.createdBackup(filename),
      modifiedLevelDat: l10n.modifiedLevelDat,
    );

    final progressController = StreamController<String>();
    final completionController = StreamController<bool>();

    _processor.setProgressCallback((message) {
      progressController.add(message);
    });

    // Show progress dialog
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => ProgressDialog(
          title: l10n.processingWorlds,
          progressStream: progressController.stream,
          completionStream: completionController.stream,
        ),
      );
    }

    try {
      await _processor.processWorlds(_selectedWorlds.toList());
      progressController.add(l10n.allProcessingComplete(_selectedWorlds.length));
      progressController.add(l10n.restartMinecraft);
      completionController.add(true); // Signal completion
    } catch (e) {
      progressController.add('❌ Processing failed: $e');
      completionController.add(true); // Signal completion even on error
    } finally {
      // Clear the progress callback before closing the stream
      _processor.clearProgressCallback();
      progressController.close();
      completionController.close();
    }
  }

  Future<bool> _showConfirmationDialog() async {
    final l10n = AppLocalizations.of(context);

    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmProcessing),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.confirmProcessingMessage(_selectedWorlds.length)),
            const SizedBox(height: 8),
            Text(l10n.confirmProcessingWarning),
            const SizedBox(height: 8),
            Text(
              l10n.confirmProcessingBackup,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(l10n.confirmProcessingQuestion),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.continueButton),
          ),
        ],
      ),
    ) ?? false;
  }

  void _showErrorDialog(String title, String message) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final sortedAndFilteredWorlds = _getSortedAndFilteredWorlds();

    return Scaffold(
        appBar: AppBar(
          title: Text('🎮 ${l10n.appTitle}'),
          backgroundColor: theme.colorScheme.primaryContainer,
          foregroundColor: theme.colorScheme.onPrimaryContainer,
          actions: [
            // Language toggle button
            PopupMenuButton<String>(
              icon: const Icon(Icons.language),
              tooltip: l10n.switchLanguage,
              onSelected: (String languageCode) {
                final languageService = Provider.of<LanguageService>(context, listen: false);
                languageService.changeLanguage(languageCode);

                // Show appropriate message based on target language
                final message = languageCode == 'en'
                    ? l10n.languageChangedToEnglish
                    : l10n.languageChangedToChinese;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              itemBuilder: (BuildContext context) {
                final languageService = Provider.of<LanguageService>(context, listen: false);
                return languageService.supportedLanguages.entries.map((entry) {
                  return PopupMenuItem<String>(
                    value: entry.key,
                    child: Row(
                      children: [
                        Icon(
                          entry.key == languageService.currentLanguageCode
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(entry.value),
                      ],
                    ),
                  );
                }).toList();
              },
            ),
            IconButton(
              onPressed: _scanWorlds,
              icon: const Icon(Icons.refresh),
              tooltip: l10n.refresh,
            ),
          ],
        ),
      body: Column(
        children: [
          // Search and controls
          Container(
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.surface,
            child: Column(
              children: [
                // Search bar
                TextField(
                  decoration: InputDecoration(
                    hintText: l10n.searchWorlds,
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Sort and Selection controls in one row
                Row(
                  children: [
                    // Sort controls (left side)
                    Text(
                      l10n.sortBy,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () => _changeSortType(SortType.name),
                      icon: Icon(
                        _sortType == SortType.name
                            ? (_sortAscending ? Icons.arrow_upward : Icons.arrow_downward)
                            : Icons.sort_by_alpha,
                        size: 16,
                      ),
                      label: Text(l10n.sortByName),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: _sortType == SortType.name
                            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                            : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () => _changeSortType(SortType.date),
                      icon: Icon(
                        _sortType == SortType.date
                            ? (_sortAscending ? Icons.arrow_upward : Icons.arrow_downward)
                            : Icons.access_time,
                        size: 16,
                      ),
                      label: Text(l10n.sortByDate),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: _sortType == SortType.date
                            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                            : null,
                      ),
                    ),

                    const Spacer(),

                    // Selection controls (right side)
                    ElevatedButton.icon(
                      onPressed: _worldList?.validWorlds.isNotEmpty == true ? _selectAllWorlds : null,
                      icon: const Icon(Icons.select_all),
                      label: Text(l10n.selectAll),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: _selectedWorlds.isNotEmpty ? _clearSelection : null,
                      icon: const Icon(Icons.clear),
                      label: Text(l10n.clearSelection),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l10n.selectedCount(_selectedWorlds.length),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // World list
          Expanded(
            child: _buildWorldList(sortedAndFilteredWorlds),
          ),
          // Process button
          Container(
            padding: const EdgeInsets.all(20),
            color: theme.colorScheme.surface,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _selectedWorlds.isNotEmpty ? _processSelectedWorlds : null,
                icon: const Icon(Icons.build, size: 24),
                label: Text(
                  l10n.processWorlds(_selectedWorlds.length),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  backgroundColor: _selectedWorlds.isNotEmpty
                      ? theme.colorScheme.primary
                      : null,
                  foregroundColor: _selectedWorlds.isNotEmpty
                      ? theme.colorScheme.onPrimary
                      : null,
                  elevation: _selectedWorlds.isNotEmpty ? 4 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorldList(WorldList? worldList) {
    final l10n = AppLocalizations.of(context);

    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(l10n.scanningWorlds),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.errorScanningWorlds,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _scanWorlds,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.tryAgain),
            ),
          ],
        ),
      );
    }

    if (worldList == null || worldList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.folder_open, size: 64),
            const SizedBox(height: 16),
            Text(
              l10n.noWorldsFound,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(l10n.noWorldsFoundDescription),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: worldList.length,
      itemBuilder: (context, index) {
        final world = worldList[index];
        return WorldListItem(
          world: world,
          isSelected: _selectedWorlds.contains(world),
          onChanged: (selected) => _toggleWorldSelection(world, selected),
        );
      },
    );
  }
}

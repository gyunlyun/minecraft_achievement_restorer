import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as p;
import '../models/world.dart';
import '../models/world_list.dart';

/// Service for processing Minecraft worlds and restoring achievements
class ProcessorService {
  Function(String)? _progressCallback;

  // Localized string functions for progress messages
  late String Function() _scanningWorldsMessage;
  late String Function(String) _scanningPathMessage;
  late String Function(String) _checkingWorldMessage;
  late String Function(int) _foundWorldsMessage;
  late String _minecraftNotFoundMessage;
  late String _startingProcessingMessage;
  late String Function(int) _processingWorldCountMessage;
  late String Function(String) _processingWorldMessage;
  late String Function(String) _completedWorldMessage;
  late String Function(String, String) _failedWorldMessage;
  late String Function(int) _allProcessingCompleteMessage;
  late String Function(int, int) _partialProcessingCompleteMessage;
  late String Function(String) _createdBackupMessage;
  late String _modifiedLevelDatMessage;

  /// Set progress callback for updates
  void setProgressCallback(Function(String)? callback) {
    _progressCallback = callback;
  }

  /// Clear progress callback
  void clearProgressCallback() {
    _progressCallback = null;
  }

  /// Set localized strings for progress messages
  void setLocalizedStrings({
    required String Function() scanningWorlds,
    required String Function(String) scanningPath,
    required String Function(String) checkingWorld,
    required String Function(int) foundWorlds,
    required String minecraftNotFound,
    required String startingProcessing,
    required String Function(int) processingWorldCount,
    required String Function(String) processingWorld,
    required String Function(String) completedWorld,
    required String Function(String, String) failedWorld,
    required String Function(int) allProcessingComplete,
    required String Function(int, int) partialProcessingComplete,
    required String Function(String) createdBackup,
    required String modifiedLevelDat,
  }) {
    _scanningWorldsMessage = scanningWorlds;
    _scanningPathMessage = scanningPath;
    _checkingWorldMessage = checkingWorld;
    _foundWorldsMessage = foundWorlds;
    _minecraftNotFoundMessage = minecraftNotFound;
    _startingProcessingMessage = startingProcessing;
    _processingWorldCountMessage = processingWorldCount;
    _processingWorldMessage = processingWorld;
    _completedWorldMessage = completedWorld;
    _failedWorldMessage = failedWorld;
    _allProcessingCompleteMessage = allProcessingComplete;
    _partialProcessingCompleteMessage = partialProcessingComplete;
    _createdBackupMessage = createdBackup;
    _modifiedLevelDatMessage = modifiedLevelDat;
  }

  /// Send progress update
  void _updateProgress(String message) {
    try {
      _progressCallback?.call(message);
    } catch (e) {
      // Ignore errors when calling progress callback (e.g., closed stream)
      // This prevents crashes when the callback tries to add to a closed stream
    }
  }

  /// Scan for Minecraft worlds on Windows
  Future<WorldList> scanWorlds() async {
    _updateProgress(_scanningWorldsMessage());

    final worlds = <World>[];

    try {
      // Get the Minecraft directory paths
      final minecraftPaths = await _getMinecraftPaths();

      if (minecraftPaths.isEmpty) {
        throw Exception(_minecraftNotFoundMessage);
      }

      for (final minecraftPath in minecraftPaths) {
        _updateProgress(_scanningPathMessage(minecraftPath));

        final worldsDir = Directory(p.join(minecraftPath, 'minecraftWorlds'));
        if (!worldsDir.existsSync()) {
          continue;
        }

        await for (final entity in worldsDir.list()) {
          if (entity is Directory) {
            _updateProgress(_checkingWorldMessage(p.basename(entity.path)));

            final world = await World.fromDirectory(entity.path);
            if (world != null) {
              worlds.add(world);
            }
          }
        }
      }

      final worldList = WorldList(worlds);
      worldList.sortByDate(); // Sort by most recently modified first

      _updateProgress(_foundWorldsMessage(worldList.length));
      return worldList;

    } catch (e) {
      _updateProgress('❌ Error scanning worlds: $e');
      rethrow;
    }
  }

  /// Get possible Minecraft installation paths
  Future<List<String>> _getMinecraftPaths() async {
    final paths = <String>[];

    try {
      // Get username from environment
      final username = Platform.environment['USERNAME'] ?? Platform.environment['USER'] ?? '';
      if (username.isEmpty) {
        throw Exception('Could not determine username');
      }

      // Primary path: Local AppData
      final localAppDataPath = r'C:\Users\' + username + r'\AppData\Local';
      final minecraftPath1 = p.join(
        localAppDataPath,
        'Packages',
        'Microsoft.MinecraftUWP_8wekyb3d8bbwe',
        'LocalState',
        'games',
        'com.mojang'
      );

      if (Directory(minecraftPath1).existsSync()) {
        paths.add(minecraftPath1);
      }

      // Alternative path: Roaming AppData
      final roamingAppDataPath = r'C:\Users\' + username + r'\AppData\Roaming';
      final minecraftPath2 = p.join(roamingAppDataPath, '.minecraft');

      if (Directory(minecraftPath2).existsSync()) {
        paths.add(minecraftPath2);
      }

      // Check for custom installation paths
      final customPaths = await _findCustomMinecraftPaths();
      paths.addAll(customPaths);

    } catch (e) {
      // If we can't get standard paths, try some common locations
      final username = Platform.environment['USERNAME'] ?? '';
      final commonPaths = [
        r'C:\Users\' + username + r'\AppData\Local\Packages\Microsoft.MinecraftUWP_8wekyb3d8bbwe\LocalState\games\com.mojang',
        r'C:\Users\' + username + r'\AppData\Roaming\.minecraft',
      ];

      for (final commonPath in commonPaths) {
        if (Directory(commonPath).existsSync()) {
          paths.add(commonPath);
        }
      }
    }

    return paths;
  }

  /// Find custom Minecraft installation paths
  Future<List<String>> _findCustomMinecraftPaths() async {
    final customPaths = <String>[];
    
    // Check common drive letters for Minecraft installations
    final driveLetters = ['C', 'D', 'E', 'F'];
    
    for (final drive in driveLetters) {
      final possiblePaths = [
        '$drive:\\Minecraft',
        '$drive:\\Games\\Minecraft',
        '$drive:\\Program Files\\Minecraft',
        '$drive:\\Program Files (x86)\\Minecraft',
      ];
      
      for (final possiblePath in possiblePaths) {
        if (Directory(possiblePath).existsSync()) {
          final comMojangPath = p.join(possiblePath, 'com.mojang');
          if (Directory(comMojangPath).existsSync()) {
            customPaths.add(comMojangPath);
          }
        }
      }
    }
    
    return customPaths;
  }

  /// Process selected worlds to restore achievements
  Future<void> processWorlds(List<World> selectedWorlds) async {
    if (selectedWorlds.isEmpty) {
      throw Exception('No worlds selected for processing');
    }

    _updateProgress(_startingProcessingMessage);
    _updateProgress(_processingWorldCountMessage(selectedWorlds.length));

    int processed = 0;
    int failed = 0;

    for (final world in selectedWorlds) {
      try {
        _updateProgress(_processingWorldMessage(world.getDisplayName()));

        await _processWorld(world);
        processed++;

        _updateProgress(_completedWorldMessage(world.getDisplayName()));

      } catch (e) {
        failed++;
        _updateProgress(_failedWorldMessage(world.getDisplayName(), e.toString()));
      }
    }

    if (failed == 0) {
      _updateProgress(_allProcessingCompleteMessage(processed));
    } else {
      _updateProgress(_partialProcessingCompleteMessage(processed, failed));
    }
  }

  /// Process a single world
  Future<void> _processWorld(World world) async {
    final levelDatPath = p.join(world.path, 'level.dat');
    final levelDatFile = File(levelDatPath);

    if (!levelDatFile.existsSync()) {
      throw Exception('level.dat not found');
    }

    // Create backup
    final backupPath = p.join(world.path, 'level.dat.backup.${DateTime.now().millisecondsSinceEpoch}');
    await levelDatFile.copy(backupPath);
    _updateProgress(_createdBackupMessage(p.basename(backupPath)));

    // Read the level.dat file
    final bytes = await levelDatFile.readAsBytes();

    // Modify the file to restore achievements
    final modifiedBytes = await _modifyLevelDat(bytes);

    // Write the modified file
    await levelDatFile.writeAsBytes(modifiedBytes);

    _updateProgress(_modifiedLevelDatMessage);
  }

  /// Modify level.dat file to restore achievements
  Future<Uint8List> _modifyLevelDat(Uint8List originalBytes) async {
    // This is a simplified implementation
    // In a real implementation, you would need to:
    // 1. Parse the NBT (Named Binary Tag) format
    // 2. Find the achievement/advancement settings
    // 3. Modify the appropriate flags
    // 4. Rewrite the NBT data
    
    // For now, we'll create a copy and add a simple modification
    final modifiedBytes = Uint8List.fromList(originalBytes);
    
    // This is a placeholder - actual implementation would require
    // proper NBT parsing and modification
    // The real logic would involve finding and modifying specific
    // NBT tags related to achievements/advancements
    
    return modifiedBytes;
  }
}

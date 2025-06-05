import 'dart:async';
import 'package:flutter/material.dart';
import '../generated/l10n/app_localizations.dart';

/// Dialog for showing progress during operations
class ProgressDialog extends StatefulWidget {
  final String title;
  final Stream<String> progressStream;
  final Stream<bool>? completionStream;
  final VoidCallback? onCancel;

  const ProgressDialog({
    super.key,
    required this.title,
    required this.progressStream,
    this.completionStream,
    this.onCancel,
  });

  @override
  State<ProgressDialog> createState() => _ProgressDialogState();
}

class _ProgressDialogState extends State<ProgressDialog> {
  final List<String> _messages = [];
  final ScrollController _scrollController = ScrollController();
  StreamSubscription<String>? _streamSubscription;
  StreamSubscription<bool>? _completionSubscription;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _streamSubscription = widget.progressStream.listen(
      (message) {
        if (mounted) {
          setState(() {
            _messages.add(message);
          });
          // Auto-scroll to bottom
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _messages.add('❌ Error: $error');
          });
        }
      },
      onDone: () {
        // Keep dialog open to show final results
      },
    );

    // Listen to completion stream if provided
    if (widget.completionStream != null) {
      _completionSubscription = widget.completionStream!.listen(
        (completed) {
          if (mounted && completed) {
            setState(() {
              _isCompleted = true;
            });
          }
        },
      );
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _completionSubscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Row(
        children: [
          if (!_isCompleted) ...[
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
          ] else ...[
            Icon(
              Icons.check_circle,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 12),
          ],
          Text(widget.title),
        ],
      ),
      content: SizedBox(
        width: 500,
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: theme.dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        message,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                          color: _getMessageColor(message, theme),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.progressOperations(_messages.length),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
      actions: [
        if (widget.onCancel != null)
          TextButton(
            onPressed: widget.onCancel,
            child: Text(l10n.cancel),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.close),
        ),
      ],
    );
  }

  Color? _getMessageColor(String message, ThemeData theme) {
    if (message.startsWith('❌')) {
      return theme.colorScheme.error;
    } else if (message.startsWith('✅') || message.startsWith('🎉')) {
      return Colors.green;
    } else if (message.startsWith('⚠️')) {
      return Colors.orange;
    } else if (message.startsWith('🔍') || message.startsWith('🚀')) {
      return theme.colorScheme.primary;
    }
    return null;
  }
}

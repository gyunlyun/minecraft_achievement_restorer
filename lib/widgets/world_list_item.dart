import 'package:flutter/material.dart';
import '../models/world.dart';

/// Widget for displaying a single world in the list
class WorldListItem extends StatelessWidget {
  final World world;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;

  const WorldListItem({
    super.key,
    required this.world,
    required this.isSelected,
    required this.onChanged,
  });



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isValid = world.isValid();

    return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        elevation: isSelected ? 4 : 1,
        color: isSelected
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
            : null,
        child: CheckboxListTile(
        value: isSelected,
        onChanged: isValid ? onChanged : null,
        title: Row(
          children: [
            Expanded(
              child: Text(
                world.getDisplayName(),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isValid ? null : theme.colorScheme.error,
                  fontWeight: isSelected ? FontWeight.bold : null,
                ),
              ),
            ),
            if (!isValid)
              Icon(
                Icons.warning,
                color: theme.colorScheme.error,
                size: 20,
              ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                world.getDetailsText(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isValid
                      ? theme.colorScheme.onSurface.withValues(alpha: 0.7)
                      : theme.colorScheme.error.withValues(alpha: 0.7),
                ),
              ),
              if (!isValid)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'This world cannot be processed (missing level.dat)',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        enabled: isValid,
        dense: false,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}

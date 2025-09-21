import 'package:flutter/material.dart';
import '../models.dart';

class DashboardToolbar extends StatelessWidget {
  final Environment selectedEnvironment;
  final ValueChanged<Environment?> onEnvironmentChanged;
  final Map<String, Extension> extensions;
  final ValueChanged<String> onShortcutPressed;

  const DashboardToolbar({
    super.key,
    required this.selectedEnvironment,
    required this.onEnvironmentChanged,
    required this.extensions,
    required this.onShortcutPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (!extensions.containsKey('websites') &&
        !extensions.containsKey('paasserverless')) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 600;
        final row = IntrinsicWidth(
          child: Row(
            children: [
              // Environment dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withAlpha(76),
                  ),
                ),
                child: DropdownButton<Environment>(
                  value: selectedEnvironment,
                  onChanged: onEnvironmentChanged,
                  items: Environment.values.map((env) {
                    return DropdownMenuItem(
                      value: env,
                      child: Text(env.displayName),
                    );
                  }).toList(),
                  underline: const SizedBox.shrink(),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 14,
                  ),
                  dropdownColor: Theme.of(context).colorScheme.surface,
                ),
              ),
              const SizedBox(width: 16),
              if (extensions.containsKey('paasserverless'))
                ElevatedButton(
                  onPressed: () => onShortcutPressed('paasserverless'),
                  child: Text(
                    'paasserverless',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              const SizedBox(width: 8),
              if (extensions.containsKey('websites'))
                ElevatedButton(
                  onPressed: () => onShortcutPressed('websites'),
                  child: Text('websites', overflow: TextOverflow.ellipsis),
                ),
            ],
          ),
        );

        return Container(
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withAlpha(76),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: isSmall
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: row,
                )
              : row,
        );
      },
    );
  }
}

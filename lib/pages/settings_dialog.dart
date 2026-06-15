import 'package:flutter/material.dart';

import '../services/theme_service.dart';

Future<void> showSettingsDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return ValueListenableBuilder<ThemeMode>(
        valueListenable: ThemeService.themeMode,
        builder: (context, themeMode, _) {
          return AlertDialog(
            title: const Text("Ρυθμίσεις"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<ThemeMode>(
                  value: ThemeMode.system,
                  groupValue: themeMode,
                  title: const Text("Σύστημα"),
                  onChanged: _changeThemeMode,
                ),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.light,
                  groupValue: themeMode,
                  title: const Text("Φωτεινό"),
                  onChanged: _changeThemeMode,
                ),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.dark,
                  groupValue: themeMode,
                  title: const Text("Σκούρο"),
                  onChanged: _changeThemeMode,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    },
  );
}

void _changeThemeMode(ThemeMode? mode) {
  if (mode == null) {
    return;
  }

  ThemeService.setThemeMode(mode);
}

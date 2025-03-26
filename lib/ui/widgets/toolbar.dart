import 'package:cnvrt/config/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cnvrt/config/application.dart';

import 'toolbar_theme_toggle.dart';

class Toolbar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final double height;
  final bool showActions;

  const Toolbar({
    super.key,
    required this.title,
    this.height = 56.0, // Default height for AppBar
    this.showActions = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Widget> actions = !showActions
        ? []
        : [
            IconButton(
              icon: const Icon(Icons.favorite), // Heart icon for favorites
              tooltip: 'Favorites',
              onPressed: () {
                Application.router.navigateTo(context, Routes.currencies);
              },
            ),
            const ToolbarThemeToggle(),
            IconButton(
              icon: const Icon(Icons.settings), // Settings icon
              tooltip: 'Settings',
              onPressed: () {
                // Handle settings action
                print('Settings pressed');
                Application.router.navigateTo(context, Routes.settings);
              },
            ),
          ];

    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).textTheme.titleLarge?.color?.withAlpha(50) ??
              Colors.grey, /*fontWeight: FontWeight.w800*/
        ),
      ),
      actions: actions,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/presentation/bloc/theme_bloc.dart';

/// Centralized Reusable Theme Toggle IconButton.
class ThemeToggleButton extends StatelessWidget {
  final Color? color;
  final double iconSize;

  const ThemeToggleButton({super.key, this.color, this.iconSize = 24.0});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final isDark = state.themeMode == ThemeMode.dark;
        return IconButton(
          key: const Key('theme_toggle_button'),
          iconSize: iconSize,
          color: color ?? Theme.of(context).iconTheme.color,
          icon: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          ),
          tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
          onPressed: () {
            context.read<ThemeBloc>().add(const ThemeEvent.toggleTheme());
          },
        );
      },
    );
  }
}

/// Centralized Reusable Theme Selection List Tile.
class ThemeSelectionTile extends StatelessWidget {
  const ThemeSelectionTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return PopupMenuButton<ThemeMode>(
          key: const Key('theme_selection_tile'),
          initialValue: state.themeMode,
          icon: const Icon(Icons.palette_outlined),
          tooltip: 'Select Theme Mode',
          onSelected: (mode) {
            context.read<ThemeBloc>().add(ThemeEvent.changeTheme(mode));
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: ThemeMode.system,
              child: ListTile(
                leading: Icon(Icons.brightness_auto_rounded),
                title: Text('System Default'),
              ),
            ),
            PopupMenuItem(
              value: ThemeMode.light,
              child: ListTile(
                leading: Icon(Icons.light_mode_rounded),
                title: Text('Light Mode'),
              ),
            ),
            PopupMenuItem(
              value: ThemeMode.dark,
              child: ListTile(
                leading: Icon(Icons.dark_mode_rounded),
                title: Text('Dark Mode'),
              ),
            ),
          ],
        );
      },
    );
  }
}

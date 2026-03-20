import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback onPressed;
  const AppBackButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = ColorScheme.of(context);
    return Center(
      child: IconButtonTheme(
        data: IconButtonThemeData(
          style: IconButton.styleFrom(
            backgroundColor: colorScheme.primary,
            shape: CircleBorder(),
          ),
        ),
        child: IconButton.filled(
          color: colorScheme.onPrimary,
          onPressed: onPressed,
          icon: Icon(Icons.arrow_back_sharp),
        ),
      ),
    );
  }
}

class AppEndDrawer extends StatelessWidget {
  const AppEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = ColorScheme.of(context);
    return Builder(
      builder: (ctx) => IconButtonTheme(
        data: IconButtonThemeData(
          style: IconButton.styleFrom(
            backgroundColor: colorScheme.primary,
            shape: CircleBorder(),
          ),
        ),
        child: IconButton(
          onPressed: Scaffold.of(ctx).openEndDrawer,
          color: colorScheme.onPrimary,
          icon: Icon(Icons.menu),
        ),
      ),
    );
  }
}

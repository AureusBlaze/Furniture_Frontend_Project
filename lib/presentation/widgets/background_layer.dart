import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';

/// Full-screen background image layer with gradient overlay.
/// Uses the current theme's background asset.
class BackgroundLayer extends StatelessWidget {
  final Widget child;
  final bool showGradient;

  const BackgroundLayer({
    super.key,
    required this.child,
    this.showGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        Image.asset(
          theme.backgroundAsset,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        // Gradient overlay
        if (showGradient)
          Container(
            decoration: BoxDecoration(
              gradient: theme.overlayGradient,
            ),
          ),
        // Content
        child,
      ],
    );
  }
}

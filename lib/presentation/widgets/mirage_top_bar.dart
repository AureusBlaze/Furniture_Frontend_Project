import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/cart_viewmodel.dart';

/// Mirage top bar split into dark-left and light-right sections.
class MirageTopBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onCameraTap;

  const MirageTopBar({
    super.key,
    this.onMenuTap,
    this.onCartTap,
    this.onSearchTap,
    this.onCameraTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;

    return SafeArea(
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Row(
              children: [
                // Dark section: menu + cart
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.primaryDark.withValues(alpha: 0.85),
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(Icons.menu, color: theme.textOnDark, size: 20),
                          onPressed: onMenuTap,
                        ),
                        _buildCartButton(context, theme),
                      ],
                    ),
                  ),
                ),
                // Light section: brand + search + camera
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.surface.withValues(alpha: 0.9),
                      borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'MIRAGE',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 6,
                            color: theme.textOnLight,
                            fontFamily: 'PlayfairDisplay',
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.search, color: theme.textOnLight, size: 20),
                          onPressed: onSearchTap,
                        ),
                        IconButton(
                          icon: Icon(Icons.camera_alt_outlined,
                              color: theme.textOnLight, size: 20),
                          onPressed: onCameraTap,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartButton(BuildContext context, dynamic theme) {
    return Consumer<CartViewModel>(
      builder: (_, cart, __) {
        return Stack(
          children: [
            IconButton(
              icon: Icon(Icons.shopping_bag_outlined,
                  color: theme.textOnDark, size: 20),
              onPressed: onCartTap,
            ),
            if (cart.itemCount > 0)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: theme.accent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${cart.itemCount}',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: theme.primaryDark,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

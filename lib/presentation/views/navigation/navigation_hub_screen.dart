import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';
import 'package:mirage_by_aurues/app/theme/mirage_typography.dart';
import 'package:mirage_by_aurues/presentation/widgets/background_layer.dart';

/// Navigation Hub — central hub with glass HUD and directional navigation.
class NavigationHubScreen extends StatefulWidget {
  const NavigationHubScreen({super.key});

  @override
  State<NavigationHubScreen> createState() => _NavigationHubScreenState();
}

class _NavigationHubScreenState extends State<NavigationHubScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;

    return Scaffold(
      body: BackgroundLayer(
        child: FadeTransition(
          opacity: _fadeController,
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildTopBar(theme),
                const Spacer(),
                _buildCentralHUD(context, theme),
                const Spacer(),
                _buildBottomSection(theme),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(dynamic theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: theme.glassColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.glassBorder, width: 0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'MIRAGE',
                  style: MirageTypography.labelLarge(
                    color: theme.textOnDark,
                  ).copyWith(letterSpacing: 6),
                ),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: theme.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'ONLINE',
                      style: MirageTypography.labelSmall(
                        color: theme.textOnDark.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCentralHUD(BuildContext context, dynamic theme) {
    return SizedBox(
      width: 260,
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: theme.glassBorder, width: 0.5),
            ),
          ),
          // Center dot — clean amber, NO glow
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: theme.accent,
              shape: BoxShape.circle,
            ),
          ),
          _buildDirectionButton(context, theme,
              icon: Icons.home_outlined, label: 'HOME',
              alignment: Alignment.topCenter, tabIndex: 0),
          _buildDirectionButton(context, theme,
              icon: Icons.grid_view_outlined, label: 'CATALOG',
              alignment: Alignment.centerRight, tabIndex: 1),
          _buildDirectionButton(context, theme,
              icon: Icons.person_outline, label: 'PROFILE',
              alignment: Alignment.bottomCenter, tabIndex: 3),
          _buildDirectionButton(context, theme,
              icon: Icons.view_in_ar_outlined, label: 'AR',
              alignment: Alignment.centerLeft, tabIndex: 2),
        ],
      ),
    );
  }

  Widget _buildDirectionButton(
    BuildContext context, dynamic theme, {
    required IconData icon, required String label,
    required Alignment alignment, required int tabIndex,
  }) {
    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushReplacementNamed(
          '/shell', arguments: tabIndex,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.glassColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.glassBorder, width: 0.5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: theme.textOnDark, size: 22),
                  const SizedBox(height: 4),
                  Text(label, style: MirageTypography.labelSmall(
                    color: theme.textOnDark.withValues(alpha: 0.7),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection(dynamic theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.primaryDark.withValues(alpha: 0.7),
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                  ),
                  child: Text('EXPLORE', textAlign: TextAlign.center,
                    style: MirageTypography.labelSmall(
                      color: theme.textOnDark.withValues(alpha: 0.5))),
                ),
              ),
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.glassColor,
                    borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
                  ),
                  child: Text('DISCOVER', textAlign: TextAlign.center,
                    style: MirageTypography.labelSmall(
                      color: theme.textOnDark.withValues(alpha: 0.5))),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

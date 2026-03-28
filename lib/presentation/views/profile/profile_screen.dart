import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';
import 'package:mirage_by_aurues/app/theme/mirage_typography.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/auth_viewmodel.dart';

/// Profile screen — user info, theme switcher, and logout.
/// Shows login prompt if unauthenticated.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;

    return Container(
      color: theme.surface,
      child: Consumer<AuthViewModel>(
        builder: (_, authVm, __) {
          if (!authVm.isAuthenticated) {
            return _buildLoginPrompt(context, theme);
          }
          return _buildProfile(context, authVm, theme);
        },
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context, dynamic theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_outline, size: 64,
                color: theme.textSecondary.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text('Welcome to Mirage',
                style: MirageTypography.displaySmall(color: theme.textPrimary)),
            const SizedBox(height: 8),
            Text(
              'Sign in to access your profile and order history',
              textAlign: TextAlign.center,
              style: MirageTypography.bodyMedium(color: theme.textSecondary),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/login'),
                child: const Text('SIGN IN'),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).pushNamed('/register'),
              child: Text(
                'CREATE ACCOUNT',
                style: TextStyle(
                  color: theme.accentWarm,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Theme switcher (available without login)
            _buildThemeSection(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile(
      BuildContext context, AuthViewModel authVm, dynamic theme) {
    return ListView(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 80,
        left: 20,
        right: 20,
        bottom: 100,
      ),
      children: [
        // User info header
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.primaryDark,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: theme.accentWarm,
                child: Text(
                  authVm.user?.name.substring(0, 1).toUpperCase() ?? '?',
                  style: MirageTypography.headingLarge(color: theme.textOnDark),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authVm.user?.name ?? '',
                      style: MirageTypography.headingMedium(
                        color: theme.textOnDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      authVm.user?.email ?? '',
                      style: MirageTypography.bodySmall(
                        color: theme.textOnDark.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Menu items
        _buildMenuItem(
          theme,
          icon: Icons.receipt_long_outlined,
          label: 'Order History',
          onTap: () {},
        ),
        _buildMenuItem(
          theme,
          icon: Icons.favorite_outline,
          label: 'Wishlist',
          onTap: () {},
        ),
        _buildMenuItem(
          theme,
          icon: Icons.settings_outlined,
          label: 'Settings',
          onTap: () {},
        ),

        const SizedBox(height: 24),

        // Theme section
        _buildThemeSection(context, theme),

        const SizedBox(height: 24),

        // Logout
        TextButton.icon(
          onPressed: () => authVm.logout(),
          icon: Icon(Icons.logout, color: theme.error, size: 18),
          label: Text(
            'SIGN OUT',
            style: TextStyle(
              color: theme.error,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    dynamic theme, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: theme.textSecondary, size: 22),
      title: Text(
        label,
        style: TextStyle(
          color: theme.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: theme.textSecondary, size: 20),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  Widget _buildThemeSection(BuildContext context, dynamic theme) {
    final themeProvider = context.watch<ThemeProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'APPEARANCE',
          style: MirageTypography.labelLarge(color: theme.textPrimary)
              .copyWith(letterSpacing: 3),
        ),
        const SizedBox(height: 12),
        Row(
          children: themeProvider.availableThemes.map((t) {
            final isSelected = t.id == themeProvider.currentTheme.id;
            return Expanded(
              child: GestureDetector(
                onTap: () => themeProvider.setTheme(t.id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? t.primaryDark
                        : t.primaryDark.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? t.accent : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Color preview
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _colorDot(t.primaryDark),
                          _colorDot(t.accentWarm),
                          _colorDot(t.accent),
                          _colorDot(t.surface),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        t.name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? t.textOnDark : theme.textPrimary,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _colorDot(Color color) {
    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
    );
  }
}

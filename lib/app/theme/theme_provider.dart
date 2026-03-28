import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'themes/mirage_theme_data.dart';
import 'themes/old_money_theme.dart';
import 'themes/midnight_theme.dart';
import 'mirage_theme.dart';

/// Manages theme state. Exposes the current [MirageThemeData] and
/// the built [ThemeData]. Persists theme selection to SharedPreferences.
class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'mirage_selected_theme';

  /// All available themes. Add new themes here.
  final List<MirageThemeData> availableThemes = [
    OldMoneyTheme(),
    MidnightTheme(),
  ];

  late MirageThemeData _currentTheme;
  late ThemeData _themeData;

  ThemeProvider() {
    _currentTheme = availableThemes.first;
    _themeData = MirageTheme.fromMirageTheme(_currentTheme);
    _loadPersistedTheme();
  }

  MirageThemeData get currentTheme => _currentTheme;
  ThemeData get themeData => _themeData;

  /// Switch to a theme by its [id].
  Future<void> setTheme(String themeId) async {
    final theme = availableThemes.firstWhere(
      (t) => t.id == themeId,
      orElse: () => availableThemes.first,
    );
    _currentTheme = theme;
    _themeData = MirageTheme.fromMirageTheme(theme);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeId);
  }

  Future<void> _loadPersistedTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedId = prefs.getString(_themeKey);
      if (savedId != null && savedId != _currentTheme.id) {
        await setTheme(savedId);
      }
    } catch (_) {
      // Use default theme on first launch
    }
  }
}

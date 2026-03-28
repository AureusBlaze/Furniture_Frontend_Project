import 'package:flutter/material.dart';
import 'mirage_theme_data.dart';

/// Alternative theme — "Midnight" aesthetic.
/// Cool, deep blues and silvers with a modern noir vibe.
class MidnightTheme extends MirageThemeData {
  @override
  String get id => 'midnight';
  @override
  String get name => 'Midnight';
  @override
  String get description => 'Cool, deep blues & silvers — modern noir';

  // ─── Core Colors ─────────────────────────────────────────────────
  @override
  Color get primaryDark => const Color(0xFF0F1117);
  @override
  Color get primaryLight => const Color(0xFFE8EAF0);
  @override
  Color get accent => const Color(0xFF7C8CF8);
  @override
  Color get accentWarm => const Color(0xFF4A5278);
  @override
  Color get surface => const Color(0xFFE8EAF0);
  @override
  Color get surfaceVariant => const Color(0xFFB0B5C4);
  @override
  Color get textPrimary => const Color(0xFF0F1117);
  @override
  Color get textSecondary => const Color(0xFF7A7F8E);
  @override
  Color get textOnDark => const Color(0xFFE8EAF0);
  @override
  Color get textOnLight => const Color(0xFF0F1117);
  @override
  Color get error => const Color(0xFFFF6B6B);
  @override
  Color get success => const Color(0xFF00D1A0);

  // ─── Glass Properties ────────────────────────────────────────────
  @override
  Color get glassColor => const Color(0x33FFFFFF);
  @override
  Color get glassBorder => const Color(0x1AFFFFFF);
  @override
  double get glassOpacity => 0.15;
  @override
  double get glassBlur => 24.0;

  // ─── Background ──────────────────────────────────────────────────
  @override
  String get backgroundAsset => 'lib/images/david-kristianto-urczA5aOLcc-unsplash.jpg';

  // ─── Gradients ───────────────────────────────────────────────────
  @override
  LinearGradient get overlayGradient => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0x000F1117),
          Color(0xCC0F1117),
        ],
      );

  @override
  LinearGradient get cardGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0x4D0F1117),
          Color(0x1A0F1117),
        ],
      );
}

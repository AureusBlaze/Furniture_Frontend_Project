import 'package:flutter/material.dart';
import 'mirage_theme_data.dart';

/// Default theme — "Old Money" aesthetic.
/// Warm, luxurious, understated elegance.
class OldMoneyTheme extends MirageThemeData {
  @override
  String get id => 'old_money';
  @override
  String get name => 'Old Money';
  @override
  String get description => 'Warm, luxurious, understated elegance';

  // ─── Core Colors ─────────────────────────────────────────────────
  @override
  Color get primaryDark => const Color(0xFF1C1C1B);
  @override
  Color get primaryLight => const Color(0xFFE2E2DE);
  @override
  Color get accent => const Color(0xFFF8BB73);
  @override
  Color get accentWarm => const Color(0xFF6A5D52);
  @override
  Color get surface => const Color(0xFFE2E2DE);
  @override
  Color get surfaceVariant => const Color(0xFFB7AC9B);
  @override
  Color get textPrimary => const Color(0xFF1C1C1B);
  @override
  Color get textSecondary => const Color(0xFF979086);
  @override
  Color get textOnDark => const Color(0xFFE2E2DE);
  @override
  Color get textOnLight => const Color(0xFF1C1C1B);
  @override
  Color get error => const Color(0xFFCF6679);
  @override
  Color get success => const Color(0xFF10B981);

  // ─── Glass Properties ────────────────────────────────────────────
  @override
  Color get glassColor => const Color(0x33FFFFFF);
  @override
  Color get glassBorder => const Color(0x1AFFFFFF);
  @override
  double get glassOpacity => 0.2;
  @override
  double get glassBlur => 20.0;

  // ─── Background ──────────────────────────────────────────────────
  @override
  String get backgroundAsset => 'lib/images/tommi-jungblut-3FOlmPPw42k-unsplash.jpg';

  // ─── Gradients ───────────────────────────────────────────────────
  @override
  LinearGradient get overlayGradient => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0x001C1C1B),
          Color(0xCC1C1C1B),
        ],
      );

  @override
  LinearGradient get cardGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0x4D1C1C1B),
          Color(0x1A1C1C1B),
        ],
      );
}

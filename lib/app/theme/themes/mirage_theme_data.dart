import 'package:flutter/material.dart';

/// Abstract definition for a Mirage theme.
/// Each theme provides its own colors, background, and glass properties.
/// Add new themes by extending this class.
abstract class MirageThemeData {
  String get id;
  String get name;
  String get description;

  // ─── Core Colors ─────────────────────────────────────────────────
  Color get primaryDark;
  Color get primaryLight;
  Color get accent;
  Color get accentWarm;
  Color get surface;
  Color get surfaceVariant;
  Color get textPrimary;
  Color get textSecondary;
  Color get textOnDark;
  Color get textOnLight;
  Color get error;
  Color get success;

  // ─── Glass Properties ────────────────────────────────────────────
  Color get glassColor;
  Color get glassBorder;
  double get glassOpacity;
  double get glassBlur;

  // ─── Background ──────────────────────────────────────────────────
  String get backgroundAsset; // path under lib/images/

  // ─── Gradients ───────────────────────────────────────────────────
  LinearGradient get overlayGradient;
  LinearGradient get cardGradient;
}

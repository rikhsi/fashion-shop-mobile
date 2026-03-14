import 'package:flutter/material.dart';

abstract final class AppColors {
  // ── Brand ──
  static const Color primary = Color(0xFFEA7C7C);
  static const Color primaryLight = Color(0xFFF4A6A6);
  static const Color primarySurface = Color(0xFFFFEFEF);
  static const Color accent = Color(0xFF0EA5E9);

  // ── Semantic ──
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
  static const Color discount = Color(0xFFF43F5E);

  // ── Banner palette ──
  static const Color bannerOrange = Color(0xFFE17055);
  static const Color bannerGreen = Color(0xFF00B894);

  // ── Light scheme ──
  static const ColorScheme lightScheme = ColorScheme(
    brightness: Brightness.light,

    primary: Color(0xFFEA7C7C),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFFFEFEF),
    onPrimaryContainer: Color(0xFF7F1D1D),

    secondary: Color(0xFF6B7280),
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFF3F4F6),
    onSecondaryContainer: Color(0xFF374151),

    surface: Color(0xFFF7F7F7), // основной фон
    onSurface: Color(0xFF111827),

    onSurfaceVariant: Color(0xFF6B7280),

    error: Color(0xFFEF4444),
    onError: Colors.white,

    outline: Color(0xFFE5E7EB),
    outlineVariant: Color(0xFFF3F4F6),

    shadow: Color(0x14000000),

    inverseSurface: Color(0xFF111827),
    onInverseSurface: Color(0xFFF9FAFB),

    surfaceContainerHighest: Color(0xFFFFFFFF),
    surfaceContainerLowest: Color(0xFFF7F7F7),
  );

  // ── Dark scheme ──
  static const ColorScheme darkScheme = ColorScheme(
    brightness: Brightness.dark,

    primary: Color(0xFFF4A6A6),
    onPrimary: Color(0xFF111827),

    primaryContainer: Color(0xFF7F1D1D),
    onPrimaryContainer: Color(0xFFFFEFEF),

    secondary: Color(0xFF9CA3AF),
    onSecondary: Color(0xFF020617),

    secondaryContainer: Color(0xFF1F2937),
    onSecondaryContainer: Color(0xFFE5E7EB),

    surface: Color(0xFF0B0B0C),
    onSurface: Color(0xFFF9FAFB),

    onSurfaceVariant: Color(0xFF9CA3AF),

    error: Color(0xFFF87171),
    onError: Color(0xFF7F1D1D),

    outline: Color(0xFF27272A),
    outlineVariant: Color(0xFF18181B),

    shadow: Color(0x66000000),

    inverseSurface: Color(0xFFF9FAFB),
    onInverseSurface: Color(0xFF09090B),

    surfaceContainerHighest: Color(0xFF1A1A1B),
    surfaceContainerLowest: Color(0xFF0B0B0C),
  );
}

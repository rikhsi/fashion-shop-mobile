import 'package:flutter/material.dart';

abstract final class AppColors {
  // ── Brand ──
  static const Color primary = Color(0xFF7C3AED);
  static const Color primaryDark = Color(0xFF6D28D9);
  static const Color primaryLight = Color(0xFFA78BFA);
  static const Color primarySurface = Color(0xFFEDE9FE);
  static const Color accent = Color(0xFFF59E0B);

  // ── Semantic ──
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
  static const Color discount = Color(0xFFEF4444);

  // ── Light scheme ──
  static const ColorScheme lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: Colors.white,
    primaryContainer: primarySurface,
    onPrimaryContainer: primaryDark,
    secondary: Color(0xFF64748B),
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFF1F5F9),
    onSecondaryContainer: Color(0xFF334155),
    surface: Colors.white,
    onSurface: Color(0xFF0F172A),
    onSurfaceVariant: Color(0xFF64748B),
    error: error,
    onError: Colors.white,
    outline: Color(0xFFE2E8F0),
    outlineVariant: Color(0xFFF1F5F9),
    shadow: Color(0x0A000000),
    inverseSurface: Color(0xFF1E293B),
    onInverseSurface: Color(0xFFF8FAFC),
  );

  // ── Dark scheme ──
  static const ColorScheme darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primaryLight,
    onPrimary: Color(0xFF1E293B),
    primaryContainer: primaryDark,
    onPrimaryContainer: primarySurface,
    secondary: Color(0xFF94A3B8),
    onSecondary: Color(0xFF1E293B),
    secondaryContainer: Color(0xFF334155),
    onSecondaryContainer: Color(0xFFCBD5E1),
    surface: Color(0xFF0F172A),
    onSurface: Color(0xFFF8FAFC),
    onSurfaceVariant: Color(0xFF94A3B8),
    error: Color(0xFFFCA5A5),
    onError: Color(0xFF7F1D1D),
    outline: Color(0xFF334155),
    outlineVariant: Color(0xFF1E293B),
    shadow: Color(0x40000000),
    inverseSurface: Color(0xFFF8FAFC),
    onInverseSurface: Color(0xFF0F172A),
  );
}

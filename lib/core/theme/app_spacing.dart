import 'package:flutter/material.dart';

abstract final class AppSpacing {
  // ── Size scale ──
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
  static const double xxxxl = 64;

  // ── Border radius ──
  static const double radiusXs = 6;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;
  static const double radiusXxl = 24;
  static const double radiusFull = 999;

  // ── Common EdgeInsets ──
  static const EdgeInsets screenPadding =
      EdgeInsets.symmetric(horizontal: base);
  static const EdgeInsets cardPadding = EdgeInsets.all(base);
  static const EdgeInsets sectionPadding =
      EdgeInsets.symmetric(horizontal: base, vertical: lg);

  // ── Sizes ──
  static const double iconSm = 20;
  static const double iconMd = 24;
  static const double iconLg = 28;
  static const double iconXl = 32;
  static const double buttonHeight = 52;
  static const double buttonHeightSm = 40;
  static const double inputHeight = 52;
  static const double bottomNavHeight = 68;
  static const double appBarHeight = 56;
  static const double searchBarHeight = 44;
  static const double avatarSm = 40;
  static const double avatarMd = 56;
  static const double avatarLg = 72;
  static const double productCardImageRatio = 1.25;
  static const double bannerHeight = 160;
}

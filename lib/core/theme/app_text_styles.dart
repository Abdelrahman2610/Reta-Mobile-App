import 'package:flutter/material.dart';

/// App Text Styles

class AppTextStyles {
  AppTextStyles._();

  static const String _fontFamily = 'NotoSansArabic';

  // ─────────────────────────────────────────
  // HEADING
  // ─────────────────────────────────────────

  /// H1 — Bold, 32px
  static const TextStyle h1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.09,
  );

  /// H2 — ExtraBold, 24px
  static const TextStyle h2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w800,
    height: 1.46,
  );

  /// H3 — ExtraBold, 20px
  static const TextStyle h3 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w800,
    height: 1.5,
  );

  /// H4 — ExtraBold, 16px
  static const TextStyle h4 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w800,
    height: 1.63,
  );

  /// H5 — Bold, 14px
  static const TextStyle h5 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.43,
  );

  /// H6 — Bold, 12px
  static const TextStyle h6 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.33,
  );

  // ─────────────────────────────────────────
  // BODY
  // ─────────────────────────────────────────

  /// Body XL — Regular, 18px
  static const TextStyle bodyXL = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.56,
  );

  /// Body L — Regular, 16px
  static const TextStyle bodyL = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Body M — Regular, 14px
  static const TextStyle bodyM = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.57,
  );

  /// Body S — Regular, 12px
  static const TextStyle bodyS = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0.12,
  );

  /// Body XS — Regular, 10px
  static const TextStyle bodyXS = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.15,
  );

  // ─────────────────────────────────────────
  // ACTION (Buttons / Links)
  // ─────────────────────────────────────────

  /// Action XXL — SemiBold, 20px
  static const TextStyle actionXXL = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  /// Action XL — SemiBold, 16px
  static const TextStyle actionXL = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  /// Action Large — SemiBold, 14px
  static const TextStyle actionL = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  /// Action Medium — SemiBold, 12px
  static const TextStyle actionM = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  /// Action Small — SemiBold, 10px
  static const TextStyle actionS = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // ─────────────────────────────────────────
  // CAPTION
  // ─────────────────────────────────────────

  /// Caption SemiBold — 10px
  static const TextStyle captionSB = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.5,
  );

  /// Caption Medium — 10px
  static const TextStyle captionM = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.5,
  );
}

// What it does: every color used anywhere in the app lives here as a named constant. 
//Instead of writing Color(0xFF2C2F33) inside a widget, we write AppColors.primaryDark.
// Why this matters: if the client says "make the green a bit darker" after I've built
// 14 screens, you change one line here instead of hunting through every file.
 import 'package:flutter/material.dart';

 class AppColors {
    AppColors._();

//Branding
  static const Color primaryDark = Color(0xFF121416);
  static const Color primaryDarkGradientEnd = Color(0xFF2A2E32);
  static const Color accentGreen = Color(0xFF34D399);
  static const Color accentGreenDark = Color(0xFF047857);
  static const Color successGreen = Color(0xFF22C55E);
  static const Color successGreenDark = Color(0xFF16A34A);

  // Backgrounds
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF1F5F9);

  // Text
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color textOnDarkMuted = Color(0xB3FFFFFF);
  static const Color textOnDarkFaint = Color(0x80FFFFFF);

  // Borders / dividers
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color divider = Color(0xFFE2E8F0);

  // Status / semantic
  static const Color danger = Color(0xFFEF4444);
  static const Color dangerBg = Color(0xFFFEF2F2);
  static const Color dangerBorder = Color(0xFFFECACA);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningBg = Color(0xFFFFFBEB);
  static const Color warningBorder = Color(0xFFFDE68A);

  static const Color pending = Color(0xFFEA580C);
  static const Color pendingBg = Color(0xFFFFF7ED);
  static const Color pendingBorder = Color(0xFFFFEDD5);
 }
// What it does: every text style (heading, body, label, 
// button text) used anywhere in the app is defined here once
//  — font size, weight, color. Screens will write Text('Login
//  ', style: AppTextStyles.h2) instead of repeating TextStyle
//  (fontSize: 24, fontWeight: FontWeight.w700, ...) in every file.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:apartmate/core/constants/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();
  
  static TextStyle _base( {
    required double size,
    required FontWeight weight,
    Color color = AppColors.textPrimary,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  //Display / headings
  static TextStyle h1 = _base(size: 32, weight: FontWeight.w700, letterSpacing: -0.5);
  static TextStyle h2 = _base(size: 24, weight: FontWeight.w700, letterSpacing: -0.3);
  static TextStyle h3 = _base(size: 20, weight: FontWeight.w700);
  static TextStyle h4 = _base(size: 18, weight: FontWeight.w700);

  // Body
  static TextStyle bodyLarge = _base(size: 16, weight: FontWeight.w500);
  static TextStyle bodyMedium = _base(size: 14, weight: FontWeight.w500);
  static TextStyle bodySmall = _base(size: 12, weight: FontWeight.w500);

  // Labels
  static TextStyle labelLarge = _base(size: 14, weight: FontWeight.w600);
  static TextStyle labelMedium = _base(size: 12, weight: FontWeight.w700);
  static TextStyle labelSmall = _base(size: 10, weight: FontWeight.w700, letterSpacing: 0.4);

  // Buttons
  static TextStyle buttonLarge = _base(size: 18, weight: FontWeight.w600);
  static TextStyle buttonMedium = _base(size: 15, weight: FontWeight.w600);

  // Muted variants
  static TextStyle caption = _base(size: 12, weight: FontWeight.w500, color: AppColors.textSecondary);
}

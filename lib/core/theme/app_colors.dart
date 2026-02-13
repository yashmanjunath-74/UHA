import 'package:flutter/material.dart';

class AppColors {
  // Emerald Green Palette - Exact matches from HTML/Tailwind mockups
  static const Color primary = Color(0xFF009669); // Main Emerald (Verification)
  static const Color primaryDark = Color(0xFF007A55); // Darker Emerald
  static const Color primaryLight = Color(0xFFE0F2F1); // Light Tint
  static const Color secondary = Color(
    0xFF10B981,
  ); // Lighter Emerald (Gradients)
  static const Color accent = Color(0xFF34D399); // Bright Accent

  // Legacy/Alias for compatibility
  static const Color primarySubtle = accent;

  // Backgrounds - MATCHED TO MOCKUPS
  static const Color backgroundLight = Color(
    0xFFF0FDF4,
  ); // Emerald 50 (from Login/Role mockups)
  static const Color backgroundDark = Color(0xFF022C22); // Deep Dark Emerald

  // Surfaces
  static const Color surfaceLight = Color(
    0xFFFFFFFF,
  ); // Cards are white on tinted bg
  static const Color surfaceDark = Color(0xFF1A241D);

  // Neutrals
  static const Color neutral50 = Color(0xFFF8FAFC);
  static const Color neutral100 = Color(0xFFF1F5F9);
  static const Color neutral200 = Color(0xFFE2E8F0);
  static const Color neutral300 = Color(0xFFCBD5E1);
  static const Color neutral400 = Color(0xFF94A3B8);
  static const Color neutral500 = Color(0xFF64748B);
  static const Color neutral600 = Color(0xFF475569);
  static const Color neutral700 = Color(0xFF334155);
  static const Color neutral800 = Color(0xFF1E293B);
  static const Color neutral900 = Color(0xFF0F172A);

  // Functional
  static const Color error = Color(0xFFEF4444);
  static const Color success = primary;
  static const Color warning = Color(0xFFF59E0B);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), primary],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF5F8F7), // Light tinted white
      Color(0xFFE0F2F1), // Slight emerald tint
    ],
  );
}

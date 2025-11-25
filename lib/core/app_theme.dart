import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color background = Color(0xFF0F172A); // Richer dark blue
  static const Color surface = Color(0xFF1E293B);
  static const Color primary = Color(0xFF38BDF8); // Sky blue
  static const Color secondary = Color(0xFF818CF8); // Indigo
  static const Color accent = Color(0xFFF472B6); // Pink
  
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF94A3B8); // Slate 400

  // Glass Colors
  static Color glassBorder = Colors.white.withOpacity(0.1);
  static Color glassBackground = Colors.white.withOpacity(0.03);
  static Color glassHighlight = Colors.white.withOpacity(0.08);

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
        background: background,
      ),
      textTheme: GoogleFonts.outfitTextTheme( // More modern font
        ThemeData.dark().textTheme.apply(
          bodyColor: textPrimary,
          displayColor: textPrimary,
        ),
      ),
      useMaterial3: true,
    );
  }
}

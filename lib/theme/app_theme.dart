import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {

  // ── Colores ──────────────────────────────────────────────────────
  static const Color black     = Color(0xFF0A0A0F);
  static const Color ash       = Color(0xFF1C1C28);
  static const Color ash2      = Color(0xFF2A2A3A);
  static const Color blue      = Color(0xFF1A3AFF);
  static const Color blueLight = Color(0xFF4D6FFF);
  static const Color red       = Color(0xFFDD1111);
  static const Color redLight  = Color(0xFFFF4444);
  static const Color goldWhite = Color(0xFFF5E6C8);
  static const Color white     = Color(0xFFF8F8FF);
  static const Color grey      = Color(0xFF8A8A9A);
  static const Color greyLight = Color(0xFFB0B0C0);
  static const Color surface   = Color(0xFF16161F);
  static const Color surface2  = Color(0xFF202030);
  static const Color border    = Color(0x33F5E6C8);

  // ── Tema ─────────────────────────────────────────────────────────
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: black,
      colorScheme: const ColorScheme.dark(
        background: black,
        surface: surface,
        primary: blue,
        secondary: red,
        onPrimary: white,
        onSecondary: white,
        onSurface: white,
        error: redLight,
      ),
      textTheme: GoogleFonts.dmSansTextTheme(
        const TextTheme(
          displayLarge: TextStyle(color: white,     fontSize: 36, fontWeight: FontWeight.w700),
          titleLarge:   TextStyle(color: white,     fontSize: 20, fontWeight: FontWeight.w600),
          titleMedium:  TextStyle(color: white,     fontSize: 16, fontWeight: FontWeight.w500),
          bodyLarge:    TextStyle(color: white,     fontSize: 15),
          bodyMedium:   TextStyle(color: greyLight, fontSize: 13),
          bodySmall:    TextStyle(color: grey,      fontSize: 11),
          labelLarge:   TextStyle(color: white,     fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: black,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.bebasNeue(
          color: white, fontSize: 22, letterSpacing: 3,
        ),
        iconTheme: const IconThemeData(color: white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: blue,
          foregroundColor: white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 1),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: goldWhite,
          side: const BorderSide(color: goldWhite, width: 1),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: blue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: red, width: 1),
        ),
        hintStyle:  const TextStyle(color: grey,      fontSize: 14),
        labelStyle: const TextStyle(color: greyLight, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: border, width: 0.5),
        ),
      ),
      dividerTheme: const DividerThemeData(color: border, thickness: 0.5),
    );
  }
}
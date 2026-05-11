import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {

  // ── Colores modo oscuro ──────────────────────────────────────────
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

  // ── Colores modo claro ───────────────────────────────────────────
  static const Color lightBg       = Color(0xFFF5F5F5);
  static const Color lightSurface  = Color(0xFFFFFFFF);
  static const Color lightSurface2 = Color(0xFFEEEEF5);
  static const Color lightBorder   = Color(0xFFDDDDEE);
  static const Color lightText     = Color(0xFF0A0A0F);
  static const Color lightGrey     = Color(0xFF666677);

  // ── Tema oscuro ──────────────────────────────────────────────────
  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  // ── Tema claro ───────────────────────────────────────────────────
  static ThemeData get lightTheme => _buildTheme(Brightness.light);

  // ── Constructor de tema ──────────────────────────────────────────
  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final bgColor      = isDark ? black      : lightBg;
    final surfaceColor = isDark ? surface    : lightSurface;
    final surface2Color= isDark ? surface2   : lightSurface2;
    final borderColor  = isDark ? border     : lightBorder;
    final textColor    = isDark ? white      : lightText;
    final greyColor    = isDark ? grey       : lightGrey;
    final greyLColor   = isDark ? greyLight  : lightGrey;
    final fillColor    = isDark ? surface2   : lightSurface;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: bgColor,
      colorScheme: ColorScheme(
        brightness: brightness,
        background: bgColor,
        surface: surfaceColor,
        primary: blue,
        secondary: red,
        onPrimary: white,
        onSecondary: white,
        onSurface: textColor,
        onBackground: textColor,
        error: redLight,
        onError: white,
      ),
      textTheme: GoogleFonts.dmSansTextTheme(
        TextTheme(
          displayLarge: TextStyle(color: textColor,  fontSize: 36, fontWeight: FontWeight.w700),
          titleLarge:   TextStyle(color: textColor,  fontSize: 20, fontWeight: FontWeight.w600),
          titleMedium:  TextStyle(color: textColor,  fontSize: 16, fontWeight: FontWeight.w500),
          bodyLarge:    TextStyle(color: textColor,  fontSize: 15),
          bodyMedium:   TextStyle(color: greyLColor, fontSize: 13),
          bodySmall:    TextStyle(color: greyColor,  fontSize: 11),
          labelLarge:   TextStyle(color: textColor,  fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.bebasNeue(
          color: textColor, fontSize: 22, letterSpacing: 3,
        ),
        iconTheme: IconThemeData(color: textColor),
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
          foregroundColor: isDark ? goldWhite : blue,
          side: BorderSide(color: isDark ? goldWhite : blue, width: 1),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: blue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: red, width: 1),
        ),
        hintStyle:  TextStyle(color: greyColor,  fontSize: 14),
        labelStyle: TextStyle(color: greyLColor, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: borderColor, width: 0.5),
        ),
      ),
      dividerTheme: DividerThemeData(color: borderColor, thickness: 0.5),
    );
  }

  // Mantenim per compatibilitat — apunta al tema fosc
  static ThemeData get theme => darkTheme;
}
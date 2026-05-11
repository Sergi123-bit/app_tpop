import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {

  // ── Colores fijos (independientes del tema) ──────────────────────
  static const Color blue      = Color(0xFF1A3AFF);
  static const Color blueLight = Color(0xFF4D6FFF);
  static const Color red       = Color(0xFFDD1111);
  static const Color redLight  = Color(0xFFFF4444);

  // ── Colores modo oscuro ──────────────────────────────────────────
  static const Color black     = Color(0xFF0A0A0F);
  static const Color ash       = Color(0xFF1C1C28);
  static const Color ash2      = Color(0xFF2A2A3A);
  static const Color goldWhite = Color(0xFFF5E6C8);
  static const Color white     = Color(0xFFF8F8FF);
  static const Color grey      = Color(0xFF8A8A9A);
  static const Color greyLight = Color(0xFFB0B0C0);
  static const Color surface   = Color(0xFF16161F);
  static const Color surface2  = Color(0xFF202030);
  static const Color border    = Color(0x33F5E6C8);

  // ── Colores modo claro ───────────────────────────────────────────
  static const Color lightBg       = Color(0xFFF2F2F7);
  static const Color lightSurface  = Color(0xFFFFFFFF);
  static const Color lightSurface2 = Color(0xFFE8E8F0);
  static const Color lightBorder   = Color(0xFFDDDDEE);
  static const Color lightText     = Color(0xFF0A0A0F);
  static const Color lightGrey     = Color(0xFF666677);
  static const Color lightGoldWhite= Color(0xFF3A3A4A);

  // ────────────────────────────────────────────────────────────────
  // Helpers de contexto — úsalos en las pantallas en vez de las
  // constantes directas. Se adaptan automáticamente al tema activo.
  // ────────────────────────────────────────────────────────────────

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  /// Fondo principal de la app
  static Color bgColor(BuildContext context) =>
      isDark(context) ? black : lightBg;

  /// Superficie de tarjetas / contenedores
  static Color surfaceColor(BuildContext context) =>
      isDark(context) ? surface : lightSurface;

  /// Superficie secundaria (inputs, chips...)
  static Color surface2Color(BuildContext context) =>
      isDark(context) ? surface2 : lightSurface2;

  /// Color de ash2 (fondos de imagen vacía)
  static Color ash2Color(BuildContext context) =>
      isDark(context) ? ash2 : lightSurface2;

  /// Borde de contenedores
  static Color borderColor(BuildContext context) =>
      isDark(context) ? border : lightBorder;

  /// Texto principal
  static Color textColor(BuildContext context) =>
      isDark(context) ? white : lightText;

  /// Texto secundario
  static Color greyColor(BuildContext context) =>
      isDark(context) ? grey : lightGrey;

  /// Texto terciario / subtítulos
  static Color greyLightColor(BuildContext context) =>
      isDark(context) ? greyLight : lightGrey;

  /// Color dorado/crema (talles, etiquetas)
  static Color goldColor(BuildContext context) =>
      isDark(context) ? goldWhite : lightGoldWhite;

  // ── Tema oscuro ──────────────────────────────────────────────────
  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  // ── Tema claro ───────────────────────────────────────────────────
  static ThemeData get lightTheme => _buildTheme(Brightness.light);

  // ── Constructor de tema ──────────────────────────────────────────
  static ThemeData _buildTheme(Brightness brightness) {
    final isDarkMode = brightness == Brightness.dark;

    final bgCol      = isDarkMode ? black      : lightBg;
    final surfaceCol = isDarkMode ? surface    : lightSurface;
    final surface2Col= isDarkMode ? surface2   : lightSurface2;
    final borderCol  = isDarkMode ? border     : lightBorder;
    final textCol    = isDarkMode ? white      : lightText;
    final greyCol    = isDarkMode ? grey       : lightGrey;
    final greyLCol   = isDarkMode ? greyLight  : lightGrey;
    final fillCol    = isDarkMode ? surface2   : lightSurface;
    final goldCol    = isDarkMode ? goldWhite  : lightGoldWhite;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: bgCol,
      colorScheme: ColorScheme(
        brightness: brightness,
        background: bgCol,
        surface: surfaceCol,
        primary: blue,
        secondary: red,
        onPrimary: white,
        onSecondary: white,
        onSurface: textCol,
        onBackground: textCol,
        error: redLight,
        onError: white,
      ),
      textTheme: GoogleFonts.dmSansTextTheme(
        TextTheme(
          displayLarge: TextStyle(color: textCol,  fontSize: 36, fontWeight: FontWeight.w700),
          titleLarge:   TextStyle(color: textCol,  fontSize: 20, fontWeight: FontWeight.w600),
          titleMedium:  TextStyle(color: textCol,  fontSize: 16, fontWeight: FontWeight.w500),
          bodyLarge:    TextStyle(color: textCol,  fontSize: 15),
          bodyMedium:   TextStyle(color: greyLCol, fontSize: 13),
          bodySmall:    TextStyle(color: greyCol,  fontSize: 11),
          labelLarge:   TextStyle(color: textCol,  fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bgCol,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.bebasNeue(
          color: textCol, fontSize: 22, letterSpacing: 3,
        ),
        iconTheme: IconThemeData(color: textCol),
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
          foregroundColor: isDarkMode ? goldWhite : blue,
          side: BorderSide(color: isDarkMode ? goldWhite : blue, width: 1),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: fillCol,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderCol),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderCol, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: blue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: red, width: 1),
        ),
        hintStyle:  TextStyle(color: greyCol,  fontSize: 14),
        labelStyle: TextStyle(color: greyLCol, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      cardTheme: CardThemeData(
        color: surfaceCol,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: borderCol, width: 0.5),
        ),
      ),
      dividerTheme: DividerThemeData(color: borderCol, thickness: 0.5),
    );
  }

  static ThemeData get theme => darkTheme;
}

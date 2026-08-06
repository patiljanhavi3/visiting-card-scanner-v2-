import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // ================= COLORS =================

  static const Color primaryColor = Color(0xFF2563EB);

  static const Color secondaryColor = Color(0xFF10B981);

  static const Color backgroundColor = Color(0xFFF8FAFC);

  static const Color surfaceColor = Colors.white;

  static const Color cardColor = Colors.white;

  static const Color errorColor = Color(0xFFDC2626);

  static const Color warningColor = Color(0xFFF59E0B);

  static const Color successColor = Color(0xFF16A34A);

  static const Color textPrimary = Color(0xFF111827);

  static const Color textSecondary = Color(0xFF6B7280);

  static const Color dividerColor = Color(0xFFE5E7EB);

  // ================= THEME =================

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,

      colorScheme: colorScheme,

      scaffoldBackgroundColor: backgroundColor,

      primaryColor: primaryColor,

      splashFactory: InkRipple.splashFactory,

      visualDensity: VisualDensity.adaptivePlatformDensity,

      // ================= APPBAR =================
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: textPrimary,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),

      // ================= CARD =================
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 2,
        shadowColor: Colors.black12,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // ================= BUTTON =================
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 54),
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),

      // ================= INPUT =================
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),

        hintStyle: const TextStyle(color: textSecondary),

        labelStyle: const TextStyle(color: textSecondary),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: dividerColor),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: dividerColor),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: errorColor),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
      ),

      // ================= CHIP =================
      chipTheme: ChipThemeData(
        backgroundColor: primaryColor.withValues(alpha: 0.08),
        selectedColor: primaryColor,
        labelStyle: const TextStyle(color: textPrimary),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),

      // ================= SNACKBAR =================
      snackBarTheme: SnackBarThemeData(
        backgroundColor: textPrimary,
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 15),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // ================= DIVIDER =================
      dividerTheme: const DividerThemeData(color: dividerColor, thickness: 1),

      // ================= TEXT =================
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: textPrimary),
        bodyMedium: TextStyle(fontSize: 14, color: textSecondary),
        bodySmall: TextStyle(fontSize: 12, color: textSecondary),
      ),
    );
  }
}

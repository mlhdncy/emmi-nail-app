import 'package:flutter/material.dart';

class AppColors {
  // Primärfarben - Brand Guideline sayfa 10
  static const Color emmiRed = Color(0xFFE40024);
  static const Color emmiBlack = Color(0xFF1A1B17);
  static const Color emmiWhite = Color(0xFFFFFEF7);

  // Sekundärfarben - Brand Guideline sayfa 11
  static const Color emmiRedSecondary = Color(0xFFAC0021);
  static const Color emmiBeige = Color(0xFFEEE9E1);
  static const Color emmiGrey = Color(0xFFF3F3F3);

  // Uygulama için ek renkler
  static const Color primary = emmiRed;
  static const Color primaryLight = Color(0xFFFF6B85);
  static const Color primaryDark = emmiRedSecondary;

  static const Color background = emmiWhite;
  static const Color surface = emmiBeige;
  static const Color surfaceDark = emmiBlack;

  static const Color textPrimary = emmiBlack;
  static const Color textSecondary = Color(0xFF666666);
  static const Color textOnPrimary = emmiWhite;

  static const Color accent = emmiBlack;
  static const Color accentLight = Color(0xFF4A4A4A);

  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryLight,
        secondary: AppColors.accent,
        background: AppColors.background,
        surface: AppColors.surface,
        error: AppColors.error,
        brightness: Brightness.light,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      // Icon Theme for proper icon display
      iconTheme: IconThemeData(color: AppColors.emmiBlack, size: 24),

      primaryIconTheme: IconThemeData(color: AppColors.emmiWhite, size: 24),

      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: AppColors.surface,
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600, // Silka SemiBold for headlines
          color: AppColors.textPrimary,
          fontFamily: 'Silka',
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500, // Silka Medium
          color: AppColors.textPrimary,
          fontFamily: 'Silka',
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600, // Silka SemiBold
          color: AppColors.textPrimary,
          fontFamily: 'Silka',
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500, // Silka Medium
          color: AppColors.textPrimary,
          fontFamily: 'Silka',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300, // Silka Light for body text
          color: AppColors.textPrimary,
          fontFamily: 'Silka',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w300, // Silka Light
          color: AppColors.textSecondary,
          fontFamily: 'Silka',
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryDark,
        secondary: AppColors.accentLight,
        background: AppColors.accent,
        surface: AppColors.surfaceDark,
        error: AppColors.error,
        brightness: Brightness.dark,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.textOnPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      // Dark theme icon settings
      iconTheme: IconThemeData(color: AppColors.emmiWhite, size: 24),

      primaryIconTheme: IconThemeData(color: AppColors.emmiBlack, size: 24),

      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: AppColors.surfaceDark,
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.accent,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textOnPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textOnPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textOnPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textOnPrimary,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: AppColors.textOnPrimary),
        bodyMedium: TextStyle(fontSize: 14, color: AppColors.textSecondary),
      ),
    );
  }
}

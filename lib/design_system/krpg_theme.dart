import 'package:flutter/material.dart';

/// KRPG Design System - Theme
/// 
/// This class defines the global design system for the SiMenang KRPG app,
/// mirroring the web application's design patterns.
class KRPGTheme {
  // Private constructor to prevent instantiation
  KRPGTheme._();
  
  // Brand Colors
  static const Color primaryColor = Color(0xFF2563EB); // Blue 600
  static const Color secondaryColor = Color(0xFF10B981); // Emerald 500
  static const Color accentColor = Color(0xFFF97316); // Orange 500
  
  // Neutral Colors
  static const Color neutralDark = Color(0xFF1F2937); // Gray 800
  static const Color neutralMedium = Color(0xFF6B7280); // Gray 500
  static const Color neutralLight = Color(0xFFF3F4F6); // Gray 100
  
  // Semantic Colors
  static const Color successColor = Color(0xFF10B981); // Emerald 500
  static const Color warningColor = Color(0xFFF59E0B); // Amber 500
  static const Color dangerColor = Color(0xFFEF4444); // Red 500
  static const Color infoColor = Color(0xFF3B82F6); // Blue 500
  
  // Text Colors
  static const Color textDark = Color(0xFF1F2937); // Gray 800
  static const Color textMedium = Color(0xFF6B7280); // Gray 500
  static const Color textLight = Color(0xFFE5E7EB); // Gray 200
  
  // Background Colors
  static const Color backgroundPrimary = Color(0xFFFFFFFF); // White
  static const Color backgroundSecondary = Color(0xFFF9FAFB); // Gray 50
  static const Color backgroundTertiary = Color(0xFFF3F4F6); // Gray 100
  
  // Border Colors
  static const Color borderColor = Color(0xFFE5E7EB); // Gray 200
  static const Color borderColorDark = Color(0xFFD1D5DB); // Gray 300
  
  // Elevation (Shadow) Levels
  static List<BoxShadow> get shadowSmall => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];
  
  static List<BoxShadow> get shadowMedium => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> get shadowLarge => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
  
  // Spacing Scale (in pixels)
  static const double spacingXxs = 2;
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;
  static const double spacingXxl = 48;
  
  // Border Radius
  static const double radiusXs = 4;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusRound = 9999;
  
  // Font Sizes
  static const double fontSizeXs = 12;
  static const double fontSizeSm = 14;
  static const double fontSizeMd = 16;
  static const double fontSizeLg = 18;
  static const double fontSizeXl = 20;
  static const double fontSize2xl = 24;
  static const double fontSize3xl = 30;
  static const double fontSize4xl = 36;
  
  // Font Weights
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;
  
  // Line Heights
  static const double lineHeightTight = 1.25;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightRelaxed = 1.75;
  
  // Animation Durations
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 250);
  static const Duration durationSlow = Duration(milliseconds: 350);
  
  // Get the ThemeData for the app
  static ThemeData get lightTheme {
    return ThemeData(
      // Color Scheme
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: dangerColor,
        background: backgroundPrimary,
        surface: backgroundPrimary,
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: fontSize4xl,
          fontWeight: fontWeightBold,
          color: textDark,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: fontSize3xl,
          fontWeight: fontWeightBold,
          color: textDark,
        ),
        displaySmall: TextStyle(
          fontSize: fontSize2xl,
          fontWeight: fontWeightBold,
          color: textDark,
        ),
        headlineMedium: TextStyle(
          fontSize: fontSizeXl,
          fontWeight: fontWeightSemiBold,
          color: textDark,
        ),
        headlineSmall: TextStyle(
          fontSize: fontSizeLg,
          fontWeight: fontWeightSemiBold,
          color: textDark,
        ),
        titleLarge: TextStyle(
          fontSize: fontSizeMd,
          fontWeight: fontWeightSemiBold,
          color: textDark,
        ),
        bodyLarge: TextStyle(
          fontSize: fontSizeMd,
          fontWeight: fontWeightRegular,
          color: textDark,
        ),
        bodyMedium: TextStyle(
          fontSize: fontSizeSm,
          fontWeight: fontWeightRegular,
          color: textDark,
        ),
        labelLarge: TextStyle(
          fontSize: fontSizeSm,
          fontWeight: fontWeightMedium,
          color: textDark,
        ),
      ),
      
      // Component Themes
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingMd,
            vertical: spacingSm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSm),
          ),
          textStyle: const TextStyle(
            fontSize: fontSizeSm,
            fontWeight: fontWeightMedium,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingMd,
            vertical: spacingSm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSm),
          ),
          textStyle: const TextStyle(
            fontSize: fontSizeSm,
            fontWeight: fontWeightMedium,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingSm,
            vertical: spacingXs,
          ),
          textStyle: const TextStyle(
            fontSize: fontSizeSm,
            fontWeight: fontWeightMedium,
          ),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundPrimary,
        contentPadding: const EdgeInsets.all(spacingMd),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: const BorderSide(color: dangerColor),
        ),
        labelStyle: const TextStyle(
          color: textMedium,
          fontSize: fontSizeSm,
        ),
        hintStyle: const TextStyle(
          color: neutralMedium,
          fontSize: fontSizeSm,
        ),
      ),
      
      cardTheme: CardTheme(
        color: backgroundPrimary,
        elevation: 2,
        margin: const EdgeInsets.all(spacingSm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
      ),
      
      // Miscellaneous
      scaffoldBackgroundColor: backgroundSecondary,
      dividerColor: borderColor,
      disabledColor: neutralMedium,
      
      // Material 3
      useMaterial3: true,
    );
  }
  
  // Dark theme could be added here if needed
} 
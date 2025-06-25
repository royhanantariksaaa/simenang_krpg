import 'package:flutter/material.dart';

/// KRPG Design System - Enhanced Green Chromatic Theme
/// 
/// This class defines the enhanced design system for the SiMenang KRPG app
/// with a rich, chromatic green color palette for better visual variety.
class KRPGTheme {
  // Private constructor to prevent instantiation
  KRPGTheme._();
  
  // Enhanced Green Color Palette - Chromatic Variations
  static const Color primaryGreen = Color(0xFF10B981); // Emerald 500 - Main brand
  static const Color primaryGreenDark = Color(0xFF059669); // Emerald 600 - Darker primary
  static const Color primaryGreenLight = Color(0xFF34D399); // Emerald 400 - Lighter primary
  static const Color primaryGreenVeryLight = Color(0xFF6EE7B7); // Emerald 300 - Very light
  
  // Forest Green Variations
  static const Color forestGreen = Color(0xFF047857); // Emerald 700
  static const Color forestGreenDark = Color(0xFF065F46); // Emerald 800
  static const Color forestGreenVeryDark = Color(0xFF064E3B); // Emerald 900
  
  // Mint & Jade Variations
  static const Color mintGreen = Color(0xFFA7F3D0); // Emerald 200
  static const Color jadeGreen = Color(0xFF6EE7B7); // Emerald 300
  static const Color seafoamGreen = Color(0xFFD1FAE5); // Emerald 100
  static const Color paleGreen = Color(0xFFECFDF5); // Emerald 50
  
  // Complementary Colors for Contrast
  static const Color tealAccent = Color(0xFF14B8A6); // Teal 500
  static const Color limeMedium = Color(0xFF65A30D); // Lime 600
  static const Color oliveGreen = Color(0xFF84CC16); // Lime 500
  
  // Warm Complementary Colors
  static const Color warmOrange = Color(0xFFF97316); // Orange 500
  static const Color warmAmber = Color(0xFFFBBF24); // Amber 400
  static const Color coralPink = Color(0xFFF472B6); // Pink 400
  
  // Updated Brand Colors
  static const Color primaryColor = primaryGreen;
  static const Color secondaryColor = tealAccent;
  static const Color accentColor = warmOrange;
  static const Color tertiaryColor = limeMedium;
  
  // Enhanced Neutral Colors with Green Tints
  static const Color neutralDark = Color(0xFF1F2937); // Gray 800
  static const Color neutralMedium = Color(0xFF6B7280); // Gray 500
  static const Color neutralLight = Color(0xFFF3F4F6); // Gray 100
  static const Color neutralGreenTint = Color(0xFFF0FDF4); // Green-tinted neutral
  
  // Enhanced Semantic Colors
  static const Color successColor = primaryGreen;
  static const Color successColorLight = mintGreen;
  static const Color warningColor = warmAmber;
  static const Color warningColorLight = Color(0xFFFEF3C7); // Amber 100
  static const Color dangerColor = Color(0xFFEF4444); // Red 500
  static const Color dangerColorLight = Color(0xFFFEE2E2); // Red 100
  static const Color infoColor = tealAccent;
  static const Color infoColorLight = Color(0xFFCCFBF1); // Teal 100
  
  // Text Colors with Green Harmony
  static const Color textDark = Color(0xFF065F46); // Dark emerald for better harmony
  static const Color textMedium = Color(0xFF6B7280); // Gray 500
  static const Color textLight = Color(0xFFE5E7EB); // Gray 200
  static const Color textOnGreen = Color(0xFFFFFFFF); // White on green backgrounds
  static const Color textAccent = primaryGreenDark; // Green accent text
  
  // Enhanced Background Colors
  static const Color backgroundPrimary = Color(0xFFFFFFFF); // White
  static const Color backgroundSecondary = neutralGreenTint; // Green-tinted background
  static const Color backgroundTertiary = seafoamGreen; // Very light green
  static const Color backgroundCard = Color(0xFFFAFAFA); // Slightly warm white
  static const Color backgroundAccent = paleGreen; // Pale green for highlights
  
  // Border Colors with Green Variations
  static const Color borderColor = Color(0xFFE5E7EB); // Gray 200
  static const Color borderColorDark = Color(0xFFD1D5DB); // Gray 300
  static const Color borderColorGreen = mintGreen; // Green border
  static const Color borderColorAccent = primaryGreenLight; // Accent green border
  
  // Gradient Definitions
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGreen, primaryGreenDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient successGradient = LinearGradient(
    colors: [primaryGreenLight, primaryGreen],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [tealAccent, primaryGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [paleGreen, seafoamGreen],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
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
      // Enhanced Color Scheme with Green Variations
      primaryColor: primaryColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        primaryContainer: primaryGreenLight,
        secondary: secondaryColor,
        secondaryContainer: Color(0xFFCCFBF1), // Teal 100
        tertiary: tertiaryColor,
        tertiaryContainer: Color(0xFFECFCCB), // Lime 100
        error: dangerColor,
        errorContainer: dangerColorLight,
        background: backgroundSecondary,
        surface: backgroundPrimary,
        surfaceVariant: backgroundAccent,
        outline: borderColorGreen,
        onPrimary: textOnGreen,
        onSecondary: textOnGreen,
        onTertiary: textOnGreen,
        onError: textOnGreen,
        onBackground: textDark,
        onSurface: textDark,
        onSurfaceVariant: textMedium,
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
      
      // Enhanced Component Themes
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: textOnGreen,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: textOnGreen),
        titleTextStyle: TextStyle(
          color: textOnGreen,
          fontSize: fontSizeLg,
          fontWeight: fontWeightSemiBold,
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textOnGreen,
          elevation: 3,
          shadowColor: primaryGreenDark.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingMd,
            vertical: spacingSm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
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
          backgroundColor: backgroundAccent,
          side: BorderSide(color: primaryGreenLight, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingMd,
            vertical: spacingSm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
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
        color: backgroundCard,
        elevation: 3,
        shadowColor: primaryGreen.withOpacity(0.1),
        margin: const EdgeInsets.all(spacingSm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: BorderSide(color: borderColorGreen.withOpacity(0.3), width: 0.5),
        ),
      ),
      
      // Enhanced Miscellaneous Colors
      scaffoldBackgroundColor: backgroundSecondary,
      dividerColor: borderColorGreen,
      disabledColor: neutralMedium.withOpacity(0.6),
      highlightColor: primaryGreenVeryLight.withOpacity(0.3),
      splashColor: primaryGreenLight.withOpacity(0.2),
      
      // Material 3
      useMaterial3: true,
    );
  }
  
  // Dark theme could be added here if needed
} 
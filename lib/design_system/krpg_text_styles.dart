import 'package:flutter/material.dart';
import 'krpg_theme.dart';

/// KRPG Design System - Text Styles
/// 
/// This class defines consistent text styles to be used throughout the app.
class KRPGTextStyles {
  // Private constructor to prevent instantiation
  KRPGTextStyles._();
  
  // Headings
  static const TextStyle heading1 = TextStyle(
    fontSize: KRPGTheme.fontSize4xl,
    fontWeight: KRPGTheme.fontWeightBold,
    color: KRPGTheme.textDark,
    height: KRPGTheme.lineHeightTight,
    letterSpacing: -0.5,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: KRPGTheme.fontSize3xl,
    fontWeight: KRPGTheme.fontWeightBold,
    color: KRPGTheme.textDark,
    height: KRPGTheme.lineHeightTight,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: KRPGTheme.fontSize2xl,
    fontWeight: KRPGTheme.fontWeightBold,
    color: KRPGTheme.textDark,
    height: KRPGTheme.lineHeightTight,
  );
  
  static const TextStyle heading4 = TextStyle(
    fontSize: KRPGTheme.fontSizeXl,
    fontWeight: KRPGTheme.fontWeightSemiBold,
    color: KRPGTheme.textDark,
    height: KRPGTheme.lineHeightTight,
  );
  
  static const TextStyle heading5 = TextStyle(
    fontSize: KRPGTheme.fontSizeLg,
    fontWeight: KRPGTheme.fontWeightSemiBold,
    color: KRPGTheme.textDark,
    height: KRPGTheme.lineHeightTight,
  );
  
  static const TextStyle heading6 = TextStyle(
    fontSize: KRPGTheme.fontSizeMd,
    fontWeight: KRPGTheme.fontWeightSemiBold,
    color: KRPGTheme.textDark,
    height: KRPGTheme.lineHeightTight,
  );
  
  // Body text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: KRPGTheme.fontSizeMd,
    fontWeight: KRPGTheme.fontWeightRegular,
    color: KRPGTheme.textDark,
    height: KRPGTheme.lineHeightNormal,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: KRPGTheme.fontSizeSm,
    fontWeight: KRPGTheme.fontWeightRegular,
    color: KRPGTheme.textDark,
    height: KRPGTheme.lineHeightNormal,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: KRPGTheme.fontSizeXs,
    fontWeight: KRPGTheme.fontWeightRegular,
    color: KRPGTheme.textDark,
    height: KRPGTheme.lineHeightNormal,
  );
  
  static final TextStyle bodySmallSecondary = bodySmall.copyWith(
    color: KRPGTheme.neutralMedium,
  );
  
  // Labels
  static const TextStyle labelLarge = TextStyle(
    fontSize: KRPGTheme.fontSizeSm,
    fontWeight: KRPGTheme.fontWeightMedium,
    color: KRPGTheme.textDark,
    letterSpacing: 0.25,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontSize: KRPGTheme.fontSizeXs,
    fontWeight: KRPGTheme.fontWeightMedium,
    color: KRPGTheme.textDark,
    letterSpacing: 0.25,
  );
  
  // Button text
  static const TextStyle buttonLarge = TextStyle(
    fontSize: KRPGTheme.fontSizeMd,
    fontWeight: KRPGTheme.fontWeightMedium,
    height: 1,
    letterSpacing: 0.25,
  );
  
  static const TextStyle buttonMedium = TextStyle(
    fontSize: KRPGTheme.fontSizeSm,
    fontWeight: KRPGTheme.fontWeightMedium,
    height: 1,
    letterSpacing: 0.25,
  );
  
  static const TextStyle buttonSmall = TextStyle(
    fontSize: KRPGTheme.fontSizeXs,
    fontWeight: KRPGTheme.fontWeightMedium,
    height: 1,
    letterSpacing: 0.25,
  );
  
  // Caption
  static const TextStyle caption = TextStyle(
    fontSize: KRPGTheme.fontSizeXs,
    fontWeight: KRPGTheme.fontWeightRegular,
    color: KRPGTheme.textMedium,
    height: KRPGTheme.lineHeightNormal,
  );
  
  // Helper variants
  static TextStyle bodyLargeMedium = bodyLarge.copyWith(
    fontWeight: KRPGTheme.fontWeightMedium,
  );
  
  static TextStyle bodyLargeSemiBold = bodyLarge.copyWith(
    fontWeight: KRPGTheme.fontWeightSemiBold,
  );
  
  static TextStyle bodyMediumMedium = bodyMedium.copyWith(
    fontWeight: KRPGTheme.fontWeightMedium,
  );
  
  static TextStyle bodyMediumSemiBold = bodyMedium.copyWith(
    fontWeight: KRPGTheme.fontWeightSemiBold,
  );
  
  // Color variants
  static TextStyle bodyLargeSecondary = bodyLarge.copyWith(
    color: KRPGTheme.textMedium,
  );
  
  static TextStyle bodyMediumSecondary = bodyMedium.copyWith(
    color: KRPGTheme.textMedium,
  );
  
  // Special text styles
  static const TextStyle cardTitle = TextStyle(
    fontSize: KRPGTheme.fontSizeMd,
    fontWeight: KRPGTheme.fontWeightSemiBold,
    color: KRPGTheme.textDark,
    height: KRPGTheme.lineHeightTight,
  );
  
  static const TextStyle cardSubtitle = TextStyle(
    fontSize: KRPGTheme.fontSizeSm,
    fontWeight: KRPGTheme.fontWeightRegular,
    color: KRPGTheme.textMedium,
    height: KRPGTheme.lineHeightNormal,
  );
  
  static const TextStyle statNumber = TextStyle(
    fontSize: KRPGTheme.fontSize2xl,
    fontWeight: KRPGTheme.fontWeightBold,
    color: KRPGTheme.textDark,
    height: 1,
  );
  
  static const TextStyle statLabel = TextStyle(
    fontSize: KRPGTheme.fontSizeXs,
    fontWeight: KRPGTheme.fontWeightMedium,
    color: KRPGTheme.textMedium,
    letterSpacing: 0.5,
  );
} 
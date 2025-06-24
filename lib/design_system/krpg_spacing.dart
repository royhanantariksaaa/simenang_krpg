import 'package:flutter/material.dart';
import 'krpg_theme.dart';

/// KRPG Design System - Spacing
/// 
/// This class provides consistent spacing widgets to be used throughout the app.
class KRPGSpacing {
  // Private constructor to prevent instantiation
  KRPGSpacing._();
  
  // Vertical spacing
  static const SizedBox verticalXXS = SizedBox(height: KRPGTheme.spacingXxs);
  static const SizedBox verticalXS = SizedBox(height: KRPGTheme.spacingXs);
  static const SizedBox verticalSM = SizedBox(height: KRPGTheme.spacingSm);
  static const SizedBox verticalMD = SizedBox(height: KRPGTheme.spacingMd);
  static const SizedBox verticalLG = SizedBox(height: KRPGTheme.spacingLg);
  static const SizedBox verticalXL = SizedBox(height: KRPGTheme.spacingXl);
  static const SizedBox verticalXXL = SizedBox(height: KRPGTheme.spacingXxl);
  
  // Horizontal spacing
  static const SizedBox horizontalXXS = SizedBox(width: KRPGTheme.spacingXxs);
  static const SizedBox horizontalXS = SizedBox(width: KRPGTheme.spacingXs);
  static const SizedBox horizontalSM = SizedBox(width: KRPGTheme.spacingSm);
  static const SizedBox horizontalMD = SizedBox(width: KRPGTheme.spacingMd);
  static const SizedBox horizontalLG = SizedBox(width: KRPGTheme.spacingLg);
  static const SizedBox horizontalXL = SizedBox(width: KRPGTheme.spacingXl);
  static const SizedBox horizontalXXL = SizedBox(width: KRPGTheme.spacingXxl);
  
  // Padding
  static const EdgeInsets paddingXXS = EdgeInsets.all(KRPGTheme.spacingXxs);
  static const EdgeInsets paddingXS = EdgeInsets.all(KRPGTheme.spacingXs);
  static const EdgeInsets paddingSM = EdgeInsets.all(KRPGTheme.spacingSm);
  static const EdgeInsets paddingMD = EdgeInsets.all(KRPGTheme.spacingMd);
  static const EdgeInsets paddingLG = EdgeInsets.all(KRPGTheme.spacingLg);
  static const EdgeInsets paddingXL = EdgeInsets.all(KRPGTheme.spacingXl);
  static const EdgeInsets paddingXXL = EdgeInsets.all(KRPGTheme.spacingXxl);
  
  // Horizontal padding
  static const EdgeInsets paddingHorizontalXXS = EdgeInsets.symmetric(horizontal: KRPGTheme.spacingXxs);
  static const EdgeInsets paddingHorizontalXS = EdgeInsets.symmetric(horizontal: KRPGTheme.spacingXs);
  static const EdgeInsets paddingHorizontalSM = EdgeInsets.symmetric(horizontal: KRPGTheme.spacingSm);
  static const EdgeInsets paddingHorizontalMD = EdgeInsets.symmetric(horizontal: KRPGTheme.spacingMd);
  static const EdgeInsets paddingHorizontalLG = EdgeInsets.symmetric(horizontal: KRPGTheme.spacingLg);
  static const EdgeInsets paddingHorizontalXL = EdgeInsets.symmetric(horizontal: KRPGTheme.spacingXl);
  static const EdgeInsets paddingHorizontalXXL = EdgeInsets.symmetric(horizontal: KRPGTheme.spacingXxl);
  
  // Vertical padding
  static const EdgeInsets paddingVerticalXXS = EdgeInsets.symmetric(vertical: KRPGTheme.spacingXxs);
  static const EdgeInsets paddingVerticalXS = EdgeInsets.symmetric(vertical: KRPGTheme.spacingXs);
  static const EdgeInsets paddingVerticalSM = EdgeInsets.symmetric(vertical: KRPGTheme.spacingSm);
  static const EdgeInsets paddingVerticalMD = EdgeInsets.symmetric(vertical: KRPGTheme.spacingMd);
  static const EdgeInsets paddingVerticalLG = EdgeInsets.symmetric(vertical: KRPGTheme.spacingLg);
  static const EdgeInsets paddingVerticalXL = EdgeInsets.symmetric(vertical: KRPGTheme.spacingXl);
  static const EdgeInsets paddingVerticalXXL = EdgeInsets.symmetric(vertical: KRPGTheme.spacingXxl);
  
  // Helper method to create custom spacing
  static SizedBox vertical(double height) => SizedBox(height: height);
  static SizedBox horizontal(double width) => SizedBox(width: width);
  
  // Helper method to get screen-relative spacing
  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Adjust spacing based on screen size
    if (screenWidth < 360) {
      return baseSpacing * 0.8; // Smaller screens
    } else if (screenWidth > 600) {
      return baseSpacing * 1.2; // Larger screens/tablets
    }
    
    return baseSpacing; // Default for normal phone screens
  }
  
  // Helper method to get responsive padding
  static EdgeInsets getResponsivePadding(BuildContext context, {
    double horizontal = KRPGTheme.spacingMd,
    double vertical = KRPGTheme.spacingMd,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    double horizontalPadding = horizontal;
    double verticalPadding = vertical;
    
    // Adjust padding based on screen size
    if (screenWidth < 360) {
      horizontalPadding = horizontal * 0.8;
      verticalPadding = vertical * 0.8;
    } else if (screenWidth > 600) {
      horizontalPadding = horizontal * 1.2;
      verticalPadding = vertical * 1.2;
    }
    
    return EdgeInsets.symmetric(
      horizontal: horizontalPadding,
      vertical: verticalPadding,
    );
  }
  
  // Screen edge padding (safe area consideration)
  static EdgeInsets screenEdgePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Base padding
    double padding = KRPGTheme.spacingMd;
    
    // Adjust based on screen width
    if (screenWidth < 360) {
      padding = KRPGTheme.spacingSm;
    } else if (screenWidth >= 600) {
      padding = KRPGTheme.spacingLg;
    }
    
    return EdgeInsets.symmetric(horizontal: padding);
  }
} 
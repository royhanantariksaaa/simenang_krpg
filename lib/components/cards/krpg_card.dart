import 'package:flutter/material.dart';
import '../../design_system/krpg_design_system.dart';

class KRPGCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final bool isSelected;
  final Color? selectedColor;

  const KRPGCard({
    super.key,
    required this.child,
    this.onTap,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.isSelected = false,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final cardChild = Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? KRPGTheme.backgroundPrimary,
        borderRadius: BorderRadius.circular(KRPGTheme.radiusMd),
        border: isSelected 
            ? Border.all(
                color: selectedColor ?? KRPGTheme.primaryColor,
                width: 2.0,
              )
            : null,
        boxShadow: KRPGTheme.shadowMedium,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(KRPGTheme.radiusMd),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(KRPGTheme.radiusMd),
          child: Padding(
            padding: padding ?? KRPGSpacing.paddingMD,
            child: child,
          ),
        ),
      ),
    );

    if (margin != null) {
      return Padding(
        padding: margin!,
        child: cardChild,
      );
    }

    return cardChild;
  }

  // Factory constructors for different card types - all using uniform styling
  
  /// Creates a dashboard card - used for main dashboard widgets
  factory KRPGCard.dashboard({
    required Widget child,
    VoidCallback? onTap,
    bool isSelected = false,
  }) {
    return KRPGCard(
      onTap: onTap,
      margin: KRPGSpacing.paddingSM,
      padding: KRPGSpacing.paddingMD,
      backgroundColor: KRPGTheme.backgroundPrimary,
      isSelected: isSelected,
      child: child,
    );
  }

  /// Creates a list card - used for list items
  factory KRPGCard.list({
    required Widget child,
    VoidCallback? onTap,
    bool isSelected = false,
  }) {
    return KRPGCard(
      onTap: onTap,
      margin: const EdgeInsets.symmetric(
        horizontal: KRPGTheme.spacingSm,
        vertical: KRPGTheme.spacingXs,
      ),
      padding: KRPGSpacing.paddingMD,
      backgroundColor: KRPGTheme.backgroundPrimary,
      isSelected: isSelected,
      child: child,
    );
  }

  /// Creates a stats card - used for displaying statistics
  factory KRPGCard.stats({
    required Widget child,
    VoidCallback? onTap,
    bool isSelected = false,
  }) {
    return KRPGCard(
      onTap: onTap,
      margin: KRPGSpacing.paddingSM,
      padding: KRPGSpacing.paddingMD,
      backgroundColor: KRPGTheme.backgroundPrimary,
      isSelected: isSelected,
      child: child,
    );
  }

  /// Creates a training card - used for training information
  factory KRPGCard.training({
    required Widget child,
    VoidCallback? onTap,
    bool isSelected = false,
  }) {
    return KRPGCard(
      onTap: onTap,
      margin: const EdgeInsets.symmetric(
        horizontal: KRPGTheme.spacingSm,
        vertical: KRPGTheme.spacingXs,
      ),
      padding: KRPGSpacing.paddingMD,
      backgroundColor: KRPGTheme.backgroundPrimary,
      isSelected: isSelected,
      child: child,
    );
  }

  /// Creates a competition card - used for competition information
  factory KRPGCard.competition({
    required Widget child,
    VoidCallback? onTap,
    bool isSelected = false,
  }) {
    return KRPGCard(
      onTap: onTap,
      margin: const EdgeInsets.symmetric(
        horizontal: KRPGTheme.spacingSm,
        vertical: KRPGTheme.spacingXs,
      ),
      padding: KRPGSpacing.paddingMD,
      backgroundColor: KRPGTheme.backgroundPrimary,
      isSelected: isSelected,
      child: child,
    );
  }
} 
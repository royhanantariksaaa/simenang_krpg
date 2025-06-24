import 'package:flutter/material.dart';
import '../../design_system/krpg_design_system.dart';

class KRPGAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final Widget? flexibleSpace;
  final Widget? bottom;
  final double? titleSpacing;
  final double bottomHeight;

  const KRPGAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.onBackPressed,
    this.centerTitle = false,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.flexibleSpace,
    this.bottom,
    this.titleSpacing,
    this.bottomHeight = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: KRPGTextStyles.heading5.copyWith(
          color: foregroundColor ?? Colors.white,
        ),
      ),
      leading: _buildLeading(context),
      actions: actions,
      backgroundColor: backgroundColor ?? KRPGTheme.primaryColor,
      foregroundColor: foregroundColor ?? Colors.white,
      elevation: elevation,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing,
      flexibleSpace: flexibleSpace,
      bottom: bottom != null
          ? PreferredSize(
              preferredSize: Size.fromHeight(bottomHeight),
              child: bottom!,
            )
          : null,
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) {
      return leading;
    }
    
    if (showBackButton && Navigator.of(context).canPop()) {
      return IconButton(
        icon: Icon(
          KRPGIcons.back,
          color: foregroundColor ?? Colors.white,
        ),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      );
    }
    
    return null;
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + bottomHeight);

  // Factory constructors for different app bar styles
  
  /// Creates a primary app bar with blue background
  factory KRPGAppBar.primary({
    required String title,
    List<Widget>? actions,
    Widget? leading,
    bool showBackButton = true,
    VoidCallback? onBackPressed,
    bool centerTitle = false,
    double elevation = 0,
    Widget? flexibleSpace,
    Widget? bottom,
    double? titleSpacing,
    double bottomHeight = 0,
  }) {
    return KRPGAppBar(
      title: title,
      actions: actions,
      leading: leading,
      showBackButton: showBackButton,
      onBackPressed: onBackPressed,
      centerTitle: centerTitle,
      backgroundColor: KRPGTheme.primaryColor,
      foregroundColor: Colors.white,
      elevation: elevation,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      titleSpacing: titleSpacing,
      bottomHeight: bottomHeight,
    );
  }

  /// Creates a secondary app bar with green background
  factory KRPGAppBar.secondary({
    required String title,
    List<Widget>? actions,
    Widget? leading,
    bool showBackButton = true,
    VoidCallback? onBackPressed,
    bool centerTitle = false,
    double elevation = 0,
    Widget? flexibleSpace,
    Widget? bottom,
    double? titleSpacing,
    double bottomHeight = 0,
  }) {
    return KRPGAppBar(
      title: title,
      actions: actions,
      leading: leading,
      showBackButton: showBackButton,
      onBackPressed: onBackPressed,
      centerTitle: centerTitle,
      backgroundColor: KRPGTheme.secondaryColor,
      foregroundColor: Colors.white,
      elevation: elevation,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      titleSpacing: titleSpacing,
      bottomHeight: bottomHeight,
    );
  }

  /// Creates a transparent app bar with dark text
  factory KRPGAppBar.transparent({
    required String title,
    List<Widget>? actions,
    Widget? leading,
    bool showBackButton = true,
    VoidCallback? onBackPressed,
    bool centerTitle = false,
    double elevation = 0,
    Widget? flexibleSpace,
    Widget? bottom,
    double? titleSpacing,
    double bottomHeight = 0,
  }) {
    return KRPGAppBar(
      title: title,
      actions: actions,
      leading: leading,
      showBackButton: showBackButton,
      onBackPressed: onBackPressed,
      centerTitle: centerTitle,
      backgroundColor: Colors.transparent,
      foregroundColor: KRPGTheme.textDark,
      elevation: elevation,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      titleSpacing: titleSpacing,
      bottomHeight: bottomHeight,
    );
  }

  /// Creates a light app bar with white background and dark text
  factory KRPGAppBar.light({
    required String title,
    List<Widget>? actions,
    Widget? leading,
    bool showBackButton = true,
    VoidCallback? onBackPressed,
    bool centerTitle = false,
    double elevation = 0,
    Widget? flexibleSpace,
    Widget? bottom,
    double? titleSpacing,
    double bottomHeight = 0,
  }) {
    return KRPGAppBar(
      title: title,
      actions: actions,
      leading: leading,
      showBackButton: showBackButton,
      onBackPressed: onBackPressed,
      centerTitle: centerTitle,
      backgroundColor: Colors.white,
      foregroundColor: KRPGTheme.textDark,
      elevation: elevation,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      titleSpacing: titleSpacing,
      bottomHeight: bottomHeight,
    );
  }
} 
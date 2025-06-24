import 'package:flutter/material.dart';
import '../../design_system/krpg_design_system.dart';
import 'krpg_app_bar.dart';

class KRPGScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final bool resizeToAvoidBottomInset;
  final Color? backgroundColor;
  final KRPGAppBar? appBar;
  final bool extendBodyBehindAppBar;
  final bool extendBody;
  final EdgeInsetsGeometry? padding;
  final bool safeAreaTop;
  final bool safeAreaBottom;
  final bool safeAreaLeft;
  final bool safeAreaRight;
  final bool centerTitle;
  final List<Widget>? appBarActions;
  final Widget? appBarLeading;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Widget? bottomSheet;
  final bool isLoading;
  final String? loadingText;

  const KRPGScaffold({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.resizeToAvoidBottomInset = true,
    this.backgroundColor,
    this.appBar,
    this.extendBodyBehindAppBar = false,
    this.extendBody = false,
    this.padding,
    this.safeAreaTop = true,
    this.safeAreaBottom = true,
    this.safeAreaLeft = true,
    this.safeAreaRight = true,
    this.centerTitle = false,
    this.appBarActions,
    this.appBarLeading,
    this.showBackButton = true,
    this.onBackPressed,
    this.bottomSheet,
    this.isLoading = false,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ??
          KRPGAppBar(
            title: title,
            centerTitle: centerTitle,
            actions: appBarActions,
            leading: appBarLeading,
            showBackButton: showBackButton,
            onBackPressed: onBackPressed,
          ),
      body: _buildBody(context),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor ?? KRPGTheme.backgroundSecondary,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      extendBody: extendBody,
      bottomSheet: bottomSheet,
    );
  }

  Widget _buildBody(BuildContext context) {
    Widget bodyContent = body;

    // Apply padding if provided
    if (padding != null) {
      bodyContent = Padding(
        padding: padding!,
        child: bodyContent,
      );
    }

    // Apply safe area
    bodyContent = SafeArea(
      top: safeAreaTop,
      bottom: safeAreaBottom,
      left: safeAreaLeft,
      right: safeAreaRight,
      child: bodyContent,
    );

    // Add loading overlay if needed
    if (isLoading) {
      return Stack(
        children: [
          bodyContent,
          _buildLoadingOverlay(),
        ],
      );
    }

    return bodyContent;
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(KRPGTheme.primaryColor),
            ),
            if (loadingText != null) ...[
              KRPGSpacing.verticalMD,
              Text(
                loadingText!,
                style: KRPGTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Factory constructors for different scaffold styles

  /// Creates a primary scaffold with blue app bar
  factory KRPGScaffold.primary({
    required String title,
    required Widget body,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    Widget? bottomNavigationBar,
    Widget? drawer,
    Widget? endDrawer,
    bool resizeToAvoidBottomInset = true,
    Color? backgroundColor,
    bool extendBodyBehindAppBar = false,
    bool extendBody = false,
    EdgeInsetsGeometry? padding,
    bool safeAreaTop = true,
    bool safeAreaBottom = true,
    bool safeAreaLeft = true,
    bool safeAreaRight = true,
    bool centerTitle = false,
    List<Widget>? appBarActions,
    Widget? appBarLeading,
    bool showBackButton = true,
    VoidCallback? onBackPressed,
    Widget? bottomSheet,
    bool isLoading = false,
    String? loadingText,
  }) {
    return KRPGScaffold(
      title: title,
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor,
      appBar: KRPGAppBar.primary(
        title: title,
        centerTitle: centerTitle,
        actions: appBarActions,
        leading: appBarLeading,
        showBackButton: showBackButton,
        onBackPressed: onBackPressed,
      ),
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      extendBody: extendBody,
      padding: padding,
      safeAreaTop: safeAreaTop,
      safeAreaBottom: safeAreaBottom,
      safeAreaLeft: safeAreaLeft,
      safeAreaRight: safeAreaRight,
      bottomSheet: bottomSheet,
      isLoading: isLoading,
      loadingText: loadingText,
    );
  }

  /// Creates a secondary scaffold with green app bar
  factory KRPGScaffold.secondary({
    required String title,
    required Widget body,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    Widget? bottomNavigationBar,
    Widget? drawer,
    Widget? endDrawer,
    bool resizeToAvoidBottomInset = true,
    Color? backgroundColor,
    bool extendBodyBehindAppBar = false,
    bool extendBody = false,
    EdgeInsetsGeometry? padding,
    bool safeAreaTop = true,
    bool safeAreaBottom = true,
    bool safeAreaLeft = true,
    bool safeAreaRight = true,
    bool centerTitle = false,
    List<Widget>? appBarActions,
    Widget? appBarLeading,
    bool showBackButton = true,
    VoidCallback? onBackPressed,
    Widget? bottomSheet,
    bool isLoading = false,
    String? loadingText,
  }) {
    return KRPGScaffold(
      title: title,
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor,
      appBar: KRPGAppBar.secondary(
        title: title,
        centerTitle: centerTitle,
        actions: appBarActions,
        leading: appBarLeading,
        showBackButton: showBackButton,
        onBackPressed: onBackPressed,
      ),
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      extendBody: extendBody,
      padding: padding,
      safeAreaTop: safeAreaTop,
      safeAreaBottom: safeAreaBottom,
      safeAreaLeft: safeAreaLeft,
      safeAreaRight: safeAreaRight,
      bottomSheet: bottomSheet,
      isLoading: isLoading,
      loadingText: loadingText,
    );
  }

  /// Creates a light scaffold with white app bar and dark text
  factory KRPGScaffold.light({
    required String title,
    required Widget body,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    Widget? bottomNavigationBar,
    Widget? drawer,
    Widget? endDrawer,
    bool resizeToAvoidBottomInset = true,
    Color? backgroundColor,
    bool extendBodyBehindAppBar = false,
    bool extendBody = false,
    EdgeInsetsGeometry? padding,
    bool safeAreaTop = true,
    bool safeAreaBottom = true,
    bool safeAreaLeft = true,
    bool safeAreaRight = true,
    bool centerTitle = false,
    List<Widget>? appBarActions,
    Widget? appBarLeading,
    bool showBackButton = true,
    VoidCallback? onBackPressed,
    Widget? bottomSheet,
    bool isLoading = false,
    String? loadingText,
  }) {
    return KRPGScaffold(
      title: title,
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor,
      appBar: KRPGAppBar.light(
        title: title,
        centerTitle: centerTitle,
        actions: appBarActions,
        leading: appBarLeading,
        showBackButton: showBackButton,
        onBackPressed: onBackPressed,
      ),
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      extendBody: extendBody,
      padding: padding,
      safeAreaTop: safeAreaTop,
      safeAreaBottom: safeAreaBottom,
      safeAreaLeft: safeAreaLeft,
      safeAreaRight: safeAreaRight,
      bottomSheet: bottomSheet,
      isLoading: isLoading,
      loadingText: loadingText,
    );
  }
} 
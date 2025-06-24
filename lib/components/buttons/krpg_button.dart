import 'package:flutter/material.dart';

enum KRPGButtonType { filled, outlined, text }
enum KRPGButtonSize { small, medium, large }

class KRPGButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final KRPGButtonType type;
  final KRPGButtonSize size;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final IconData? icon;
  final bool iconOnRight;
  final bool isLoading;
  final bool isFullWidth;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  const KRPGButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = KRPGButtonType.filled,
    this.size = KRPGButtonSize.medium,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.icon,
    this.iconOnRight = false,
    this.isLoading = false,
    this.isFullWidth = false,
    this.borderRadius,
    this.padding,
  });

  // Factory constructors for common button styles
  factory KRPGButton.primary({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    KRPGButtonSize size = KRPGButtonSize.medium,
    bool isLoading = false,
  }) {
    return KRPGButton(
      text: text,
      onPressed: onPressed,
      type: KRPGButtonType.filled,
      size: size,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      icon: icon,
      isLoading: isLoading,
    );
  }

  factory KRPGButton.secondary({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    KRPGButtonSize size = KRPGButtonSize.medium,
    bool isLoading = false,
  }) {
    return KRPGButton(
      text: text,
      onPressed: onPressed,
      type: KRPGButtonType.outlined,
      size: size,
      borderColor: Colors.blue,
      textColor: Colors.blue,
      icon: icon,
      isLoading: isLoading,
    );
  }

  factory KRPGButton.success({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    KRPGButtonSize size = KRPGButtonSize.medium,
    bool isLoading = false,
  }) {
    return KRPGButton(
      text: text,
      onPressed: onPressed,
      type: KRPGButtonType.filled,
      size: size,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      icon: icon,
      isLoading: isLoading,
    );
  }

  factory KRPGButton.danger({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    KRPGButtonSize size = KRPGButtonSize.medium,
    bool isLoading = false,
  }) {
    return KRPGButton(
      text: text,
      onPressed: onPressed,
      type: KRPGButtonType.filled,
      size: size,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      icon: icon,
      isLoading: isLoading,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onPressed != null && !isLoading;

    // Calculate dimensions based on size
    final buttonHeight = _getHeight();
    final buttonPadding = padding ?? _getPadding();
    final fontSize = _getFontSize();
    final iconSize = _getIconSize();

    // Calculate colors
    final effectiveBackgroundColor = _getBackgroundColor(theme);
    final effectiveTextColor = _getTextColor(theme);
    final effectiveBorderColor = _getBorderColor(theme);

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: buttonHeight,
      child: _buildButton(
        context,
        isEnabled,
        effectiveBackgroundColor,
        effectiveTextColor,
        effectiveBorderColor,
        buttonPadding,
        fontSize,
        iconSize,
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    bool isEnabled,
    Color backgroundColor,
    Color textColor,
    Color? borderColor,
    EdgeInsetsGeometry padding,
    double fontSize,
    double iconSize,
  ) {
    final content = _buildContent(textColor, fontSize, iconSize);

    switch (type) {
      case KRPGButtonType.filled:
        return ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            disabledBackgroundColor: backgroundColor.withOpacity(0.3),
            disabledForegroundColor: textColor.withOpacity(0.3),
            elevation: isEnabled ? 2 : 0,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(8),
            ),
          ),
          child: content,
        );

      case KRPGButtonType.outlined:
        return OutlinedButton(
          onPressed: isEnabled ? onPressed : null,
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor,
            disabledForegroundColor: textColor.withOpacity(0.3),
            side: BorderSide(
              color: isEnabled 
                  ? (borderColor ?? textColor)
                  : (borderColor ?? textColor).withOpacity(0.3),
              width: 1.5,
            ),
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(8),
            ),
          ),
          child: content,
        );

      case KRPGButtonType.text:
        return TextButton(
          onPressed: isEnabled ? onPressed : null,
          style: TextButton.styleFrom(
            foregroundColor: textColor,
            disabledForegroundColor: textColor.withOpacity(0.3),
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(8),
            ),
          ),
          child: content,
        );
    }
  }

  Widget _buildContent(Color textColor, double fontSize, double iconSize) {
    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Loading...',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    if (icon == null) {
      return Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: iconOnRight
          ? [
              Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Icon(icon, size: iconSize),
            ]
          : [
              Icon(icon, size: iconSize),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
    );
  }

  double _getHeight() {
    switch (size) {
      case KRPGButtonSize.small:
        return 36;
      case KRPGButtonSize.medium:
        return 44;
      case KRPGButtonSize.large:
        return 52;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case KRPGButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case KRPGButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case KRPGButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
    }
  }

  double _getFontSize() {
    switch (size) {
      case KRPGButtonSize.small:
        return 13;
      case KRPGButtonSize.medium:
        return 14;
      case KRPGButtonSize.large:
        return 16;
    }
  }

  double _getIconSize() {
    switch (size) {
      case KRPGButtonSize.small:
        return 16;
      case KRPGButtonSize.medium:
        return 18;
      case KRPGButtonSize.large:
        return 20;
    }
  }

  Color _getBackgroundColor(ThemeData theme) {
    if (backgroundColor != null) return backgroundColor!;
    
    switch (type) {
      case KRPGButtonType.filled:
        return theme.primaryColor;
      case KRPGButtonType.outlined:
      case KRPGButtonType.text:
        return Colors.transparent;
    }
  }

  Color _getTextColor(ThemeData theme) {
    if (textColor != null) return textColor!;
    
    switch (type) {
      case KRPGButtonType.filled:
        return Colors.white;
      case KRPGButtonType.outlined:
      case KRPGButtonType.text:
        return theme.primaryColor;
    }
  }

  Color? _getBorderColor(ThemeData theme) {
    if (borderColor != null) return borderColor!;
    
    switch (type) {
      case KRPGButtonType.outlined:
        return textColor ?? theme.primaryColor;
      case KRPGButtonType.filled:
      case KRPGButtonType.text:
        return null;
    }
  }
} 
import 'package:flutter/material.dart';
import '../../design_system/krpg_design_system.dart';

class KRPGBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Border? border;
  final IconData? icon;
  final double? iconSize;

  const KRPGBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.padding,
    this.borderRadius,
    this.border,
    this.icon,
    this.iconSize,
  });

  factory KRPGBadge.primary({
    required String text,
    IconData? icon,
  }) {
    return KRPGBadge(
      text: text,
      backgroundColor: KRPGTheme.primaryColor.withOpacity(0.1),
      textColor: KRPGTheme.primaryColor,
      icon: icon,
    );
  }

  factory KRPGBadge.secondary({
    required String text,
    IconData? icon,
  }) {
    return KRPGBadge(
      text: text,
      backgroundColor: KRPGTheme.secondaryColor.withOpacity(0.1),
      textColor: KRPGTheme.secondaryColor,
      icon: icon,
    );
  }

  // Factory constructors for common badge types
  factory KRPGBadge.success({
    required String text,
    IconData? icon,
  }) {
    return KRPGBadge(
      text: text,
      backgroundColor: Colors.green.withOpacity(0.1),
      textColor: Colors.green[700],
      icon: icon ?? Icons.check_circle,
      borderRadius: BorderRadius.circular(12),
    );
  }

  factory KRPGBadge.warning({
    required String text,
    IconData? icon,
  }) {
    return KRPGBadge(
      text: text,
      backgroundColor: Colors.orange.withOpacity(0.1),
      textColor: Colors.orange[700],
      icon: icon ?? Icons.warning,
      borderRadius: BorderRadius.circular(12),
    );
  }

  factory KRPGBadge.danger({
    required String text,
    IconData? icon,
  }) {
    return KRPGBadge(
      text: text,
      backgroundColor: Colors.red.withOpacity(0.1),
      textColor: Colors.red[700],
      icon: icon ?? Icons.error,
      borderRadius: BorderRadius.circular(12),
    );
  }

  factory KRPGBadge.info({
    required String text,
    IconData? icon,
  }) {
    return KRPGBadge(
      text: text,
      backgroundColor: Colors.blue.withOpacity(0.1),
      textColor: Colors.blue[700],
      icon: icon ?? Icons.info,
      borderRadius: BorderRadius.circular(12),
    );
  }

  factory KRPGBadge.neutral({
    required String text,
    IconData? icon,
  }) {
    return KRPGBadge(
      text: text,
      backgroundColor: Colors.grey.withOpacity(0.1),
      textColor: Colors.grey[700],
      icon: icon,
      borderRadius: BorderRadius.circular(12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey.withOpacity(0.1),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        border: border,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: iconSize ?? (fontSize ?? 12) + 2,
              color: textColor ?? Colors.grey[700],
            ),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize ?? 12,
              color: textColor ?? Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
} 
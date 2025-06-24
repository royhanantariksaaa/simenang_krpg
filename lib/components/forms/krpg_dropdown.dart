import 'package:flutter/material.dart';
import '../../design_system/krpg_design_system.dart';

class KRPGDropdown<T> extends StatefulWidget {
  final String label;
  final String? hint;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final bool isRequired;
  final String? Function(T?)? validator;
  final IconData? prefixIcon;
  final bool enabled;
  final EdgeInsetsGeometry? contentPadding;
  final String? errorText;
  final String? helperText;

  const KRPGDropdown({
    super.key,
    required this.label,
    this.hint,
    required this.items,
    this.value,
    this.onChanged,
    this.isRequired = false,
    this.validator,
    this.prefixIcon,
    this.enabled = true,
    this.contentPadding,
    this.errorText,
    this.helperText,
  });

  @override
  State<KRPGDropdown<T>> createState() => _KRPGDropdownState<T>();
}

class _KRPGDropdownState<T> extends State<KRPGDropdown<T>> {
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (widget.label.isNotEmpty) ...[
          _buildLabel(),
          KRPGSpacing.verticalXS,
        ],
        
        // Dropdown
        Focus(
          focusNode: _focusNode,
          child: DropdownButtonFormField<T>(
            value: widget.value,
            items: widget.items,
            onChanged: widget.enabled ? widget.onChanged : null,
            validator: widget.validator,
            icon: Icon(
              Icons.arrow_drop_down,
              color: _isFocused 
                  ? KRPGTheme.primaryColor 
                  : KRPGTheme.neutralMedium,
            ),
            style: KRPGTextStyles.bodyMedium,
            isExpanded: true,
            decoration: InputDecoration(
              hintText: widget.hint,
              errorText: widget.errorText,
              helperText: widget.helperText,
              helperStyle: KRPGTextStyles.caption,
              errorStyle: KRPGTextStyles.caption.copyWith(
                color: KRPGTheme.dangerColor,
              ),
              contentPadding: widget.contentPadding ?? 
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      color: _isFocused 
                          ? KRPGTheme.primaryColor 
                          : KRPGTheme.neutralMedium,
                      size: 20,
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(KRPGTheme.radiusSm),
                borderSide: BorderSide(
                  color: KRPGTheme.borderColor,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(KRPGTheme.radiusSm),
                borderSide: BorderSide(
                  color: KRPGTheme.primaryColor,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(KRPGTheme.radiusSm),
                borderSide: BorderSide(
                  color: KRPGTheme.borderColor,
                  width: 1.0,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(KRPGTheme.radiusSm),
                borderSide: BorderSide(
                  color: KRPGTheme.dangerColor,
                  width: 1.0,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(KRPGTheme.radiusSm),
                borderSide: BorderSide(
                  color: KRPGTheme.dangerColor,
                  width: 1.5,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(KRPGTheme.radiusSm),
                borderSide: BorderSide(
                  color: KRPGTheme.borderColor.withOpacity(0.5),
                  width: 1.0,
                ),
              ),
              filled: true,
              fillColor: widget.enabled
                  ? Colors.transparent
                  : KRPGTheme.neutralLight.withOpacity(0.3),
              hintStyle: KRPGTextStyles.bodyMedium.copyWith(
                color: KRPGTheme.neutralMedium,
              ),
            ),
            dropdownColor: Colors.white,
            menuMaxHeight: 300,
            borderRadius: BorderRadius.circular(KRPGTheme.radiusSm),
            alignment: AlignmentDirectional.centerStart,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel() {
    return Row(
      children: [
        Text(
          widget.label,
          style: KRPGTextStyles.labelLarge.copyWith(
            color: widget.enabled ? KRPGTheme.textDark : KRPGTheme.neutralMedium,
          ),
        ),
        if (widget.isRequired) ...[
          const SizedBox(width: 2),
          Text(
            '*',
            style: KRPGTextStyles.labelLarge.copyWith(
              color: KRPGTheme.dangerColor,
            ),
          ),
        ],
      ],
    );
  }
}

// Helper class to create dropdown items with consistent styling
class KRPGDropdownItem<T> extends DropdownMenuItem<T> {
  KRPGDropdownItem({
    super.key,
    required T value,
    required String text,
    Widget? icon,
  }) : super(
          value: value,
          child: Row(
            children: [
              if (icon != null) ...[
                icon,
                KRPGSpacing.horizontalSM,
              ],
              Expanded(
                child: Text(
                  text,
                  style: KRPGTextStyles.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
} 
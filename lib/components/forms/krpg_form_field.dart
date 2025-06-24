import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../design_system/krpg_design_system.dart';

class KRPGFormField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final bool isPassword;
  final bool isRequired;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Widget? suffix;
  final VoidCallback? onTap;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextCapitalization textCapitalization;
  final bool autofocus;
  final bool enabled;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? style;
  final String? helperText;
  final String? errorText;

  const KRPGFormField({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    this.isPassword = false,
    this.isRequired = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffix,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.textCapitalization = TextCapitalization.none,
    this.autofocus = false,
    this.enabled = true,
    this.contentPadding,
    this.style,
    this.helperText,
    this.errorText,
  });

  @override
  State<KRPGFormField> createState() => _KRPGFormFieldState();
}

class _KRPGFormFieldState extends State<KRPGFormField> {
  bool _obscureText = true;
  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
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
        
        // Text field
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword && _obscureText,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          readOnly: widget.readOnly,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          focusNode: _focusNode,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          textCapitalization: widget.textCapitalization,
          autofocus: widget.autofocus,
          enabled: widget.enabled,
          style: widget.style ?? KRPGTextStyles.bodyMedium,
          onTap: widget.onTap,
          cursorColor: KRPGTheme.primaryColor,
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
            suffixIcon: _buildSuffixIcon(),
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
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          onEditingComplete: () => FocusScope.of(context).nextFocus(),
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

  Widget? _buildSuffixIcon() {
    if (widget.isPassword) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          color: KRPGTheme.neutralMedium,
          size: 20,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }
    
    if (widget.suffix != null) {
      return widget.suffix;
    }
    
    return null;
  }
} 
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;

  final TextInputType keyboardType;
  final TextInputAction textInputAction;

  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;

  final int maxLines;
  final int? maxLength;

  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        enabled: enabled,
        readOnly: readOnly,
        autofocus: autofocus,
        maxLines: obscureText ? 1 : maxLines,
        maxLength: maxLength,
        validator: validator,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        onTap: onTap,
        style: const TextStyle(fontSize: 16, color: AppTheme.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          counterText: "",
          filled: true,
          fillColor: Colors.white,
          prefixIcon: prefixIcon == null
              ? null
              : Icon(prefixIcon, color: AppTheme.primaryColor),
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: AppTheme.primaryColor,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppTheme.errorColor, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppTheme.errorColor, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
        ),
      ),
    );
  }
}

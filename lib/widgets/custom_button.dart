import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;
  final double borderRadius;
  final bool expanded;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 54,
    this.borderRadius = 14,
    this.expanded = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final button = SizedBox(
      height: height,
      width: expanded ? double.infinity : null,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor ?? AppTheme.primaryColor,
          foregroundColor: foregroundColor ?? Colors.white,
          disabledBackgroundColor: AppTheme.primaryColor.withOpacity(0.6),
          disabledForegroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: isLoading
              ? const SizedBox(
                  key: ValueKey("loading"),
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : Row(
                  key: const ValueKey("button"),
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 20),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      text,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );

    if (padding == null) return button;

    return Padding(padding: padding!, child: button);
  }
}

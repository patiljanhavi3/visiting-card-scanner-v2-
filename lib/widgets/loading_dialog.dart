import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class LoadingDialog extends StatelessWidget {
  final String message;

  const LoadingDialog({super.key, this.message = "Please wait..."});

  /// Show loading dialog
  static Future<void> show(
    BuildContext context, {
    String message = "Please wait...",
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => LoadingDialog(message: message),
    );
  }

  /// Hide loading dialog
  static void hide(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Center(
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 52,
                height: 52,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  color: AppTheme.primaryColor,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "This may take a few seconds.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

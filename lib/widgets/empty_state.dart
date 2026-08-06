import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? buttonText;
  final VoidCallback? onPressed;

  const EmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.badge_outlined,
    this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 60, color: theme.colorScheme.primary),
            ),

            const SizedBox(height: 28),

            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),

            if (buttonText != null && onPressed != null) ...[
              const SizedBox(height: 30),
              SizedBox(
                width: 220,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: onPressed,
                  icon: const Icon(Icons.camera_alt),
                  label: Text(buttonText!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

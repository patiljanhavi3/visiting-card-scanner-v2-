import 'package:flutter/material.dart';

class CardActions extends StatelessWidget {
  final VoidCallback? onCall;
  final VoidCallback? onEmail;
  final VoidCallback? onWebsite;
  final VoidCallback? onShare;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CardActions({
    super.key,
    this.onCall,
    this.onEmail,
    this.onWebsite,
    this.onShare,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        _action(Icons.call, "Call", Colors.green, onCall),
        _action(Icons.email, "Email", Colors.blue, onEmail),
        _action(Icons.language, "Website", Colors.orange, onWebsite),
        _action(Icons.share, "Share", Colors.purple, onShare),
        _action(Icons.edit, "Edit", Colors.teal, onEdit),
        _action(Icons.delete_outline, "Delete", Colors.red, onDelete),
      ],
    );
  }

  Widget _action(
    IconData icon,
    String label,
    Color color,
    VoidCallback? onTap,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: 95,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(.25)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CardInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  const CardInfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (value.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: SelectableText(value, style: const TextStyle(fontSize: 15)),
        trailing: onTap == null
            ? null
            : const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

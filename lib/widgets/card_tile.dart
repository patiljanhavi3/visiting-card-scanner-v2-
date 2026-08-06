import 'package:flutter/material.dart';

import '../models/visiting_card.dart';

class CardTile extends StatelessWidget {
  final VisitingCard card;

  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onShare;

  const CardTile({
    super.key,
    required this.card,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 28,
                child: Text(
                  _initials(card.name),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.name.isEmpty ? "Unknown" : card.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    if (card.designation.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          card.designation,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ),

                    if (card.company.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          card.company,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),

                    const SizedBox(height: 8),

                    if (card.mobile.isNotEmpty)
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 16),
                          const SizedBox(width: 6),
                          Expanded(child: Text(card.mobile)),
                        ],
                      ),

                    if (card.emails.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.email, size: 16),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                card.emails.first,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),

                    if (card.website.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.language, size: 16),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                card.website,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case "share":
                      onShare?.call();
                      break;

                    case "edit":
                      onEdit?.call();
                      break;

                    case "delete":
                      onDelete?.call();
                      break;
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: "share",
                    child: Row(
                      children: [
                        Icon(Icons.share),
                        SizedBox(width: 10),
                        Text("Share"),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: "edit",
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 10),
                        Text("Edit"),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: "delete",
                    child: Row(
                      children: [
                        Icon(Icons.delete),
                        SizedBox(width: 10),
                        Text("Delete"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _initials(String name) {
    if (name.trim().isEmpty) return "?";

    final parts = name.trim().split(" ");

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

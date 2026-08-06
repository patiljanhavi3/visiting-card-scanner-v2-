import 'package:flutter/material.dart';

import '../models/visiting_card.dart';
import '../repository/card_repository.dart';
import 'card_detail_screen.dart';
import 'edit_card_screen.dart';

class MyCardsScreen extends StatefulWidget {
  const MyCardsScreen({super.key});

  @override
  State<MyCardsScreen> createState() => _MyCardsScreenState();
}

class _MyCardsScreenState extends State<MyCardsScreen> {
  final CardRepository repository = CardRepository();

  final TextEditingController searchController = TextEditingController();

  String search = "";

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<VisitingCard> _filterCards(List<VisitingCard> cards) {
    if (search.trim().isEmpty) {
      return cards;
    }

    final query = search.toLowerCase();

    return cards.where((card) {
      return card.name.toLowerCase().contains(query) ||
          card.company.toLowerCase().contains(query) ||
          card.designation.toLowerCase().contains(query) ||
          card.mobile.toLowerCase().contains(query) ||
          card.emails.any((e) => e.toLowerCase().contains(query)) ||
          card.phones.any((p) => p.toLowerCase().contains(query));
    }).toList();
  }

  Future<void> _deleteCard(VisitingCard card) async {
    final ok =
        await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Delete Card"),
            content: const Text("Delete this business card permanently?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Delete"),
              ),
            ],
          ),
        ) ??
        false;

    if (!ok) return;

    await repository.deleteCard(card.id);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Business card deleted")));
  }

  Future<void> _editCard(VisitingCard card) async {
    final updated = await Navigator.push<VisitingCard>(
      context,
      MaterialPageRoute(builder: (_) => EditCardScreen(card: card)),
    );

    if (updated != null) {
      await repository.updateCard(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Business Cards")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: "Search cards...",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  search = value;
                });
              },
            ),
          ),

          Expanded(
            child: StreamBuilder<List<VisitingCard>>(
              stream: repository.getCards(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }

                final cards = _filterCards(snapshot.data ?? []);

                if (cards.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.badge_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "No Business Cards Found",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text("Scan a card to get started."),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final card = cards[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            card.name.isEmpty
                                ? "?"
                                : card.name[0].toUpperCase(),
                          ),
                        ),

                        title: Text(card.name.isEmpty ? "Unknown" : card.name),

                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (card.company.isNotEmpty) Text(card.company),

                            if (card.designation.isNotEmpty)
                              Text(card.designation),

                            if (card.mobile.isNotEmpty) Text(card.mobile),

                            if (card.emails.isNotEmpty) Text(card.emails.first),
                          ],
                        ),

                        isThreeLine: true,

                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CardDetailScreen(card: card),
                            ),
                          );

                          if (mounted) {
                            setState(() {});
                          }
                        },

                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            switch (value) {
                              case "edit":
                                await _editCard(card);
                                break;

                              case "delete":
                                await _deleteCard(card);
                                break;
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: "edit", child: Text("Edit")),
                            PopupMenuItem(
                              value: "delete",
                              child: Text("Delete"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

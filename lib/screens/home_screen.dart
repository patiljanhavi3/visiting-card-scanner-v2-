import 'package:flutter/material.dart';

import '../models/visiting_card.dart';
import '../repository/card_repository.dart';
import '../services/export_service.dart';
import '../services/share_service.dart';
import '../widgets/card_tile.dart';
import '../widgets/empty_state.dart';
import '../widgets/search_bar.dart';
import 'card_detail_screen.dart';
import 'scan_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repo = CardRepository();
  final _share = ShareService();
  final _export = const ExportService();
  final _controller = TextEditingController();
  String _query = "";

  List<VisitingCard> _filter(List<VisitingCard> cards) {
    if (_query.trim().isEmpty) return cards;
    final q = _query.toLowerCase();
    return cards
        .where(
          (c) =>
              c.name.toLowerCase().contains(q) ||
              c.company.toLowerCase().contains(q) ||
              c.designation.toLowerCase().contains(q) ||
              c.mobile.toLowerCase().contains(q) ||
              c.emails.any((e) => e.toLowerCase().contains(q)),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Business Card Scanner"),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              final cards = await _repo.getCardsOnce();
              await _export.shareCsv(cards);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_alt),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ScanScreen()),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: AppSearchBar(
              controller: _controller,
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<VisitingCard>>(
              stream: _repo.getCards(),
              builder: (context, s) {
                if (!s.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final cards = _filter(s.data!);
                if (cards.isEmpty) {
                  return const EmptyState(
                    icon: Icons.badge_outlined,
                    title: "No Cards",
                    subtitle: "Scan a business card",
                  );
                }
                return ListView.builder(
                  itemCount: cards.length,
                  itemBuilder: (context, i) {
                    final card = cards[i];
                    return CardTile(
                      card: card,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CardDetailScreen(card: card),
                        ),
                      ),
                      onShare: () => _share.shareText(card),
                      onDelete: () async => await _repo.deleteCard(card.id),
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

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/visiting_card.dart';

class CardService {
  CardService._();
  static final instance = CardService._();

  final _cards = FirebaseFirestore.instance.collection('cards');

  Future<void> saveCard(VisitingCard card) async {
    await _cards.doc(card.id).set(card.toJson());
  }

  Future<void> updateCard(VisitingCard card) async {
    await _cards.doc(card.id).update(card.toJson());
  }

  Future<void> deleteCard(String id) async {
    await _cards.doc(id).delete();
  }

  Stream<List<VisitingCard>> watchCards() {
    return _cards
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (s) => s.docs.map((d) => VisitingCard.fromJson(d.data())).toList(),
        );
  }

  Future<List<VisitingCard>> getCards() async {
    final snap = await _cards.orderBy('createdAt', descending: true).get();
    return snap.docs.map((d) => VisitingCard.fromJson(d.data())).toList();
  }
}

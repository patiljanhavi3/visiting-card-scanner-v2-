import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/visiting_card.dart';

class CardRepository {
  static const String collection = 'business_cards';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _cards =>
      _firestore.collection(collection);

  Future<VisitingCard> saveCard(VisitingCard card) async {
    final doc = card.id.isEmpty ? _cards.doc() : _cards.doc(card.id);
    final newCard = card.id.isEmpty ? card.copyWith(id: doc.id) : card;
    await doc.set(newCard.toJson());
    return newCard;
  }

  Future<VisitingCard?> getCard(String id) async {
    final snap = await _cards.doc(id).get();
    if (!snap.exists || snap.data() == null) return null;
    return VisitingCard.fromJson(snap.data()!);
  }

  Stream<List<VisitingCard>> getCards() {
    return _cards
        .orderBy('created_at', descending: true)
        .snapshots()
        .map(
          (s) => s.docs.map((e) => VisitingCard.fromJson(e.data())).toList(),
        );
  }

  Future<List<VisitingCard>> getCardsOnce() async {
    final s = await _cards.orderBy('created_at', descending: true).get();
    return s.docs.map((e) => VisitingCard.fromJson(e.data())).toList();
  }

  Future<void> updateCard(VisitingCard card) =>
      _cards.doc(card.id).set(card.toJson());

  Future<void> deleteCard(String id) => _cards.doc(id).delete();

  Future<List<VisitingCard>> searchCards(String query) async {
    final cards = await getCardsOnce();
    final q = query.toLowerCase();
    return cards
        .where(
          (c) =>
              c.name.toLowerCase().contains(q) ||
              c.company.toLowerCase().contains(q) ||
              c.designation.toLowerCase().contains(q) ||
              c.website.toLowerCase().contains(q) ||
              c.address.toLowerCase().contains(q) ||
              c.city.toLowerCase().contains(q) ||
              c.state.toLowerCase().contains(q) ||
              c.country.toLowerCase().contains(q) ||
              c.notes.toLowerCase().contains(q) ||
              c.emails.any((e) => e.toLowerCase().contains(q)) ||
              c.phones.any((p) => p.toLowerCase().contains(q)),
        )
        .toList();
  }

  Future<int> totalCards() async => (await _cards.get()).docs.length;

  Future<List<VisitingCard>> getAllCards() => getCardsOnce();

  Future<void> deleteAllCards() async {
    final s = await _cards.get();
    final b = _firestore.batch();
    for (final d in s.docs) {
      b.delete(d.reference);
    }
    await b.commit();
  }

  Future<bool> exists(String id) async => (await _cards.doc(id).get()).exists;
}

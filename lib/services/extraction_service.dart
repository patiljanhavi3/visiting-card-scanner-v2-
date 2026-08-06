import 'dart:convert';
import 'dart:io';

import '../models/visiting_card.dart';
import 'groq_service.dart';

class ExtractionService {
  final GroqService _groq = GroqService();

  /// Main extraction function
  Future<VisitingCard> extract(File image) async {
    Exception? lastException;

    // Retry up to 3 times
    for (int attempt = 0; attempt < 3; attempt++) {
      try {
        // Ask Groq Vision to extract the card
        String response = await _groq.extractCard(image);

        // Remove markdown wrappers if present
        response = _cleanup(response);

        Map<String, dynamic> json;

        // Try normal JSON parsing
        try {
          json = jsonDecode(response);
        } catch (_) {
          // Attempt repair if Groq returned extra text
          json = _repair(response);
        }

        // Convert JSON to model
        final card = VisitingCard.fromJson(json);

        // Normalize data before returning
        return VisitingCard(
          id: card.id,

          name: card.name,
          designation: card.designation,
          company: card.company,

          emails: card.emails,

          phones: card.phones.map(normalizePhone).toList(),

          mobile: normalizePhone(card.mobile),

          officePhone: normalizePhone(card.officePhone),

          fax: normalizePhone(card.fax),

          website: normalizeWebsite(card.website),

          linkedin: card.linkedin,

          whatsapp: normalizePhone(card.whatsapp),

          address: card.address,
          city: card.city,
          state: card.state,
          country: card.country,
          postalCode: card.postalCode,

          notes: card.notes,

          createdAt: card.createdAt,
        );
      } catch (e) {
        lastException = Exception(e.toString());

        // Small delay before retry
        await Future.delayed(Duration(seconds: attempt + 1));
      }
    }

    throw lastException ?? Exception("Extraction failed.");
  }

  /// Removes markdown formatting returned by LLM
  String _cleanup(String text) {
    text = text.trim();

    if (text.startsWith("```json")) {
      text = text.replaceFirst("```json", "");
    }

    if (text.startsWith("```")) {
      text = text.replaceFirst("```", "");
    }

    if (text.endsWith("```")) {
      text = text.substring(0, text.length - 3);
    }

    return text.trim();
  }

  /// Repairs JSON if Groq adds explanations
  Map<String, dynamic> _repair(String text) {
    final start = text.indexOf("{");
    final end = text.lastIndexOf("}");

    if (start == -1 || end == -1) {
      throw Exception("Groq returned invalid JSON.");
    }

    final cleaned = text.substring(start, end + 1);

    return jsonDecode(cleaned);
  }

  /// Remove spaces, brackets and dashes from phone numbers
  String normalizePhone(String value) {
    return value
        .replaceAll(" ", "")
        .replaceAll("-", "")
        .replaceAll("(", "")
        .replaceAll(")", "");
  }

  /// Remove protocol from website
  String normalizeWebsite(String value) {
    value = value.replaceAll("https://", "");

    value = value.replaceAll("http://", "");

    return value.trim();
  }
}

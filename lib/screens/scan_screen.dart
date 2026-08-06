import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/visiting_card.dart';
import '../repository/card_repository.dart';
import '../services/extraction_service.dart';
import 'edit_card_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final ImagePicker picker = ImagePicker();

  final ExtractionService extractionService = ExtractionService();

  final CardRepository repository = CardRepository();

  bool loading = false;

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 100,
    );

    if (image == null) {
      return;
    }

    await process(File(image.path));
  }

  Future<void> process(File image) async {
    setState(() {
      loading = true;
    });

    try {
      VisitingCard card = await extractionService.extract(image);

      if (!mounted) return;

      final VisitingCard? edited = await Navigator.push<VisitingCard>(
        context,
        MaterialPageRoute(builder: (_) => EditCardScreen(card: card)),
      );

      if (edited != null) {
        await repository.saveCard(edited);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Business card saved successfully.")),
          );

          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() {
      loading = false;
    });
  }

  Widget buildButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(text),
        onPressed: loading ? null : onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Business Card")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Icon(Icons.document_scanner, size: 120),

            const SizedBox(height: 20),

            const Text(
              "Capture or upload a business card.\n\nGroq Vision will extract all information automatically.",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            buildButton(
              text: "Capture using Camera",
              icon: Icons.camera_alt,
              onPressed: () => pickImage(ImageSource.camera),
            ),

            const SizedBox(height: 15),

            buildButton(
              text: "Choose from Gallery",
              icon: Icons.photo_library,
              onPressed: () => pickImage(ImageSource.gallery),
            ),

            const SizedBox(height: 40),

            if (loading)
              const Column(
                children: [
                  CircularProgressIndicator(),

                  SizedBox(height: 20),

                  Text("Analyzing card using Groq Vision..."),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

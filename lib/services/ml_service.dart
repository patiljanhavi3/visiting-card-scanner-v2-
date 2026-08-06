import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class MLService {
  final TextRecognizer _textRecognizer = TextRecognizer();

  /// Extracts text from an image at [imagePath]
  Future<String> extractTextFromImage(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      return recognizedText.text.trim();
    } catch (e) {
      throw Exception('Text extraction failed: ${e.toString()}');
    }
  }

  /// Parses business card text into fields
  Map<String, String?> parseCardText(String rawText) {
    final lines = rawText
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();

    String? name;
    String? phone;
    String? email;
    String? company;
    final List<String> addressLines = [];

    final phoneRegex = RegExp(r'(\+?\d{1,3}[-.\s]?)?\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}');
    final emailRegex = RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b');
    final companyKeywords = ['pvt', 'ltd', 'inc', 'corp', 'llc', 'company', 'technologies', 'solutions'];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      if (email == null && emailRegex.hasMatch(line)) {
        email = emailRegex.firstMatch(line)?.group(0);
        continue;
      }

      if (phone == null && phoneRegex.hasMatch(line)) {
        phone = phoneRegex.firstMatch(line)?.group(0);
        continue;
      }

      if (company == null &&
          companyKeywords.any((keyword) => line.toLowerCase().contains(keyword))) {
        company = line;
        continue;
      }

      if (i == 0 && name == null) {
        name = line;
        continue;
      }

      if (i == 1 && company == null && line.split(' ').length <= 5) {
        company = line;
        continue;
      }

      addressLines.add(line);
    }

    return {
      'name': name,
      'phone': phone,
      'email': email,
      'company': company,
      'address': addressLines.isNotEmpty ? addressLines.join('\n') : null,
      'designation': null, // Optional, ML parser can be improved later
    };
  }

  void dispose() {
    _textRecognizer.close();
  }
}

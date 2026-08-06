import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  Env._();

  static Future<void> load() async {
    await dotenv.load(fileName: ".env");
  }

  static String get groqApiKey {
    final key = dotenv.env["GROQ_API_KEY"];

    if (key == null || key.isEmpty) {
      throw Exception("Missing GROQ_API_KEY in .env");
    }

    return key;
  }
}

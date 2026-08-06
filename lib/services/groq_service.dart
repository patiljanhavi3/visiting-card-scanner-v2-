import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/env.dart';
import '../utils/prompts.dart';

class GroqService {
  static const _endpoint = 'https://api.groq.com/openai/v1/chat/completions';

  Future<String> extractCard(File image) async {
    final apiKey = Env.groqApiKey;
    if (!await image.exists()) {
      throw Exception('Image not found.');
    }

    final base64Image = base64Encode(await image.readAsBytes());

    final body = {
      "model": "meta-llama/llama-4-maverick-17b-128e-instruct",
      "temperature": 0,
      "messages": [
        {"role": "system", "content": businessCardPrompt},
        {
          "role": "user",
          "content": [
            {
              "type": "text",
              "text":
                  "Extract every business card field. Return ONLY valid JSON.",
            },
            {
              "type": "image_url",
              "image_url": {"url": "data:image/jpeg;base64,$base64Image"},
            },
          ],
        },
      ],
    };

    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $apiKey',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Groq Error ${response.statusCode}: ${response.body}');
    }

    final json = jsonDecode(response.body);
    return json['choices'][0]['message']['content'] as String;
  }
}

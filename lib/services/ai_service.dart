import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String apiKey = "YOUR_GEMINI_API_KEY";
  static const String model = "gemini-1.5-flash";

  static Future<String> askAI(String question) async {
    try {
      final response = await http.post(
        Uri.parse(
          "https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey",
        ),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text": """
You are AroCareX AI Doctor.

Answer health questions in detail.
Use simple language.
Explain symptoms, causes, precautions, treatment, diet, and prevention.

Question:
$question
"""
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["candidates"] != null &&
            data["candidates"].isNotEmpty) {
          return data["candidates"][0]["content"]["parts"][0]["text"];
        }
      }

      return _offlineAnswer(question);
    } catch (e) {
      return _offlineAnswer(question);
    }
  }

  static String _offlineAnswer(String question) {
    question = question.toLowerCase();

    if (question.contains("fever")) {
      return """
🤒 Fever

Possible Causes:
• Viral infection
• Flu
• COVID-19
• Bacterial infection

Home Care:
• Drink plenty of water
• Rest well
• Monitor temperature

See a doctor if:
• Fever lasts more than 3 days
• Difficulty breathing develops
""";
    }

    if (question.contains("headache")) {
      return """
🤕 Headache

Possible Causes:
• Stress
• Dehydration
• Lack of sleep
• Migraine

Tips:
• Drink water
• Rest in a quiet room
• Get enough sleep

Seek medical help for:
• Sudden severe headache
• Vision problems
""";
    }

    if (question.contains("cough")) {
      return """
😷 Cough

Possible Causes:
• Common cold
• Flu
• Allergies
• Respiratory infection

Home Care:
• Warm fluids
• Honey (for adults)
• Rest

See a doctor if:
• Blood in cough
• Breathing difficulty
""";
    }

    if (question.contains("diabetes")) {
      return """
🩺 Diabetes

Symptoms:
• Frequent urination
• Increased thirst
• Fatigue
• Blurred vision

Management:
• Healthy diet
• Regular exercise
• Blood sugar monitoring

Consult a doctor for proper diagnosis and treatment.
""";
    }

    return """
AroCareX AI Offline Assistant

I couldn't reach the online AI service.

Try asking about:
• Fever
• Headache
• Cough
• Cold
• Diabetes
• Blood Pressure
• Diet
• Exercise

For a complete AI answer, check your internet connection and Gemini configuration.
""";
  }
}
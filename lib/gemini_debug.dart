import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  final apiKey = "AIzaSyD0d0iLwu9R3hA_5F83ydTiM8W7dov464E";
  final url =
      "https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey";

  print("Fetching available models...");
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      print("Models found:");
      for (var m in json['models']) {
        // Only show generateContent supported models
        if (m['supportedGenerationMethods'].contains('generateContent')) {
          print("- ${m['name']}");
        }
      }
    } else {
      print("Error: ${response.statusCode}");
      print(response.body);
    }
  } catch (e) {
    print("Exception: $e");
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  // Cloud Function URLs
  static const String _baseUrl = 'https://us-central1-dream-boat-app.cloudfunctions.net';
  
  static const String _mockTip = "Bugün, içsel yolculuğunu derinleştirmek için bir anı defteri tutmayı deneyebilirsin. Rüyalarında gördüğün çocukluk hâlinle bağ kurarak, o saf sevgiyi yeniden keşfetmek için birkaç dakikanı ayır ve hislerini kaleme al.";
  
  static const String _mockInterpretation = "Rüya yorum servisine şu anda ulaşılamıyor. Lütfen internet bağlantınızı kontrol edip tekrar deneyin.";

  // New: Call Secure Cloud Function - Returns title + interpretation
  Future<Map<String, String?>> interpretDream(String dreamText, String mood, String language) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/interpretDream'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "dreamText": dreamText,
          "mood": mood,
          "language": language
        }),
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        try {
          // Try to parse as JSON (New Backend)
          final data = jsonDecode(decodedBody);
          // Check if it's the old JSON format {result: '...'} or new {title: '...', interpretation: '...'}
          if (data is Map<String, dynamic>) {
            if (data.containsKey('result')) {
               // Old structure
               return {
                 'title': null,
                 'interpretation': data['result'] as String?,
               };
            } else {
              // New structure
              return {
                'title': data['title'] as String?,
                'interpretation': data['interpretation'] as String?,
              };
            }
          }
           // Fallback
           return {'title': null, 'interpretation': decodedBody};
        } catch (e) {
          // Not JSON? Maybe raw text (Legacy Backend fallback)
          return {
            'title': null,
            'interpretation': decodedBody,
          };
        }
      } else {
        print('Cloud Function Error: ${response.statusCode} ${response.body}');
        return {
          'title': null,
          'interpretation': "Analiz alınırken bir hata oluştu: ${response.statusCode}",
        };
      }
    } catch (e) {
       print('Connection Exception: $e');
       return {
         'title': null,
         'interpretation': "Bağlantı hatası: $e",
       };
    }
  }

  Future<String> generateDailyTip(List<String> dreams, String language) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/generateDailyTip'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "language": language
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['result'] ?? _mockTip;
      } else {
        throw Exception('Failed to generate tip: ${response.body}');
      }
    } catch (e) {
      print('Tip Gen Error: $e');
      // Fallback to mock tip on error so the UI still shows something nicely
      return _mockTip;
    }
  }

  Future<String> analyzeDreams(List<String> dreams, String language) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/analyzeDreams'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "dreams": dreams,
          "language": language
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['result'] ?? "Analiz tamamlanamadı.";
      } else {
        print('Analysis Error: ${response.statusCode} ${response.body}');
        return "Analysis Error: ${response.statusCode}";
      }
    } catch (e) {
       print('Connection Exception: $e');
       return "Connection Error: $e";
    }
  }

  /// Analyze dreams with moon phase correlation
  Future<String> analyzeMoonSync(List<Map<String, dynamic>> dreamData, String language) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/analyzeMoonSync'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "dreamData": dreamData,
          "language": language
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['result'] ?? "Kozmik analiz tamamlanamadı.";
      } else {
        print('Moon Sync Error: ${response.statusCode} ${response.body}');
        return "Moon Sync Error: ${response.statusCode}";
      }
    } catch (e) {
       print('Connection Exception: $e');
       return "Connection Error: $e";
    }
  }

}

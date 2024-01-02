import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_admin_dashboard/models/QuizResult.dart';
class ApiService {
  static final String _baseUrl = "http://localhost:9001";

  static Future<List<QuizResult>> fetchQuizResults({int page = 0, int limit = 5, String query = ''}) async {
    var url = Uri.parse('$_baseUrl/QuizR/quizResults?page=$page&limit=$limit&query=$query');
    try {
      final response = await http.get(url, headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        List<dynamic> list = jsonDecode(response.body);
        return list.map((quizJson) => QuizResult.fromJson(quizJson)).toList();
      } else {
        throw Exception('Failed to load quiz results. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<QuizResult>> fetchAllQuizResults() async {
    final response = await http.get(Uri.parse('$_baseUrl/quiz-results'));

    if (response.statusCode == 200) {
      List<dynamic> quizResultsJson = json.decode(response.body);
      List<QuizResult> quizResults =
          quizResultsJson.map((json) => QuizResult.fromJson(json)).toList();
      return quizResults;
    } else {
      throw Exception('Failed to load quiz results');
    }
  }

    static Future<List<QuizResult>> searchQuizResults({int page = 0, int limit = 10, String query = ''}) async {
    var url = Uri.parse('$_baseUrl/QuizR/quizResults?page=$page&limit=$limit&query=$query');
    try {
      final response = await http.get(url, headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        List<dynamic> list = jsonDecode(response.body);
        return list.map((quizJson) => QuizResult.fromJson(quizJson)).toList();
      } else {
        throw Exception('Failed to search quiz results. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> deleteQuizResult(String quizId) async {
    try {
      final response =
          await http.delete(Uri.parse('$_baseUrl/QuizR/quizResults/$quizId'));

      if (response.statusCode == 200) {
        return true; // Deletion successful
      } else {
        print(
            "Error deleting quiz result. Status code: ${response.statusCode}");
        return false; // Deletion failed
      }
    } catch (error) {
      print("Error deleting quiz result: $error");
      return false; // Deletion failed
    }
  }

  static Future<bool> updateQuizResult(QuizResult quiz) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/QuizR/quizResults/${quiz.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'question': quiz.question,
          'correct_answer': quiz.correctAnswer,
          'incorrect_answers': quiz.incorrectAnswers,
        }),
      );

      if (response.statusCode == 200) {
        return true; // Update successful
      } else {
        print(
            "Error updating quiz result. Status code: ${response.statusCode}");
        return false; // Update failed
      }
    } catch (error) {
      print("Error updating quiz result: $error");
      return false; // Update failed
    }
  }

  static Future<String?> addQuizResult(QuizResult quiz) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/QuizR/quizResults'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'question': quiz.question,
          'correct_answer': quiz.correctAnswer,
          'incorrect_answers': quiz.incorrectAnswers,
        }),
      );

      if (response.statusCode == 200) {
        // Assuming the API returns the ID of the new quiz in the response body
        return jsonDecode(response.body)['id'];
      } else {
        print('Error adding quiz: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error adding quiz: $e');
      return null;
    }
  }
}

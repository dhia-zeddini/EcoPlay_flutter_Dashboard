import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_admin_dashboard/models/QuizResult.dart';

class ApiService {
  static final String _baseUrl = "http://localhost:9007";

  static Future<List<QuizResult>> fetchQuizResults() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/QuizR/quizResults'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => QuizResult.fromJson(json)).toList();
      }
      print("Error fetching quiz results. Status code: ${response.statusCode}");
      return [];
    } catch (error) {
      print("Error fetching quiz results: $error");
      return [];
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

  static Future<bool> addQuizResult(QuizResult quiz) async {
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
        return true; // Addition successful
      } else {
        print("Error adding quiz result. Status code: ${response.statusCode}");
        return false; // Addition failed
      }
    } catch (error) {
      print("Error adding quiz result: $error");
      return false; // Addition failed
    }
  }
}

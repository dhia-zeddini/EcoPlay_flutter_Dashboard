import 'package:flutter/material.dart';

class QuizResult {
  final String id;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  int correctCount;
  int incorrectCount;
  String selectedAnswer;

  QuizResult({
    required this.id,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
    this.correctCount = 0,
    this.incorrectCount = 0,
    this.selectedAnswer = "",
  });

  QuizResult copyWith({
    String? id,
    String? question,
    String? correctAnswer,
    List<String>? incorrectAnswers,
    int? correctCount,
    int? incorrectCount,
    String? selectedAnswer,
  }) {
    return QuizResult(
      id: id ?? this.id,
      question: question ?? this.question,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      incorrectAnswers: incorrectAnswers ?? this.incorrectAnswers,
      correctCount: correctCount ?? this.correctCount,
      incorrectCount: incorrectCount ?? this.incorrectCount,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
    );
  }

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      id: json['_id'] ?? '',
      question: json['question'] ?? '',
      correctAnswer: json['correct_answer'] ?? '',
      incorrectAnswers: List<String>.from(json['incorrect_answers'] ?? []),
      correctCount: json['correct_count'] ?? 0,
      incorrectCount: json['incorrect_count'] ?? 0,
      selectedAnswer: json['selected_answer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'question': question,
      'correct_answer': correctAnswer,
      'incorrect_answers': incorrectAnswers,
      'correct_count': correctCount,
      'incorrect_count': incorrectCount,
      'selected_answer': selectedAnswer,
    };
  }

bool isCorrect() {
  return selectedAnswer.trim().toLowerCase() == correctAnswer.trim().toLowerCase();
}


  // Add other methods and logic as needed for your application
}

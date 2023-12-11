class QuizResult {
  String id;
  final String question;
  final String correctAnswer;
  List<String> incorrectAnswers;
 // String category;

  QuizResult({
    required this.id,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
    //required this.category,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      id: json['_id'],
      question: json['question'],
      correctAnswer: json['correct_answer'],
      incorrectAnswers: List<String>.from(json['incorrect_answers']),
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'correct_answer': correctAnswer,
      'incorrect_answers': incorrectAnswers,
     
    };
  }
}

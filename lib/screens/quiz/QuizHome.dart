import 'package:flutter/material.dart';
import 'package:smart_admin_dashboard/models/QuizResult.dart';
import 'package:smart_admin_dashboard/responsive.dart';
import 'package:smart_admin_dashboard/screens/home/components/side_menu.dart';
import 'package:smart_admin_dashboard/services/ApiService.dart';

class QuizHome extends StatelessWidget {
  const QuizHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Quiz Results'),
      ),
      body: QuizTabScreen(),
    );
  }
}

class QuizTabScreen extends StatefulWidget {
  const QuizTabScreen({Key? key}) : super(key: key);

  @override
  _QuizTabScreenState createState() => _QuizTabScreenState();
}

class _QuizTabScreenState extends State<QuizTabScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: AdminQuizList(),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AdminQuizList(),
    );
  }
}

class AdminQuizList extends StatefulWidget {
  @override
  _AdminQuizListState createState() => _AdminQuizListState();
}

class _AdminQuizListState extends State<AdminQuizList> {
  List<QuizResult> quizList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchQuiz();
  }

  fetchQuiz() async {
    try {
      List<QuizResult>? quiz = await ApiService.fetchQuizResults();
      if (quiz != null) {
        setState(() {
          quizList = quiz;
        });
      }
    } catch (error) {
      // Handle the error, e.g., show an error message
      print("Error fetching quiz: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void navigateToAddQuiz() {
    TextEditingController questionController = TextEditingController();
    TextEditingController correctAnswerController = TextEditingController();
    TextEditingController incorrectAnswersController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Quiz'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Question:'),
              TextField(controller: questionController),
              SizedBox(height: 8.0),
              Text('Correct Answer:'),
              TextField(controller: correctAnswerController),
              SizedBox(height: 8.0),
              Text('Incorrect Answers (comma-separated):'),
              TextField(controller: incorrectAnswersController),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // Implement add logic here
                String newQuestion = questionController.text;
                String newCorrectAnswer = correctAnswerController.text;
                List<String> newIncorrectAnswers =
                    incorrectAnswersController.text.split(',').map((e) => e.trim()).toList();

                QuizResult newQuiz = QuizResult(
                  id: '', // Assign an empty string for a new quiz, assuming the backend generates the ID
                  question: newQuestion,
                  correctAnswer: newCorrectAnswer,
                  incorrectAnswers: newIncorrectAnswers,
                );

                // Call the addQuizResult method from your ApiService
                bool added = await ApiService.addQuizResult(newQuiz);

                if (added) {
                  // Addition successful, refresh the quizList
                  fetchQuiz();
                }

                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog without adding the quiz
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void editQuiz(QuizResult quiz) {
    TextEditingController questionController = TextEditingController(text: quiz.question);
    TextEditingController correctAnswerController = TextEditingController(text: quiz.correctAnswer);
    TextEditingController incorrectAnswersController =
        TextEditingController(text: quiz.incorrectAnswers.join(', '));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Quiz'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Question:'),
              TextField(controller: questionController),
              SizedBox(height: 8.0),
              Text('Correct Answer:'),
              TextField(controller: correctAnswerController),
              SizedBox(height: 8.0),
              Text('Incorrect Answers (comma-separated):'),
              TextField(controller: incorrectAnswersController),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // Implement edit logic here
                String editedQuestion = questionController.text;
                String editedCorrectAnswer = correctAnswerController.text;
                List<String> editedIncorrectAnswers =
                    incorrectAnswersController.text.split(',').map((e) => e.trim()).toList();

                QuizResult updatedQuiz = QuizResult(
                  id: quiz.id,
                  question: editedQuestion,
                  correctAnswer: editedCorrectAnswer,
                  incorrectAnswers: editedIncorrectAnswers,
                );

                // Call the updateQuizResult method from your ApiService
                bool updated = await ApiService.updateQuizResult(updatedQuiz);

                if (updated) {
                  // Update successful, refresh the quizList
                  fetchQuiz();
                }

                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog without saving changes
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void deleteQuiz(QuizResult quiz) async {
    bool deleted = await ApiService.deleteQuizResult(quiz.id);
    if (deleted) {
      setState(() {
        quizList.remove(quiz);
      });
    } else {
      // Handle deletion failure
      print("Failed to delete quiz: ${quiz.id}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz List'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: navigateToAddQuiz,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text('Add Quiz'),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DataTable(
                    columns: [
                      DataColumn(label: Text("Question")),
                      DataColumn(label: Text("Correct Answer")),
                      DataColumn(label: Text("Incorrect Answers")),
                      DataColumn(label: Text("Operations")),
                    ],
                    rows: quizList.map((quiz) => quizDataRow(quiz)).toList(),
                  ),
                ],
              ),
            ),
    );
  }

  DataRow quizDataRow(QuizResult quiz) {
    return DataRow(
      cells: [
        DataCell(Text(quiz.question)),
        DataCell(Text(quiz.correctAnswer)),
        DataCell(Text(quiz.incorrectAnswers.join(', '))),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.orange),
                onPressed: () => editQuiz(quiz),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => deleteQuiz(quiz),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
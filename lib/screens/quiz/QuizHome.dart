import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_admin_dashboard/models/QuizResult.dart';
import 'package:smart_admin_dashboard/responsive.dart';
import 'package:smart_admin_dashboard/screens/home/components/side_menu.dart';
import 'package:smart_admin_dashboard/services/ApiService.dart';
import 'package:fl_chart/fl_chart.dart';


class QuizHome extends StatelessWidget {
  const QuizHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gérer les résultats du quiz')),
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
            if (Responsive.isDesktop(context)) Expanded(child: SideMenu()),
            Expanded(flex: 5, child: AdminQuizList()),
          ],
        ),
      ),
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
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _currentPage = 0;
  int _totalQuestions = 0;
  int _totalCorrectAnswers = 0;
  int _totalIncorrectAnswers = 0;
  TextEditingController searchController = TextEditingController();
  final List<int> _availableRowsPerPage = [3, 5, 10];
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _rowsPerPage = _availableRowsPerPage.first;
    fetchQuiz();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

 void fetchQuiz({int page = 0, String query = ''}) async {
  setState(() => isLoading = true);
  try {
    List<QuizResult> results = await ApiService.fetchQuizResults(
        page: page, limit: _rowsPerPage, query: query);
    
    // Debugging: Print each quiz result to verify if the selectedAnswer is set correctly
    results.forEach((quiz) {
      print('Question: ${quiz.question}, Selected Answer: ${quiz.selectedAnswer}, Correct Answer: ${quiz.correctAnswer}');
    });

    int correctCount = results.where((quiz) => quiz.isCorrect()).length;
    print('Fetched correct answers: $correctCount'); // This should print the correct count

    setState(() {
      quizList = results;
      _totalQuestions = results.length;
      _totalCorrectAnswers = correctCount;
      _totalIncorrectAnswers = _totalQuestions - _totalCorrectAnswers;
      isLoading = false;
    });
  } catch (e) {
    print("Error fetching quiz data: $e");
    setState(() => isLoading = false);
  }
}


  void filterSearchResults(String query) {
    if (_searchDebounce?.isActive ?? false) _searchDebounce!.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      fetchQuiz(query: query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des quiz'),
        actions: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                onChanged: (query) => filterSearchResults(query),
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  fillColor: Color.fromARGB(255, 67, 104, 68),
                  filled: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => navigateToAddQuiz(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              child: Text('Ajouter un quiz'),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: buildStatisticCard(
                            'Total Questions',
                            '$_totalQuestions',
                            Colors.blue,
                            Icons.question_answer),
                      ),
                      Expanded(
                        child: buildStatisticCard(
                            'Correct Answers',
                            '$_totalCorrectAnswers',
                            Colors.green,
                            Icons.check_circle),
                      ),
                      Expanded(
                        child: buildStatisticCard(
                            'Incorrect Answers',
                            '$_totalIncorrectAnswers',
                            Colors.red,
                            Icons.cancel),
                      ),
                    ],
                  ),
              Container(
  height: 200, // Adjust the height as needed
  width: 200,  // Adjust the width as needed
  child: MyPieChart(
    correctAnswers: _totalCorrectAnswers,  // Assuming this is an int
    incorrectAnswers: _totalIncorrectAnswers,  // Assuming this is an int
    totalQuestions: _totalQuestions,  // Assuming this is an int
  ),
),

                  Theme(
                    data: ThemeData(
                      cardColor: Colors.white,
                      dividerColor: Colors.transparent,
                      dataTableTheme: DataTableThemeData(
                        headingRowColor:
                            MaterialStateProperty.all(Colors.orange),
                        dataRowColor: MaterialStateProperty.all(Colors.white),
                      ),
                      iconTheme: IconThemeData(
                        color: Color.fromARGB(255, 176, 215, 177),
                      ),
                      textTheme: TextTheme(
                        caption: TextStyle(
                          color: Color.fromARGB(255, 176, 215, 177),
                        ),
                      ),
                    ),
                    child: PaginatedDataTable(
                      header: Text('liste Quizz'),
                      columns: getColumns([
                        'Question',
                        'Réponse correcte',
                        'Réponses incorrectes',
                        'Opérations'
                      ]),
                      source: _QuizDataSource(
                        quizList: quizList,
                        currentPage: _currentPage,
                        rowsPerPage: _rowsPerPage,
                        onEdit: editQuiz,
                        onDelete: deleteQuiz,
                      ),
                      rowsPerPage: _rowsPerPage,
                      availableRowsPerPage: _availableRowsPerPage,
                      onRowsPerPageChanged: (r) {
                        if (r != null) {
                          setState(() {
                            _rowsPerPage = r;
                          });
                          fetchQuiz(page: _currentPage);
                        }
                      },
                      onPageChanged: (rowIndex) {
                        int newPage = rowIndex ~/ _rowsPerPage;
                        if (newPage != _currentPage) {
                          _currentPage = newPage;
                          fetchQuiz(page: newPage);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildStatisticCard(
      String title, String value, Color color, IconData icon) {
    return Card(
      color: color,
      child: Container(
        height: 150,
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 30.0),
            SizedBox(height: 10.0),
            Text(title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500)),
            SizedBox(height: 5),
            Text(value,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  List<DataColumn> getColumns(List<String> columns) {
    return columns
        .map((String column) => DataColumn(label: Text(column)))
        .toList();
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController questionController = TextEditingController();
  TextEditingController correctAnswerController = TextEditingController();
  TextEditingController incorrectAnswersController = TextEditingController();

  void navigateToAddQuiz(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajouter un quiz'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: questionController,
                  decoration: InputDecoration(labelText: 'Question'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Veuillez entrer une question';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: correctAnswerController,
                  decoration: InputDecoration(labelText: 'Réponse correcte'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Veuillez entrer une réponse correcte';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: incorrectAnswersController,
                  decoration: InputDecoration(
                    labelText:
                        'Réponses incorrectes (séparées par des virgules)',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Annuler'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Ajouter'),
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  // Validation réussie, ajoutez le quiz
                  QuizResult newQuiz = QuizResult(
                    id: 'tempID',
                    question: questionController.text,
                    correctAnswer: correctAnswerController.text,
                    incorrectAnswers: incorrectAnswersController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList(),
                  );
                  var successId = await ApiService.addQuizResult(newQuiz);
                  if (successId != null) {
                    var updatedQuiz = newQuiz.copyWith(id: successId);
                    setState(() {
                      quizList.insert(0, updatedQuiz);
                      recalculateStatistics();
                    });
                    Navigator.of(context).pop();
                  } else {
                    // Gérer l'erreur d'ajout de quiz
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void editQuiz(QuizResult quiz) {
    TextEditingController questionController =
        TextEditingController(text: quiz.question);
    TextEditingController correctAnswerController =
        TextEditingController(text: quiz.correctAnswer);
    TextEditingController incorrectAnswersController =
        TextEditingController(text: quiz.incorrectAnswers.join(', '));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier le quiz'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                  controller: questionController,
                  decoration: InputDecoration(labelText: 'Question')),
              TextField(
                  controller: correctAnswerController,
                  decoration: InputDecoration(labelText: 'Réponse correcte')),
              TextField(
                  controller: incorrectAnswersController,
                  decoration: InputDecoration(
                      labelText:
                          'Réponses incorrectes (séparées par des virgules)')),
            ],
          ),
          actions: [
            TextButton(
                child: Text('Annuler'),
                onPressed: () => Navigator.of(context).pop()),
            TextButton(
              child: Text('Enregistrer'),
              onPressed: () async {
                QuizResult updatedQuiz = quiz.copyWith(
                  question: questionController.text,
                  correctAnswer: correctAnswerController.text,
                  incorrectAnswers: incorrectAnswersController.text
                      .split(',')
                      .map((e) => e.trim())
                      .toList(),
                );
                bool updated = await ApiService.updateQuizResult(updatedQuiz);
                if (updated) {
                  fetchQuiz();
                  Navigator.of(context).pop();
                } else {}
              },
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
        quizList.removeWhere((item) => item.id == quiz.id);
        recalculateStatistics();
      });
    } else {}
  }

  void recalculateStatistics() {
    setState(() {
      _totalQuestions = quizList.length;
      _totalCorrectAnswers = quizList.where((quiz) => quiz.isCorrect()).length;
      _totalIncorrectAnswers = _totalQuestions - _totalCorrectAnswers;
    });
  }
}
class MyPieChart extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswers;
  final int incorrectAnswers;

  const MyPieChart({
    Key? key,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.incorrectAnswers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure that we don't divide by zero if totalQuestions is 0.
    final double correctPercent = totalQuestions > 0 ? (correctAnswers / totalQuestions) * 100 : 0;
    final double incorrectPercent = totalQuestions > 0 ? (incorrectAnswers / totalQuestions) * 100 : 0;
    // If there are no correct or incorrect answers, the remainder is unanswered.
    final double unansweredPercent = totalQuestions > 0 ? ((totalQuestions - correctAnswers - incorrectAnswers) / totalQuestions) * 100 : 0;

    return PieChart(
      PieChartData(
        sectionsSpace: 0, // Removes gaps between sections
        centerSpaceRadius: 30, // Adjust the size of the inner circle
        startDegreeOffset: -90, // Adjust starting position of chart
        sections: [
          PieChartSectionData(
            color: Colors.green,
            value: correctPercent,
            title: correctAnswers > 0 ? '${correctPercent.toStringAsFixed(1)}%' : '0%',
            radius: 50,
            titleStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          PieChartSectionData(
            color: Colors.red,
            value: incorrectPercent,
            title: incorrectAnswers > 0 ? '${incorrectPercent.toStringAsFixed(1)}%' : '0%',
            radius: 50,
            titleStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          PieChartSectionData(
            color: Colors.blue,
            value: unansweredPercent,
            title: unansweredPercent > 0 ? '${unansweredPercent.toStringAsFixed(1)}%' : '0%',
            radius: 50,
            titleStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}



typedef EditQuizCallback = void Function(QuizResult quiz);
typedef DeleteQuizCallback = void Function(QuizResult quiz);

class _QuizDataSource extends DataTableSource {
  final List<QuizResult> quizList;
  final int _currentPage;
  final int _rowsPerPage;
  final EditQuizCallback onEdit;
  final DeleteQuizCallback onDelete;

  _QuizDataSource({
    required this.quizList,
    required int currentPage,
    required int rowsPerPage,
    required this.onEdit,
    required this.onDelete,
  })  : _currentPage = currentPage,
        _rowsPerPage = rowsPerPage;

  @override
  DataRow? getRow(int index) {
    if (index >= quizList.length) return null;
    final quiz = quizList[index];

    return DataRow.byIndex(
      index: index,
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
                  onPressed: () => onEdit(quiz)),
              IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => onDelete(quiz)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  int get rowCount => quizList.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}

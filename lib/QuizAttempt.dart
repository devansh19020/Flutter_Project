import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'QuizResult.dart';

class QuizAttemptPage extends StatefulWidget {
  final String quizId;

  QuizAttemptPage({required this.quizId});

  @override
  _QuizAttemptPageState createState() => _QuizAttemptPageState();
}

class _QuizAttemptPageState extends State<QuizAttemptPage>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  int initialTimeLimit = 0;
  int timeLeft = 0;
  int selectedOptionIndex = -1;
  bool isAnswered = false;
  Timer? timer;
  int correctAnswers = 0;
  int wrongAnswers = 0;
  bool isLoading = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Used for smooth timer transition
    );
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      DocumentSnapshot quizDoc = await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(widget.quizId)
          .get();

      List<dynamic> questionList = quizDoc.get('questions');
      int quizTimeLimit = quizDoc.get('timeLimit');

      setState(() {
        questions = List<Map<String, dynamic>>.from(questionList);
        initialTimeLimit = quizTimeLimit;
        timeLeft = quizTimeLimit;
        isLoading = false;
        if (questions.isNotEmpty) {
          startTimer();
        }
      });
    } catch (error) {
      print('Error fetching questions: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  void startTimer() {
    timer?.cancel();
    _animationController.reset();
    _animationController.forward();

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        moveToNextQuestion();
      }
    });
  }

  void moveToNextQuestion() {
    timer?.cancel();
    setState(() {
      currentQuestionIndex++;
      selectedOptionIndex = -1;
      isAnswered = false;

      if (currentQuestionIndex < questions.length) {
        timeLeft = initialTimeLimit;
        startTimer();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (currentQuestionIndex >= questions.length) {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(
              totalQuestions: questions.length,
              correctAnswers: correctAnswers,
              wrongAnswers: wrongAnswers,
            ),
          ),
        );
      });
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    Map<String, dynamic> currentQuestion = questions[currentQuestionIndex];
    List<dynamic> options = currentQuestion['options'];

    return Scaffold(
      appBar: AppBar(
        title: Text("Attempt Quiz"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text(
                "${currentQuestionIndex + 1} / ${questions.length}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: timeLeft / initialTimeLimit,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        timeLeft > initialTimeLimit / 2
                            ? Colors.green
                            : Colors.red),
                    backgroundColor: Colors.grey[300],
                    strokeWidth: 8,
                  ),
                  Text(
                    "$timeLeft",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: timeLeft > initialTimeLimit / 2
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                currentQuestion['questionText'],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            ...options.asMap().entries.map((entry) {
              int index = entry.key;
              String option = entry.value;
              return Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: index == selectedOptionIndex
                        ? Colors.blue[100]
                        : Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(
                      color: index == selectedOptionIndex
                          ? Colors.blue
                          : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  onPressed: isAnswered
                      ? null
                      : () {
                    setState(() {
                      selectedOptionIndex = index;
                      isAnswered = true;
                      if (index == currentQuestion['correctOption']) {
                        correctAnswers++;
                      } else {
                        wrongAnswers++;
                      }
                    });
                  },
                  child: Text(
                    option,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              );
            }).toList(),
            Spacer(),
            ElevatedButton(
              onPressed: isAnswered ? moveToNextQuestion : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Next",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

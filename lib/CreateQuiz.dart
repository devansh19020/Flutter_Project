import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class QuizCreationPage extends StatefulWidget {
  @override
  _QuizCreationPageState createState() => _QuizCreationPageState();
}

class _QuizCreationPageState extends State<QuizCreationPage> {
  final _formKey = GlobalKey<FormState>();
  String quizName = '';
  String subject = '';
  int entryFee = 0;
  int timeLimit = 0;
  bool isProtected = false;
  String password = '';
  int numQuestions = 1;
  List<Map<String, dynamic>> questions = [];

  // Variables for live quiz functionality
  bool isLiveQuiz = false;
  DateTime? startTime;
  DateTime? endTime;
  int playerLimit = 0;

  @override
  void initState() {
    super.initState();
    questions = List.generate(numQuestions, (index) => _generateQuestionMap());
  }

  Future<void> _pickDateTime(BuildContext context, bool isStart) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        final DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          if (isStart) {
            startTime = finalDateTime;
          } else {
            endTime = finalDateTime;
          }
        });
      }
    }
  }

  Map<String, dynamic> _generateQuestionMap() {
    return {
      'questionText': '',
      'options': List<String>.filled(4, ''),
      'correctOption': 0,
    };
  }

  Future<void> _submitQuiz() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    final User? user = FirebaseAuth.instance.currentUser;
    final String? userId = user?.uid;
    final creatorName = user?.displayName ?? 'Unknown';
    Timestamp startTimestamp = Timestamp.fromDate(startTime!);
    Timestamp endTimestamp = Timestamp.fromDate(endTime!);

    final quizData = {
      'quizName': quizName,
      'subject': subject,
      'entryFee': entryFee,
      'timeLimit': timeLimit,
      'isProtected': isProtected,
      'password': isProtected ? password : '',
      'questions': questions,
      'creatorName': creatorName,
      // Live quiz data
      'playerLimit': isLiveQuiz ? playerLimit : null,
      'isLiveQuiz': isLiveQuiz,
      'startTime': isLiveQuiz ? startTimestamp : null,
      'endTime': isLiveQuiz ? endTimestamp : null,
      'currentParticipants' : isLiveQuiz ? 0 : null,
    };

    await FirebaseFirestore.instance.collection('quizzes').add(quizData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Quiz created successfully!')),
    );

    Navigator.pop(context);
  }

  Widget _buildQuestionField(int index) {
    return Card(
      color: Colors.lightBlue[50],
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Question ${index + 1}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Question Text",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSaved: (value) => questions[index]['questionText'] = value ?? '',
              validator: (value) =>
              value!.isEmpty ? 'Enter the question text' : null,
            ),
            SizedBox(height: 10),
            ...List.generate(4, (optionIndex) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Option ${optionIndex + 1}",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onSaved: (value) =>
                  questions[index]['options'][optionIndex] = value ?? '',
                  validator: (value) =>
                  value!.isEmpty ? 'Enter option ${optionIndex + 1}' : null,
                ),
              );
            }),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: "Correct Option",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              value: questions[index]['correctOption'],
              items: List.generate(
                4,
                    (i) =>
                    DropdownMenuItem(value: i, child: Text("Option ${i + 1}")),
              ),
              onChanged: (value) =>
                  setState(() => questions[index]['correctOption'] = value!),
              validator: (value) =>
              value == null ? 'Select the correct option' : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Quiz",
            style: TextStyle(
              fontFamily: 'Comic Sans MS',
              fontSize: 24,
              color: Colors.white,
            )),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Quiz Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Quiz Name",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onSaved: (value) => quizName = value ?? '',
                  validator: (value) =>
                  value!.isEmpty ? 'Enter quiz name' : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Subject",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onSaved: (value) => subject = value ?? '',
                  validator: (value) =>
                  value!.isEmpty ? 'Enter subject' : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Entry Fee",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => entryFee = int.tryParse(value!) ?? 0,
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Time Limit (seconds)",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => timeLimit = int.tryParse(value!) ?? 0,
                ),
                SizedBox(height: 10),
                SwitchListTile(
                  title: Text("Protected Quiz"),
                  value: isProtected,
                  onChanged: (value) => setState(() => isProtected = value),
                ),
                if (isProtected)
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Password",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onSaved: (value) => password = value ?? '',
                    validator: (value) =>
                    isProtected && value!.isEmpty ? 'Enter password' : null,
                  ),
                SwitchListTile(
                  title: Text("Live Quiz"),
                  value: isLiveQuiz,
                  onChanged: (value) => setState(() => isLiveQuiz = value),
                ),
                if (isLiveQuiz) ...[
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Player Limit",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => playerLimit = int.tryParse(value!) ?? 0,
                    validator: (value) => isLiveQuiz && value!.isEmpty
                        ? 'Enter player limit'
                        : null,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Select Start Time:",
                    style: TextStyle(fontSize: 16, color: Colors.blue[800]),
                  ),
                  ElevatedButton(
                    onPressed: () => _pickDateTime(context, true),
                    child: Text(
                      startTime == null
                          ? 'Pick Start Date & Time'
                          : DateFormat.yMd().add_jm().format(startTime!),
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Select End Time:",
                    style: TextStyle(fontSize: 16, color: Colors.blue[800]),
                  ),
                  ElevatedButton(
                    onPressed: () => _pickDateTime(context, false),
                    child: Text(
                      endTime == null
                          ? 'Pick End Date & Time'
                          : DateFormat.yMd().add_jm().format(endTime!),
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Number of Questions",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      numQuestions = int.tryParse(value) ?? 1;
                      questions = List.generate(numQuestions, (index) => _generateQuestionMap());
                    });
                  },
                ),
                SizedBox(height: 20),
                ...List.generate(numQuestions, _buildQuestionField),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _submitQuiz,
                    child: Text(
                      "Create Quiz",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

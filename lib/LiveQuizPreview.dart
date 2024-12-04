import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_exhibition/LobbyScreen.dart';
// Import QuizAttemptPage
import 'QuizAttempt.dart';

class LiveQuizPreview extends StatelessWidget {
  final String quizId;
  final String quizName;
  final String creatorName;
  final String subject;
  final int entryFee;
  final int timePerQuestion;
  final int totalQuestions;
  final Timestamp startTime;
  final Timestamp endTime;
  final int playerLimit;


  LiveQuizPreview({
    required this.quizId,
    required this.quizName,
    required this.creatorName,
    required this.subject,
    required this.entryFee,
    required this.timePerQuestion,
    required this.totalQuestions,
    required this.startTime,
    required this.endTime,
    required this.playerLimit,
  });

  @override
  Widget build(BuildContext context) {
    String formattedStartTime = DateFormat('yyyy-MM-dd HH:mm').format(startTime.toDate());
    String formattedEndTime = DateFormat('yyyy-MM-dd HH:mm').format(endTime.toDate());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          quizName,
          style: TextStyle(
            fontFamily: 'Comic Sans MS',
            fontSize: 24,
            color: Colors.white,
          ),
        ),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Subject: $subject',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Created by: $creatorName',
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Entry Fee: ${entryFee == 0 ? "Free" : "\$${entryFee}"}',
                      style: TextStyle(
                        fontSize: 18,
                        color: entryFee == 0 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Time per Question: $timePerQuestion seconds',
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Total Questions: $totalQuestions',
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Player Limit: $playerLimit',
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Start Time: $formattedStartTime',
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'End Time: $formattedEndTime',
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Center(
              child: GestureDetector(
                onTap: () async {
                  final currentTime = DateTime.now();
                  final quizStartTime = startTime.toDate();
                  final quizEndTime = endTime.toDate();

                  if (currentTime.isAfter(quizStartTime) && currentTime.isBefore(quizEndTime)) {
                    // Check the participant count
                    final quizDoc = await FirebaseFirestore.instance
                        .collection('quizzes')
                        .doc(quizId)
                        .get();

                    if (quizDoc.exists) {
                      final currentParticipants = quizDoc['currentParticipants'] ?? 0;

                      if (currentParticipants < playerLimit) {
                        // Navigate to the lobby screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LobbyScreen(
                              quizId: quizId,
                              playerLimit: playerLimit,
                            ),
                          ),
                        );
                      } else {
                        // Show "Quiz in Progress" message
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Quiz in Progress'),
                            content: Text('The quiz has already started and is full.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  } else {
                    // Show error if quiz hasn't started or has ended
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Unavailable'),
                        content: Text('The quiz is not available at this time.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },

                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.purple],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    'Attempt Quiz',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
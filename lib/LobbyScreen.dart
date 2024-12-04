import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'QuizAttempt.dart';

class LobbyScreen extends StatefulWidget {
  final String quizId;
  final int playerLimit;

  LobbyScreen({required this.quizId, required this.playerLimit});

  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  late Stream<DocumentSnapshot> quizStream;

  @override
  void initState() {
    super.initState();
    quizStream = FirebaseFirestore.instance
        .collection('quizzes')
        .doc(widget.quizId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Lobby'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: quizStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Quiz not found.'));
          }

          final quizData = snapshot.data!;
          final data = quizData.data() as Map<String, dynamic>; // Cast to Map
          final currentParticipants = data.containsKey('currentParticipants')
              ? data['currentParticipants']
              : 0;

          if (currentParticipants >= widget.playerLimit) {
            // Redirect to Quiz Attempt Page
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizAttemptPage(
                    quizId: widget.quizId,
                  ),
                ),
              );
            });
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Waiting for participants...',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(
                  'Current Participants: $currentParticipants / ${widget.playerLimit}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                CircularProgressIndicator(),
              ],
            ),
          );
        },
      ),
    );
  }
}

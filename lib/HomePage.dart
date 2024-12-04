import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project_exhibition/ProfilePage.dart';
import 'package:project_exhibition/SettingPage.dart';
import 'BottomNavBar.dart';
import 'CreateQuiz.dart';
import 'LiveQuizPreview.dart';
import 'QuizPreview.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isButtonPressed = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> logout() async {
    try {
      await _secureStorage.deleteAll();
      await _auth.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      throw Exception('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? userId = user?.uid;
    final String? userName = user?.displayName;
    final String? userMail = user?.email;


    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer(); // Open the drawer using the key
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
          ),
        ),
        title: Text(
          "Home",
          style: TextStyle(
            fontFamily: 'Comic Sans MS',
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              accountName: Text(
                "$userName", // Replace with dynamic user name
                style: TextStyle(
                  fontFamily: 'Comic Sans MS',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              accountEmail: Text(
                "$userMail", // Replace with dynamic user email
                style: TextStyle(
                  fontFamily: 'Comic Sans MS',
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/images/profile.png'),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("Settings"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text("Profile"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text("About"),
                    onTap: () {
                      // Handle about tap
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Logout"),
                    onTap: () {
                      logout();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/wallet');
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Balance: \$0.00",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade900,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.add, color: Colors.orange.shade900),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTapDown: (_) => setState(() => isButtonPressed = true),
                onTapUp: (_) => setState(() => isButtonPressed = false),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizCreationPage()),
                  );
                },
                child: AnimatedScale(
                  scale: isButtonPressed ? 0.95 : 1.0,
                  duration: Duration(milliseconds: 200),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.symmetric(vertical: 14),
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
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Create Quiz",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Static Quizzes",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            // Static Quizzes
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('quizzes')
                    .where('isLiveQuiz', isEqualTo: false) // Exclude live quizzes
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No static quizzes available right now.",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[800],
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var quiz = snapshot.data!.docs[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: quiz['entryFee'] > 0
                              ? Colors.red.shade100
                              : Colors.green.shade100,
                          child: Icon(
                            quiz['entryFee'] > 0 ? Icons.paid : Icons.free_breakfast,
                            color: quiz['entryFee'] > 0 ? Colors.red : Colors.green,
                          ),
                        ),
                        title: Text(
                          quiz['quizName'] ?? '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("By: ${quiz['creatorName']}"),
                        trailing: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: quiz['entryFee'] > 0 ? Colors.red.shade50 : Colors.green.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            quiz['entryFee'] > 0 ? "\$${quiz['entryFee']}" : "Free",
                            style: TextStyle(
                              color: quiz['entryFee'] > 0 ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizPreviewPage(
                                quizId: quiz.id,
                                quizName: quiz['quizName'] ?? 'Quiz',
                                creatorName: quiz['creatorName'] ?? 'Unknown',
                                subject: quiz['subject'] ?? 'General',
                                entryFee: quiz['entryFee'] ?? 0,
                                timePerQuestion: quiz['timeLimit'] ?? 60,
                                totalQuestions: (quiz['questions'] as List).length,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Live Quizzes",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('quizzes')
                    .where('isLiveQuiz', isEqualTo: true)
                    /*.where('startTime', isLessThanOrEqualTo: currentTS)
                    .where('endTime', isGreaterThanOrEqualTo: currentTS)*/
                    .snapshots(),
                builder: (context, snapshot) {
                  // Check if the snapshot has data or not
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  // Safely check if there is data in the snapshot
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No live quizzes available right now.",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[800],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var quiz = snapshot.data!.docs[index];

                      // Null check for quiz['quizName'] and other properties
                      String quizName = quiz['quizName'] ?? 'Unnamed Quiz';
                      String creatorName = quiz['creatorName'] ?? 'Unknown';
                      String subject = quiz['subject'] ?? 'General';
                      int entryFee = quiz['entryFee'] ?? 0;
                      int timeLimit = quiz['timeLimit'] ?? 60;
                      int playerLimit = quiz['playerLimit'] ?? 0;
                      var questions = quiz['questions'] ?? [];

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: entryFee > 0 ? Colors.red.shade100 : Colors.green.shade100,
                          child: Icon(
                            entryFee > 0 ? Icons.paid : Icons.free_breakfast,
                            color: entryFee > 0 ? Colors.red : Colors.green,
                          ),
                        ),
                        title: Text(
                          quizName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("By: $creatorName"),
                        trailing: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: entryFee > 0 ? Colors.red.shade50 : Colors.green.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            entryFee > 0 ? "\$${entryFee}" : "Free",
                            style: TextStyle(
                              color: entryFee > 0 ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LiveQuizPreview(
                                quizId: quiz.id,
                                quizName: quizName,
                                creatorName: creatorName,
                                subject: subject,
                                entryFee: entryFee,
                                timePerQuestion: timeLimit,
                                totalQuestions: questions.length,
                                startTime: quiz['startTime'],
                                endTime: quiz['endTime'],
                                playerLimit: playerLimit,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            )

          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0,),
    );
}}

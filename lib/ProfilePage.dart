import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'BottomNavBar.dart';

class ProfilePage extends StatelessWidget {
// Replace with dynamic user ID if needed

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? userId = user?.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile",
          style: TextStyle(
            fontFamily: 'Comic Sans MS',
            fontSize: 24,
            color: Colors.white,
          ),),
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
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("User data not found."));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Profile Header
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(userData['profilePicture'] ??
                            'https://static.thenounproject.com/png/363639-200.png'), // Placeholder if no image
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData['full_name'] ?? "Unknown User",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Age: ${userData['age'] ?? "N/A"}",
                            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Statistics Section
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildStatTile(
                          icon: Icons.quiz,
                          title: "Attempted Quizzes",
                          value: userData['attempted_quizzes']?.toString() ?? "0",
                        ),
                        Divider(),
                        _buildStatTile(
                          icon: Icons.star,
                          title: "Total Points",
                          value: userData['points']?.toString() ?? "0",
                        ),
                        Divider(),
                        _buildStatTile(
                          icon: Icons.emoji_events,
                          title: "Badges Earned",
                          value: userData['badges']?.toString() ?? "None",
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Achievements Section
                Text(
                  "Achievements",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                userData['badges'] != null
                    ? Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: (userData['badges'] as List<dynamic>)
                      .map((badge) => Chip(
                    label: Text(badge),
                    backgroundColor: Colors.amber,
                    avatar: Icon(Icons.emoji_events, color: Colors.white),
                  ))
                      .toList(),
                )
                    : Text("No badges earned yet."),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildStatTile({required IconData icon, required String title, required String value}) {
    return Row(
      children: [
        Icon(icon, size: 32, color: Colors.blueAccent),
        SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

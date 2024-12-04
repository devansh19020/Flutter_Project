import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project_exhibition/LoginPage.dart';


import 'HomePage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final storage = FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    String? isLoggedIn = await storage.read(key: 'isLoggedIn');  // Check secure login status
    if (isLoggedIn == 'true') {
      Navigator.pushReplacementNamed(context, '/home');  // Navigate to home if logged in
    } else {
      Navigator.pushReplacementNamed(context, '/login');  // Otherwise, navigate to login
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Container(
        height: size.height,
        width: size.width,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // You can put your app logo here
              Image.asset('assets/images/logo.png',
                  color: isDarkMode ? Colors.white : Colors.blue.shade600,
                  height: 100,
                  width: 100
              ),
              SizedBox(height: 20),
              Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,

                ),
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(
                color: Theme.of(context).primaryColorLight,
              )
            ],
          ),
        ),
      ),
    );
  }
}
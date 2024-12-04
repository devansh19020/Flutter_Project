import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_exhibition/SplashScreen.dart';
import 'package:project_exhibition/themes/light_theme.dart';
import 'HomePage.dart';
import 'Leaderboard.dart';
import 'LoginPage.dart';
import 'ProfilePage.dart';
import 'WalletPage.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBuVG9lI2Hphihmk7RP8RsINMrWD3vxw3k",
            authDomain: "eduquest-9dda5.firebaseapp.com",
            projectId: "eduquest-9dda5",
            storageBucket: "eduquest-9dda5.firebasestorage.app",
            messagingSenderId: "873027921876",
            appId: "1:873027921876:web:c95ec355c12d6bd4931841"
        ));
  }else{
    await Firebase.initializeApp();
  }


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: lightTheme(),
      themeMode: ThemeMode.light,
      initialRoute: '/splash',
      routes: {
        '/home': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
        '/leaderboard': (context) => LeaderboardPage(),
        '/wallet': (context) => WalletPage(),
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}


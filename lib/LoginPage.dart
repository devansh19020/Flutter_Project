import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project_exhibition/ForgotPassword.dart';
import 'package:project_exhibition/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:project_exhibition/SignUpPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key,});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final storage = FlutterSecureStorage();  // Secure storage instance

  Future<void> _saveLoginStatus() async {
    await storage.write(key: 'isLoggedIn', value: 'true');  // Save login status securely
  }


  Future<void> _loginUser() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      await _saveLoginStatus();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      print("Login failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body:SingleChildScrollView(
        child: Container(
          height: size.height,
          width: size.width,
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: size.height * 0.2, top: size.height * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Dear Learner, \nWelcome Back", style: Theme.of(context).textTheme.headlineLarge,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [

                    SizedBox(height: 50,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email"
                        )
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        obscuringCharacter: '*',
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Password"
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
                      },
                        child: Text("Forgot Password?", style: Theme.of(context).textTheme.bodySmall,)),
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 42,  // Set the uniform width
                          height: 42,  // Set the uniform height
                          child: Image.asset(
                            'assets/images/google.png',
                            fit: BoxFit.contain,  // Resize the image while maintaining aspect ratio
                          ),
                        ),
                        SizedBox(width: 30),  // Spacing between icons
                        SizedBox(
                          width: 42,  // Set the uniform width
                          height: 42,  // Set the uniform height
                          child: Image.asset(
                            'assets/images/Facebook.png',
                            fit: BoxFit.contain,  // Resize the image while maintaining aspect ratio
                          ),
                        ),
                        SizedBox(width: 27),  // Spacing between icons
                        SizedBox(
                          width: 50,  // Set the uniform width
                          height: 50,  // Set the uniform height
                          child: Image.asset(
                            'assets/images/linkedin.png',
                            fit: BoxFit.contain,  // Resize the image while maintaining aspect ratio
                          ),
                        ),
                      ],
                    )

                  ],
                ),
                Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              elevation: 4,
                              padding: EdgeInsets.all(12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                            onPressed: _loginUser ,
                            child: Text(
                              "Login",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),),
                      ),
                      SizedBox(height: 30,),
                      TextButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
                        },
                          child: Text("Create account", style: Theme.of(context).textTheme.bodySmall,))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:know_your_car/Splash_Screens/Register.dart';
import 'package:know_your_car/main.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Forgot.dart';

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email='';
  String password='';
  bool showSpinner = false;
  String errorMessage = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.black,
            body: ModalProgressHUD(
              inAsyncCall: showSpinner,
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/register.jpg'),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 450,
                        child: Stack(
                          children: [
                            Positioned(
                              child: Container(
                                // margin: EdgeInsets.only(top:),
                                child: Center(
                                  child: Text(
                                    'Login',
                                    style: GoogleFonts.merriweather(
                                      color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 50,
                                    ),
                                    // TextStyle(
                                    //   color: Colors.white,
                                    //   fontWeight: FontWeight.bold,
                                    //   fontSize: 40,
                                    //   fontFamily: 'Cursive'
                                    // ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(30),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(186,191,31,0.7),
                                    blurRadius: 20.0,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom:
                                            BorderSide(color: Colors.grey.shade300),
                                      ),
                                    ),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Enter your Email",
                                        hintStyle:
                                            TextStyle(color: Colors.grey.shade400),
                                      ),
                                      style: TextStyle(color: Colors.black),
                                      onChanged: (value) {
                                        email = value;
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom:
                                            BorderSide(color: Colors.grey.shade300),
                                      ),
                                    ),
                                    child: TextField(
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Password",
                                        hintStyle:
                                            TextStyle(color: Colors.grey.shade400),
                                      ),
                                      style: TextStyle(color: Colors.black),
                                      onChanged: (value) {
                                        password = value;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            MaterialButton(
                              onPressed: () async {
                                setState(() {
                                  showSpinner = true;
                                  errorMessage = '';
                                });
                                if (email.isEmpty || password.isEmpty) {
                                  errorMessage = 'Fill all Details';
                                } else {
                                  try {
                                    var user = await _auth
                                        .signInWithEmailAndPassword(
                                        email: email, password: password);
                                    if (user != null) {
                                      SharedPreferences prefs = await SharedPreferences
                                          .getInstance();
                                      prefs.setString('userId', user.user!.uid);
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(
                                              builder: (context) => MyApp()));
                                    }
                                    setState(() {
                                      showSpinner = false;
                                    });
                                  }
                                  on FirebaseAuthException catch (e) {
                                    setState(() {
                                      showSpinner = false;
                                      if (e.code == 'user-not-found') {
                                        errorMessage = 'No user found for that email.';
                                      } else if (e.code == 'wrong-password') {
                                        errorMessage =
                                        'Wrong password provided for that user.';
                                      } else {
                                        errorMessage = 'An Error occured. Please Try again.';
                                      }

                                    });
                                  }
                                }
                                if (errorMessage.isNotEmpty) {
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    backgroundColor: Color(0xFF333333),
                                    content: Text(
                                      errorMessage,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    action: SnackBarAction(
                                      label: 'Dismiss',
                                      onPressed: () {
                                        // Some code to undo the change.
                                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                      },
                                    ),
                                  ));
                                }

                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromRGBO(186,191,31,1),
                                      Color.fromRGBO(186,191,31,0.7),
                                      Color.fromRGBO(186,191,31,1),
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Register()));
                              },
                              child: Text(
                                "Don't have an account? Create One!",
                                style: TextStyle(
                                  color: Colors.white,
                                    // color: Color.fromRGBO(143, 148, 251, 1),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>forgotpass()));
                              },
                              child: Text(
                                'Forgot Pasword?',
                                style: TextStyle(
                                    color: Colors.white,
                                    // color: Color.fromRGBO(143, 148, 251, 1),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }
}

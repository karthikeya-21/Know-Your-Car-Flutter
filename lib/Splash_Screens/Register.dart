import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Login.dart';
import 'Profile.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late String email, password;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/rolls.jpeg'),
                fit: BoxFit.contain,
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: 400,

                  child: Center(
                    child: Text(
                      'Register',
                      style: GoogleFonts.merriweather(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                    )
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
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
                            TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter your Email",
                                hintStyle: TextStyle(color: Colors.grey.shade400),
                              ),
                              style: TextStyle(color: Colors.black),
                              onChanged: (value) {
                                email = value;
                              },
                            ),
                            Divider(
                              color: Colors.grey.shade300,
                              height: 1,
                            ),
                            Focus(
                              onFocusChange: (hasFocus){
                                if (hasFocus) {
                                  // Show the additional information when the password field is focused
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    backgroundColor: Color(0xFF333333),
                                    content: Text(
                                      style: TextStyle(color: Colors.white),
                                      'Password must be minimum 8 characters long and should contain at least 1 digit.',
                                    ),
                                    duration: Duration(seconds: 3),
                                  ));
                                }
                              },
                              child: TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.grey.shade400),
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
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                            if (email.isEmpty || password.isEmpty) {
                              errorMessage = 'Fill all Details';
                            } else if (!isEmailValid(email)) {
                              errorMessage = 'Invalid Email';
                            } else if (!isPasswordValid(password)) {
                              errorMessage = 'Invalid Password';
                            } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileDetailsPage(
                                  email: email,
                                  password: password,
                                ),
                              ),
                            );
                          }
                            if (errorMessage.isNotEmpty) {
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
                              'Register',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Login(),
                            ),
                          );
                        },
                        child: Text(
                          'Already a User? Login!',
                          style: TextStyle(
                            color: Colors.white,
                            // color: Color.fromRGBO(143, 148, 251, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
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
    );
  }
}
bool isEmailValid(String email) {
  // Regular expression for email validation
  final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}

bool isPasswordValid(String password) {
  // Regular expression for password validation
  final passwordRegex =
  RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()-_=+])[A-Za-z\d!@#$%^&*()-_=+]{8,}$');
  return passwordRegex.hasMatch(password);
}

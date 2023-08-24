import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Splash_Screens/Login.dart';

final _auth = FirebaseAuth.instance;
class deleteaccount extends StatefulWidget {
  const deleteaccount({super.key});

  @override
  State<deleteaccount> createState() => _deleteaccountState();
}

class _deleteaccountState extends State<deleteaccount> {

  void _deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: pass,
        );

        // Reauthenticate the user with the provided credentials
        await user.reauthenticateWithCredential(credential);
        await user.delete();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('userId');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Login()),
              (route) => false,
        );
        print('Account deleted successfully.');
      }
    } catch (e) {
      print('Failed to delete account: $e');
    }
  }

  String pass='';
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Delete Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please enter your password to confirm account deletion:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value){
                pass=value;
              },
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            MaterialButton(
              onPressed: _deleteAccount,
              // onPressed: () {  },
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
                    'Delete Account',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
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

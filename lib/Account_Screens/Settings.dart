import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Splash_Screens/Login.dart';
import 'deleteaccount.dart';
final _auth = FirebaseAuth.instance;
class Settings extends StatelessWidget {
  void _onReportErrorPressed() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'kaarthikeyadeekonda@gmail.com', // Replace with the support email address
      queryParameters: {'subject': 'Error-Report'}, // Subject of the email
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      print('Could not launch email app.');
    }
  }
  void _resetPassword(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset Password'),
          content: Text('Please check your mail to reset the password.'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog

                try {
                  final user = _auth.currentUser;
                  if (user != null) {
                    await _auth.sendPasswordResetEmail(email: user.email!);
                    print('Password reset email sent successfully.');
                    // Show a confirmation snackbar or toast here
                  }
                } catch (e) {
                  print('Failed to send password reset email: $e');
                  // Show an error snackbar or toast here
                }
              },
              child: Text('Reset'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
// Inside the Settings class


  void _disableAccountConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Verify Account'),
          content: Text('Are you sure you want to verify your account?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog
                // Code to disable the account goes here
                try {
                  final user = _auth.currentUser;
                  if (user != null) {
                    await user.sendEmailVerification();
                    print('Account disabled successfully.');
                  }
                } catch (e) {
                  print('Failed to disable account: $e');
                }
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            buildSettingItem(
              'Report an Error',
              'Report an error or bug in the app.',
              Icons.error,
                  () {
                // Implement logic to handle reporting an error
                    _onReportErrorPressed();
              },
            ),
            Divider(),
            buildSettingItem(
              'Reset Password',
              'Change your account password.',
              Icons.lock,
                  () {
                // Implement logic to change password
                    _resetPassword(context);
              },
            ),
            Divider(),
            buildSettingItem(
              'Verify Email',
              'Verify your email  here.',
              Icons.block,
                  () {
                // Implement logic to disable account
                _disableAccountConfirmation(context);
              },
            ),
            Divider(),
            buildSettingItem(
              'Delete Account',
              'Permanently delete your account.',
              Icons.delete,
                  () {
                // Implement logic to delete account
                //     _deleteAccount(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>deleteaccount()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSettingItem(String title, String description, IconData iconData, VoidCallback onPressed) {
    return MaterialButton(
      onPressed: onPressed,
      child: ListTile(
        title: Text(title),
        subtitle: Text(description),
        leading: Icon(iconData),
      ),
    );
  }
}

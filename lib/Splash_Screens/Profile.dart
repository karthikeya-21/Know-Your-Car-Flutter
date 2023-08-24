import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// ...


final _auth = FirebaseAuth.instance;
DatabaseReference dbref=FirebaseDatabase.instance.ref().child('users');
class ProfileDetailsPage extends StatefulWidget {
  final String email,password;
  ProfileDetailsPage({required this.email,required this.password});
  @override
  _ProfileDetailsPageState createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  File? _profilePicture;
  String imageurl="";
  Future<void> _pickProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profilePicture = File(pickedFile.path);
      });

      // Get the current timestamp to generate a unique image filename
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      // Create a reference to the Firebase Storage bucket and the image file
      firebase_storage.Reference storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('profile_$timestamp.jpg');

      // Upload the image file to Firebase Storage
      await storageRef.putFile(_profilePicture!);

      // Get the download URL of the uploaded image
      String downloadURL = await storageRef.getDownloadURL();
      imageurl=downloadURL;
      print('Image uploaded. Download URL: $downloadURL');
    }
  }

  void _createUserCollection(String userId) async {
    // Create a Firestore collection for the user using their userId
    final userCollection = FirebaseFirestore.instance.collection(userId);
  }

  bool showSpinner = false;
  String errorMessage = '';
  String name='';
  String bio='';
  String ph='';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.white,
        // scaffoldBackgroundColor: Color(0x2D2D2D),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          // Add more text styles as needed
        ),
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Profile Details')),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                GestureDetector(
                  onTap: _pickProfilePicture,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey,
                    backgroundImage: _profilePicture != null ? FileImage(_profilePicture!) : null,
                    child: _profilePicture == null ? Icon(Icons.camera_alt, size: 50, color: Colors.white) : null,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  onChanged: (value){
                    setState(() {
                      name=value;
                    });
                  },
                  decoration: InputDecoration(labelText: 'User Name'),
                ),
                TextField(
                  onChanged: (value){
                    setState(() {
                      bio=value;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Bio'),
                ),
                TextField(
                  onChanged: (value){
                    setState(() {
                      ph=value;
                    });
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Phone'),
                ),
                SizedBox(height: 16),
                MaterialButton(
                  // color: Color.fromRGBO(186,191,31,1),
                  onPressed: () async {
                    setState(() {
                      showSpinner=true;
                      errorMessage = '';
                    });

                    if(name.isEmpty || bio.isEmpty || ph.isEmpty){
                        setState(() {
                          print("Hello");
                          errorMessage='Fill all Details';
                          showSpinner=false;
                        });
                    }
                    else {
                      try {
                        var newuser = await _auth
                            .createUserWithEmailAndPassword(email: widget.email,
                            password: widget.password);
                        if (newuser.user != null) {
                          Map<String, String> user = {
                            'name': name,
                            'phone': ph,
                            'email': widget.email,
                            'image': imageurl,
                            'bio': bio,
                            'uid': newuser.user!.uid,
                          };
                          _createUserCollection(newuser.user!.uid);
                          await dbref.push().set(user);
                          SharedPreferences prefs = await SharedPreferences
                              .getInstance();
                          prefs.setString('userId', newuser.user!.uid);
                          Navigator.pushAndRemoveUntil(
                            context, MaterialPageRoute(
                              builder: (context) => MyApp()), (
                              route) => false,);
                          setState(() {
                            showSpinner = false;
                          });
                        }
                      }
                      on FirebaseAuthException catch (e) {
                        if (e.code == "email-already-in-use") {
                          errorMessage = 'Email is already in use';
                        }
                      }
                    }
                    if (errorMessage.isNotEmpty) {
                      setState(() {
                        showSpinner = false;
                      });
                      print(errorMessage);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.white,
                        content: Text(
                          errorMessage,
                          style: TextStyle(color: Colors.black),
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
                        'Submit',
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
        ),
      ),
    );
  }
}

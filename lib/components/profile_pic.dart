import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class profile_pic extends StatefulWidget {
  final String pic;
  final String dbkey;
  profile_pic({required this.pic,required this.dbkey});

  @override
  State<profile_pic> createState() => _profile_picState();
}

class _profile_picState extends State<profile_pic> {
  File? _profilePicture;
  final _auth = FirebaseAuth.instance;
  DatabaseReference dbref=FirebaseDatabase.instance.ref().child('users');
  String imageurl="";

  Future<void> _pickProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    print("pressed");
    if (pickedFile != null) {
        _profilePicture = File(pickedFile.path);
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
      await dbref.child(widget.dbkey).update({'image':downloadURL});
      setState(() {
        imageurl=downloadURL;
      });
      print('Image uploaded. Download URL: $downloadURL');
    }
  }


  @override
  Widget build(BuildContext context) {
    String pic = imageurl!="" ? imageurl : widget.pic;
    return GestureDetector(
      onTap: (){
        _pickProfilePicture();
      },
      child:
      pic==""?Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage("assets/profile.png"),fit: BoxFit.fill,
            )
        ),
      ):
      Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(pic),fit: BoxFit.fill,
          )
        ),
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 10),
    //   child: SizedBox(
    //     height: 250, // Adjust the height of the Stack to your liking
    //     width: 250, // Adjust the width of the Stack to your liking
    //     child: Stack(
    //       clipBehavior: Clip.none,
    //       // fit: StackFit.expand,
    //       children: [
    //         CircleAvatar(
    //           backgroundImage: NetworkImage(pic),
    //         ),
    //         // pic==""?
    //         // Container(
    //         //   width: 100,
    //         //   height: 100,
    //         //   decoration: BoxDecoration(
    //         //     shape: BoxShape.circle,
    //         //     image: DecorationImage(image:AssetImage("assets/profile.png"),fit: BoxFit.fitWidth,),
    //         //   ),
    //         // ),
    //         // Image.network(
    //         //   pic,
    //         //   fit: BoxFit.cover,
    //         //   width: 300,
    //         //   height: 250,// Set the fit property to BoxFit.cover
    //         // ),
    //         Positioned(
    //           right: -12,
    //           bottom: 0,
    //           child: SizedBox(
    //             height: 46,
    //             width: 46,
    //             child: MaterialButton(
    //               color: Colors.grey[300],
    //               shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(50),
    //                   side: BorderSide(color: Colors.white)),
    //               onPressed: () {
    //                 print("hello");
    //                 _pickProfilePicture();
    //               },
    //               child: SvgPicture.asset('assets/icons/photo-upload-svgrepo-com.svg'),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}

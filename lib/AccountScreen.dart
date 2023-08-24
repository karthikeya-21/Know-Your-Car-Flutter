import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:know_your_car/Account_Screens/about_us.dart';
import 'package:know_your_car/Splash_Screens/Login.dart';
import 'package:know_your_car/main.dart';
import 'package:know_your_car/Account_Screens/my__account.dart';
import 'package:know_your_car/components/profile_item.dart';
import 'package:know_your_car/components/profile_pic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Account_Screens/Notifications.dart';
import 'Account_Screens/Settings.dart';
DatabaseReference dbref = FirebaseDatabase.instance.ref().child('users');
final _auth = FirebaseAuth.instance;
class AccountScreen extends StatefulWidget {
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login()),
          (route) => false,
    );
  }

  String pic="";
  String bio="";
  String dbkey="";
  void getData() async {
    final user = await _auth.currentUser;
    final snapshot = await dbref.get();
    if (snapshot.exists) {
      Map data = snapshot.value as Map;
      data.forEach((key, value) {
        if (value['uid'] == user?.uid) {
          setState(() {
            pic=value['image'];
            bio=value['bio'];
            dbkey=key;
          });
         // print(value);
        }
      });
    } else {
      print('No data available.');
    }
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 15,
              ),
              profile_pic(pic: pic,dbkey:dbkey,),
              SizedBox(
                height: 20,
              ),
              Text(bio,style: TextStyle(fontFamily: 'RaleWay',fontSize: 22,
              ),),
              SizedBox(
                height: 20,
              ),
              profile_item(title: 'My Account',icon: Icons.person,onpressed:()=> {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>my_account()))
              },),
              profile_item(title: 'Notifications',icon: Icons.notifications,onpressed:()=> {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Notifications()))
              }),
              profile_item(title: 'Settings',icon: Icons.settings,onpressed:()=> {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Settings()))
              }),
              profile_item(title: 'About Us',icon: Icons.description,onpressed:()=> {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>about_us()))
              }),
              profile_item(title: 'Log Out',icon: Icons.logout,onpressed: ()=>_logout(context)),
            ],
          ),
        ),
      );
  }
}

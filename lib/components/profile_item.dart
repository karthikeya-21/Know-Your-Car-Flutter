import 'package:flutter/material.dart';
import 'package:know_your_car/Account_Screens/my__account.dart';
import 'package:shared_preferences/shared_preferences.dart';
class profile_item extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onpressed;
  profile_item({required this.title,required this.icon,required this.onpressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: MaterialButton(
        padding: EdgeInsets.all(20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        //color: Color(0xFFF5F6F9),
        color: Color(0x2D2D2D),
        onPressed: onpressed,
        child: Row(
          children: [
            Icon(icon,size: 22,color: Colors.indigoAccent,),
            SizedBox(width: 20,),
            Expanded(child: Text(title),),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}

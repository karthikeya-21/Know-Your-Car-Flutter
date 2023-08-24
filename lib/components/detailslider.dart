import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:know_your_car/Car.dart';

class detailslider extends StatelessWidget {
  final String icon;
  final String specification;

  detailslider({required this.specification,required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color.fromRGBO(244, 244,246, 1),
      ),
      height: 200,
      width: 100,
      padding: EdgeInsets.all(10.0),
      // color: Colors.grey.shade400,
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            width: 45,
            height: 45,
            // color: Colors.black,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            specification,style: TextStyle(
            color: Colors.black,
            fontFamily: 'Impact',
          ),
          ),
        ],
      ),

    );
  }
}

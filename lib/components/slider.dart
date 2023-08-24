import 'dart:math';

import 'package:flutter/material.dart';
import 'package:know_your_car/Car.dart';
import 'package:know_your_car/constants.dart';
import 'package:know_your_car/detailsscreen.dart';

class imgslider extends StatelessWidget {
  final Car car;
  final String tag;
  imgslider({required this.car,required this.tag});
  @override
  Widget build(BuildContext context) {
    return Card(

      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: MaterialButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Details(
                car: car,tag:tag,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: tag,
              child: AspectRatio(aspectRatio: 16/9,
              child: Image.network(car.image, fit: BoxFit.fill),),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0,),
                child: Text(
                  '${car.name}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:know_your_car/constants.dart';
import 'package:know_your_car/BrandsScreen.dart';

class logomaker extends StatelessWidget {
  final car;
  logomaker({required this.car});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(

        elevation: 5,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Brands(
                brand: car.brand,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          alignment: Alignment.center,
          width: 150,
          height: 150,
          child: Image.network(
            car.logo,
            fit: BoxFit.fill,
          ),
        ),
      ),

    );
  }
}

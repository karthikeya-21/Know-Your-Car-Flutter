import 'package:flutter/material.dart';
import 'package:know_your_car/Car.dart';
import 'package:know_your_car/components/slider.dart';
import 'components/logo.dart';


List<Car>wishlist=[];

List<dynamic> getUniqueCarsByBrand(List<dynamic> cars) {
  List uniqueBrands = cars.map((car) => car.brand).toSet().toList();
  List<dynamic> uniqueCars = [];

  for (String brand in uniqueBrands) {
    Car car = cars.firstWhere((car) => car.brand == brand);
    uniqueCars.add(car);
  }
  return uniqueCars;
}
// final List<Widget> brands=uniqueCars.map((e) => logomaker(car: e)).toList();

final TextStyle hometext=TextStyle(
  color: Colors.white,fontWeight: FontWeight.bold,
  fontSize: 22,
);


final TextStyle detailstext=TextStyle(
  color: Colors.grey,
);


final List<Widget> favitems = wishlist.map(
      (item) =>imgslider(car: item,tag: '',),
).toList();



// final List<Widget> sliders = cars2.map(
//         (item) => imgslider(car: item)
// ).toList();
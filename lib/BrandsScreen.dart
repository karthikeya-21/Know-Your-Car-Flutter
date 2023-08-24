import 'dart:math';

import 'package:flutter/material.dart';
import 'package:know_your_car/Car.dart';
import 'package:know_your_car/constants.dart';
import 'package:know_your_car/detailsscreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Brands extends StatefulWidget {
  final String brand;
  Brands({required this.brand});

  @override
  State<Brands> createState() => _BrandsState();
}

class _BrandsState extends State<Brands> {
  Future<List<Car>> fetchCarsByBrand(String brand) async {
    final response = await http.get(
      Uri.parse('https://know-your-car.onrender.com/brand/$brand'),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      List<Car> cars = jsonData.map((item) => Car.fromJson(item)).toList();
      return cars;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    // List<Car> filteredCars = filterCarsByBrand(cars2, widget.brand);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Know Your Car'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<Car>>(
            future: fetchCarsByBrand(widget.brand),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Please Check Your Internet Connection and Try Again'),
                );
              } else {
                List<Car> cars = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: cars.length,
                  itemBuilder: (BuildContext context, int index) {
                    Car car = cars[index];
                    String tag='heroTag_${Random().nextInt(100000)}';
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Card(
                        // Wrap the Container with Card
                        elevation: 5, // Add elevation here
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Details(
                                  car: car,tag: tag,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Hero(
                                  tag: tag,
                                  child: Image.network(
                                    car.image,
                                    fit: BoxFit.fitWidth,
                                    width: 350,
                                    height: 130,
                                  ),
                                ),
                              ),
                              Center(child: Text(car.name,style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Georgia'
                              ),),),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Rs. ${car.price}',style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                      fontFamily: 'Arial',
                                    ),
                                    ),
                                    Text('Rating: ${car.rating}',style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                      fontFamily: 'Arial',
                                    ),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:know_your_car/constants.dart';
import 'package:know_your_car/Car.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:know_your_car/components/slider.dart';

import 'detailsscreen.dart';

class HomeTab extends StatelessWidget {
  Future<List<Car>> fetchData() async {
    // Bypass SSL certificate validation for testing purposes
    HttpClient httpClient = HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

    final response = await http.get(Uri.parse(
        'https://know-your-car.onrender.com/')); // Replace with your API URL

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      final List<Car> cars =
          jsonData.map((json) => Car.fromJson(json)).toList();
      return cars;
    } else {
      throw Exception('Failed to load data');
    }
  }

  List<dynamic> getRecentReleasedCars(List<dynamic> cars) {
    int currentYear = DateTime.now().year;
    return cars.where((car) => int.parse(car.year) == currentYear).toList();
  }

  List<dynamic> getTopRatedCars(List<dynamic> cars) {
    cars.sort((a, b) => b.rating.compareTo(a.rating));
    List<dynamic> topRatedCars = cars.take(5).toList();
    return topRatedCars;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 260,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/app-logo.png'),fit: BoxFit.fill
            ),
          ),
        ),
        SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(45,45,45,1),
              borderRadius: BorderRadius.circular(20),
            ),
            // color: Colors.grey,
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.only(top: 250),
            // padding: EdgeInsets.only(top: 250.0),
            child: FutureBuilder<List?>(
                future: fetchData(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 50.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Text('Please Check Your Internet Connection and Try Again'),
                        );
                      } else {
                        List data = snapshot.data ?? [];
                        List<dynamic> recentReleasedCars =
                            getRecentReleasedCars(data);
                        List<dynamic> topRatedCars = getTopRatedCars(data);
                        List<dynamic> uniqueCars = getUniqueCarsByBrand(data);
                        final List<Widget> brandslider =
                            uniqueCars.map((item) => imgslider(car: item,tag: 'heroTag_${Random().nextInt(100000)}',)).toList();
                        final List<Widget> recents = recentReleasedCars
                            .map((item) => imgslider(car: item,tag: 'heroTag_${Random().nextInt(100000)}'))
                            .toList();
                        final List<Widget> top = topRatedCars
                            .map((item) => imgslider(car: item,tag: 'heroTag_${Random().nextInt(100000)}'))
                            .toList();
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Recent Releases', style: hometext),
                              Container(
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                    autoPlay: true,
                                    aspectRatio: 16 / 9,
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    autoPlayAnimationDuration:
                                        Duration(milliseconds: 800),
                                    viewportFraction: 0.8,
                                    enlargeCenterPage: true,
                                  ),
                                  items: recents,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Different Brands',
                                style: hometext,
                              ),
                              Container(
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                    autoPlay: true,
                                    aspectRatio: 16 / 9,
                                    autoPlayCurve: Curves.fastEaseInToSlowEaseOut,
                                    autoPlayAnimationDuration:
                                        Duration(milliseconds: 2000),
                                    viewportFraction: 0.8,
                                    enlargeCenterPage: true,
                                  ),
                                  items: brandslider,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Top Rated Cars',
                                style: hometext,
                              ),
                              Container(
                                child: CarouselSlider(
                                  items: top,
                                  options: CarouselOptions(
                                    autoPlay: true,
                                    aspectRatio: 16 / 9,
                                    autoPlayCurve: Curves.fastLinearToSlowEaseIn,
                                    autoPlayAnimationDuration:
                                        Duration(milliseconds: 2500),
                                    viewportFraction: 0.8,
                                    enlargeCenterPage: true,
                                  ),
                                ),
                              ),
                            ]);
                      }
                  }
                }),
          ),
        ),
      ],
    );
  }
}

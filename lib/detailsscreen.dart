import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:know_your_car/Car.dart';
import 'package:know_your_car/components/detailslider.dart';
import 'OrderScreen.dart';
import 'constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:know_your_car/Car.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:know_your_car/components/slider.dart';
final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;

class Details extends StatefulWidget {
  final Car car;
  final String tag;
  Details({required this.car,required this.tag});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  Future<bool> searchCarInFirestore(String carName) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection(user!.uid)
          .where('name', isEqualTo: carName)
          .get();

      // If any documents are found with the given car name, return true
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      // Handle any errors that might occur during the Firestore query
      print('Error searching for car in Firestore: $e');
      return false;
    }
  }

  final TextStyle tabletext=TextStyle(
    fontFamily: 'Impact',
  );

  void showSnackBarMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),// Adjust the duration as needed
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Car car = widget.car;
    List<Widget>items=[
      detailslider(specification: car.specifications.fuel, icon: 'assets/icons/fuel-pump-svgrepo-com.svg'),
      detailslider(specification: car.specifications.engine, icon: 'assets/icons/engine-motor-svgrepo-com.svg'),
      detailslider(specification: car.specifications.power, icon: 'assets/icons/laptop-wired-svgrepo-com.svg'),
      detailslider(specification: car.specifications.drivetrain, icon: 'assets/icons/manual-gear-svgrepo-com.svg'),
      detailslider(specification: car.specifications.acceleration, icon: 'assets/icons/speed-svgrepo-com.svg'),
      detailslider(specification: '${car.specifications.seating} seater', icon: 'assets/icons/car-seat-svgrepo-com.svg')
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Know Your Car'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            // border: Border.all(
            //   color: Colors.black,
            // ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Hero(
                    tag: widget.tag,
                    child: Image.network(
                      car.image,
                      fit: BoxFit.fitWidth,
                      height: 200,
                      width: 700,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                    child: Text(
                  car.name,
                  style: hometext,
                ),),
                SizedBox(
                  height: 10,
                ),
                RatingBar.builder(
                  initialRating: double.parse(car.rating), // Initial rating value (change as needed)
                  minRating: 1, // Minimum rating value (usually 1)
                  direction: Axis.horizontal, // Axis of the rating bar (horizontal or vertical)
                  allowHalfRating: true, // Whether to allow half rating (true/false)
                  itemCount: 5,
                  itemSize: 20  ,// Total number of rating icons
                  // itemPadding: EdgeInsets.symmetric(horizontal: 1.0), // Padding between each rating icon
                  itemBuilder: (context, _) => Icon(
                    Icons.star,

                    color: Colors.amber, // Color of the rating icons
                  ),
                  onRatingUpdate: (rating){}, // Set onRatingUpdate to null to disable updating
                  ignoreGestures: true, // Disable touch gestures
                ),
                SizedBox(
                  height: 10,
                ),
                Text(car.brand,style: TextStyle(
                  fontSize: 25,fontFamily: 'Fantasy'
                ),),
                SizedBox(
                  height: 10,
                ),
                Text('Rs. ${car.price} ',style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia'
                ),),
                Text(
                  'Avg showroom price',
                  style: TextStyle(
                    color: Colors.lime,
                    fontSize: 18,
                    fontFamily: 'Fantasy',
                  ),
                ),
                // SizedBox(
                //   height: 5,
                // ),
                // Text('Rating :${car.rating}'),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    'Key Specifications',
                    style: hometext,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // Table(
                //   border: TableBorder.all(color: Colors.grey.shade400),
                //   children: [
                //     TableRow(
                //       decoration: BoxDecoration(
                //         color: Colors.grey.shade200,
                //       ),
                //       children: [
                //         TableCell(
                //           child: Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: Column(
                //               children: [
                //                 Row(
                //                   children: [
                //                     SvgPicture.asset(
                //                       'assets/icons/fuel-svgrepo-com.svg',
                //                       width: 20,
                //                       height: 20,
                //                     ),
                //                     SizedBox(
                //                       width: 10,
                //                     ),
                //                     Text('Fuel Type', style: detailstext),
                //                   ],
                //                 ),
                //                 SizedBox(
                //                   height: 5,
                //                 ),
                //                 Text(car.specifications.fuel,style: tabletext),
                //               ],
                //             ),
                //           ),
                //         ),
                //         TableCell(
                //           child: Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: Column(
                //               children: [
                //                 Row(
                //                   children: [
                //                     SvgPicture.asset(
                //                       'assets/icons/engine-motor-svgrepo-com.svg',
                //                       width: 20,
                //                       height: 20,
                //                     ),
                //                     SizedBox(
                //                       width: 10,
                //                     ),
                //                     Text(
                //                       'Engine',
                //                       style: detailstext,
                //                     ),
                //                   ],
                //                 ),
                //                 SizedBox(
                //                   height: 5,
                //                 ),
                //                 Text(car.specifications.engine,style: tabletext),
                //               ],
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //     TableRow(
                //       decoration: BoxDecoration(
                //         color: Colors.grey.shade200,
                //       ),
                //       children: [
                //         TableCell(
                //           child: Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: Column(
                //               children: [
                //                 Row(
                //                   children: [
                //                     SvgPicture.asset(
                //                       'assets/icons/laptop-wired-svgrepo-com.svg',
                //                       width: 20,
                //                       height: 20,
                //                     ),
                //                     SizedBox(
                //                       width: 10,
                //                     ),
                //                     Text(
                //                       'Power and Torque',
                //                       style: detailstext,
                //                     ),
                //                   ],
                //                 ),
                //                 SizedBox(
                //                   height: 5,
                //                 ),
                //                 Text(car.specifications.power,style: tabletext),
                //               ],
                //             ),
                //           ),
                //         ),
                //         TableCell(
                //           child: Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: Column(
                //               children: [
                //                 Row(
                //                   children: [
                //                     SvgPicture.asset(
                //                       'assets/icons/manual-gear-svgrepo-com.svg',
                //                       width: 20,
                //                       height: 20,
                //                     ),
                //                     SizedBox(
                //                       width: 10,
                //                     ),
                //                     Text(
                //                       'DriveTrain',
                //                       style: detailstext,
                //                     ),
                //                   ],
                //                 ),
                //                 SizedBox(
                //                   height: 5,
                //                 ),
                //                 Text(car.specifications.drivetrain,style: tabletext),
                //               ],
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //     TableRow(
                //       decoration: BoxDecoration(
                //         color: Colors.grey.shade200,
                //       ),
                //       children: [
                //         TableCell(
                //           child: Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: Column(
                //               children: [
                //                 Row(
                //                   children: [
                //                     SvgPicture.asset(
                //                       'assets/icons/speed-svgrepo-com.svg',
                //                       width: 20,
                //                       height: 20,
                //                     ),
                //                     SizedBox(
                //                       width: 10,
                //                     ),
                //                     Text(
                //                       'Acceleration',
                //                       style: detailstext,
                //                     ),
                //                   ],
                //                 ),
                //                 SizedBox(
                //                   height: 5,
                //                 ),
                //                 Text(car.specifications.acceleration,style: tabletext),
                //               ],
                //             ),
                //           ),
                //         ),
                //         TableCell(
                //           child: Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: Column(
                //               children: [
                //                 Row(
                //                   children: [
                //                     SvgPicture.asset(
                //                       'assets/icons/car-seat-svgrepo-com.svg',
                //                       width: 20,
                //                       height: 20,
                //                     ),
                //                     SizedBox(
                //                       width: 10,
                //                     ),
                //                     Text(
                //                       'Seating Capacity',
                //                       style: detailstext,
                //                     ),
                //                   ],
                //                 ),
                //                 SizedBox(
                //                   height: 5,
                //                 ),
                //                 Text('${car.specifications.seating} seater',style: tabletext),
                //               ],
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 140,
                    enableInfiniteScroll: false,
                    initialPage: 3,
                    viewportFraction: 0.4,
                  ),
                  items: items,
                ),
                SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  onPressed: () async{
                    print(user?.uid);
                      if (await searchCarInFirestore(car.name)) {

                        // showSnackBarMessage(context, 'Already in Favorites');
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>OrdersTab()));
                      } else {
                        try {
                          final userWishlistCollection =FirebaseFirestore.instance.collection(user!.uid);

                          final carData = {
                            '_id': car.id,
                            'name': car.name,
                            'brand': car.brand,
                            'year': car.year,
                            'price': car.price,
                            'rating':car.rating,
                            'specificatios':{
                              'fuel':car.specifications.fuel,
                              'engine':car.specifications.engine,
                              'power':car.specifications.power,
                              'drivetrain':car.specifications.drivetrain,
                              'acceleration':car.specifications.acceleration,
                              'seating':car.specifications.seating,
                            },
                            // image:new Binary(imageFile),
                            'Image':car.image,

                          };

                          await userWishlistCollection.add(carData);
                          showSnackBarMessage(context, 'Added to Favorites');
                          setState(() {

                          });
                        } catch (e) {
                          print(e);
                          showSnackBarMessage(context, 'Failed to add to Favorites');
                        }
                        wishlist.add(car);
                        showSnackBarMessage(context, 'Added to Favorites');
                    };
                  },
                  color: Color.fromRGBO(164, 168,29, 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FutureBuilder<bool>(
                        future: searchCarInFirestore(car.name),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            // Show a loading indicator while waiting for the result
                            return Text('Add to Favorites');
                          } else if (snapshot.hasError || snapshot.data == false) {
                            // Show 'Add to Favorites' if there's an error or the car is not in the wishlist
                            return Text('Add to Favorites');
                          } else {
                            // Show 'Added in Favorites' if the car exists in the wishlist
                            return Text('Go to Wishlist');
                          }
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.shopping_bag_outlined),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // MaterialButton(
                //   onPressed: () {
                //     Navigator.pop(context);
                //   },
                //   color: Colors.lightBlueAccent,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Text('Return to Home'),
                //       SizedBox(
                //         width: 10,
                //       ),
                //       Icon(Icons.arrow_back),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

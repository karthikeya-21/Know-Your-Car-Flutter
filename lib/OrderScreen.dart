import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:know_your_car/components/slider.dart';
import 'package:know_your_car/constants.dart';

import 'Car.dart';
import 'detailsscreen.dart';

class OrdersTab extends StatefulWidget {
  @override
  _OrdersTabState createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> {
  late String userId;

  @override
  void initState() {
    super.initState();
    // Get the current user ID
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WishList'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(userId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching data'),
            );
          }

          final documents = snapshot.data?.docs;
          if (documents == null || documents.isEmpty) {
            return Center(
              child: Text('No items in wishlist'),
            );
          }
          final wishlistCars = documents
              .map((doc) => Car.fromJson(doc.data() as Map<String, dynamic>))
              .toList();
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: wishlistCars.length,
                  itemBuilder: (context, index) {
                    final order = wishlistCars[index];
                    String tag = 'heroTag_${Random().nextInt(100000)}';
                    return Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Card(
                        elevation: 4.0, // Adjust the elevation as needed
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Details(
                                  car: order,
                                  tag: tag,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Hero(
                                  tag: tag,
                                    child: Image.network(
                                  order.image,
                                  width: 100,
                                  height: 100,
                                )),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(order.name),
                                      Text(order.price),
                                      Text(order.rating),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  // You can remove the order from Firestore
                                  await FirebaseFirestore.instance
                                      .collection(userId)
                                      .doc(documents[index].id)
                                      .delete();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

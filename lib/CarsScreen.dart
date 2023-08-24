import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'BrandsScreen.dart';
import 'Car.dart';
import 'detailsscreen.dart';

class ProductsTab extends StatefulWidget {
  @override
  State<ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends State<ProductsTab> {
  late Future<List<dynamic>> _futureBrands;
  String _searchText = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _futureBrands = fetchBrands();
  }

  Future<List<dynamic>> fetchBrands() async {
    final response = await http
        .get(Uri.parse('https://know-your-car.onrender.com/getbrands'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      print(jsonData);
      return jsonData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<dynamic>> fetchCarsByBrand(String brand) async {
    final response = await http.get(
      Uri.parse('https://know-your-car.onrender.com/name/$brand'),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      final List<dynamic> cars =
          jsonData.map((json) => Car.fromJson(json)).toList();
      // print(cars);
      return cars;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchText = value;
                if (_searchText.isEmpty) {
                  _futureBrands = fetchBrands();
                } else {
                  _futureBrands = fetchCarsByBrand(_searchText);
                }
              });
            },
          ),
        ),
        // Expanded(
        //   child: ListView(
        //     children: [
        //       GridView.count(
        //         crossAxisCount: 2,
        //         shrinkWrap: true,
        //         physics: NeverScrollableScrollPhysics(), // Disable GridView scrolling
        //         children: brands,
        //       ),
        //     ],
        //   ),
        // ),
        FutureBuilder<List<dynamic>>(
          future: _futureBrands,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 100.0),
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Please Check Your Internet Connection and Try Again'),
              );
            } else {
              // Data has been fetched successfully
              List? data = snapshot.data;
              print(data?.length);
              if (data!.isEmpty) {
                return Center(
                  child: Text('No Car Found'),
                );
              }
              return _searchText.isNotEmpty && data != null
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          Car car = data[index];
                          String tag='heroTag_${Random().nextInt(100000)}';
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Card(
                              // Wrap the Container with Card
                              color: Color.fromRGBO(84,86,85,1),
                              // color: Color(0x202020),
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
                                          width: 325,
                                          height: 150,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        car.name,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Georgia'),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Rs. ${car.price}',
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black45,
                                              fontFamily: 'Arial',
                                            ),
                                          ),
                                          Text(
                                            'Rating: ${car.rating}',
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black45,
                                              fontFamily: 'Arial',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        children: List.generate(
                          data?.length ?? 0,
                          (index) {
                            final brandData = data?[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MaterialButton(
                                elevation: 5,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Brands(
                                        brand: brandData['brand'],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromRGBO(84,86,85,1),
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
                                    brandData['logo'],
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
            }
          },
        ),
      ],
    );
  }
}

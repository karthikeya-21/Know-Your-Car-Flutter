import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:know_your_car/HomeScreen.dart';
import 'package:know_your_car/CarsScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'OrderScreen.dart';
import 'Splash_Screens/Profile.dart';
import 'package:know_your_car/Splash_Screens/Login.dart';
import 'AccountScreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('userId');
  // print(userId);
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.white,
        // scaffoldBackgroundColor: Color(0x2D2D2D),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          // Add more text styles as needed
        ),
      ),
      home: userId != null ? MyApp() : Login()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    HomeTab(),
    ProductsTab(),
    OrdersTab(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          // appBar: AppBar(
          //   title: Text('Know Your Car'),
          // ),
          body: _tabs[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            fixedColor: Colors.white,
            currentIndex: _currentIndex,
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home,color: Colors.white,),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_customize,color: Colors.white,),
                label: 'Cars',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_basket,color: Colors.white,),
                label: 'Wishlist',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person,color: Colors.white,),
                label: 'Account',
              ),
            ],
            // selectedItemColor: Color(0xa4a81d),
            // unselectedItemColor: Colors.white, // Set label color for unselected items

          ),
        ),
    );
  }
}




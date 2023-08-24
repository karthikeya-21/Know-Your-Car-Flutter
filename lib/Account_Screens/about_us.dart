import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class about_us extends StatelessWidget {
  Future<List<dynamic>> _fetchCompanyInfo() async {
    final response = await http.get(Uri.parse('https://know-your-car.onrender.com/about_us'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to load company info');
    }
  }

  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri,mode: LaunchMode.externalApplication);
    } else {
      // Handle if the URL can't be launched (e.g., show an error message)
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _fetchCompanyInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('About Us'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('About Us'),
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          final companyInfo = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text('About Us'),
            ),
            // backgroundColor: Colors.white,
            body: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Image
                    Image.asset(
                      'assets/about_us.jpeg',
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 30),

                    // Description
                    Text(
                      companyInfo[0]['description'],
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _launchURL(companyInfo[0]['portfolio']);
                      },
                      child: Text('Checkout my Portfolio'),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              // color: Color(0x2D2D2D),
              child: Container(
                height: 100,
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  children: [
                    Text(
                      'Connect Here',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            _launchURL(companyInfo[0]['facebook']);
                          },
                          icon: SvgPicture.asset(
                              'assets/icons/facebook-color-svgrepo-com.svg'),
                        ),
                        IconButton(
                          onPressed: () {
                            _launchURL(companyInfo[0]['instagram']);
                          },
                          icon: SvgPicture.asset(
                              'assets/icons/instagram-1-svgrepo-com.svg'),
                        ),
                        IconButton(
                          onPressed: () {
                            _launchURL(companyInfo[0]['github']);
                          },
                          icon: SvgPicture.asset(
                              'assets/icons/github-142-svgrepo-com.svg'),
                        ),
                        IconButton(
                          onPressed: () {
                            _launchURL(companyInfo[0]['linkedin']);
                          },
                          icon: SvgPicture.asset(
                              'assets/icons/linkedin-svgrepo-com.svg'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

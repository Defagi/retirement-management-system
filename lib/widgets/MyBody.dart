// ignore_for_file: prefer_const_constructors, unused_field, file_names, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_final_fields, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:retirement_management_system/financial/reg2.dart';
import 'package:retirement_management_system/pages/login_page.dart';

class MyBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // Set the background image here
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/assert.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 350,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to the Retirement Management System!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                    ),
                    onPressed: () {
                      // Navigate to the detailed information page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SlidePage()),
                      );
                    },
                    child: Text('View More About Our System System'),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Are you a customer or advisor?'),
                              actions: [
                                TextButton(
                                  style: ButtonStyle(
                                    textStyle: MaterialStateProperty.all<TextStyle>(
                                      TextStyle(color: Colors.black54),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => LoginPage()),
                                    );
                                  },
                                  child: Text(
                                    'Customer',
                                    style: TextStyle(
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  style: ButtonStyle(
                                    textStyle: MaterialStateProperty.all<TextStyle>(
                                      TextStyle(color: Colors.orange),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => LogiinPage()),
                                    );
                                  },
                                  child: Text(
                                    'Advisor',
                                    style: TextStyle(
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        child: Text(
                          'GET STARTED',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


class SlidePage extends StatefulWidget {
  @override
  _SlidePageState createState() => _SlidePageState();
}

class _SlidePageState extends State<SlidePage> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final List<String> pageTitles = [
    "Trust our financial advisors for reliable,investment and retirement advice with affordable price.",
    "This feature streamlines loan tracking and management by enabling input of loan details, monitoring progress, calculating repayment schedules, and maintaining organization.",
    "This tool calculates monthly investment returns and wealth gain, estimating maturity based on projected annual rates and periods.",
    "Effectively manage expenses, track spending, set budgets, analyze habits, and make informed decisions",
    "This simplifies financial goals, milestone setting, progress tracking, and adjustments.",
    "This feature aids in saving planning, and allocation of funds for a comprehensive strategy",
  ];
  final List<String> pageImages = [
    "assets/advisor_icon.jpg",
    "assets/loan_icon.jpg",
    "assets/investment_calculator_icon.png",
    "assets/expenses_icon.jpg",
    "assets/goal_icon.jpg",
    "assets/saving_icon.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('About Us'),
      // ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: pageTitles.length,
        itemBuilder: (context, index) {
          return PageTransition(
            animationType: PageTransitionType.fade, // You can use different animation types
            child: buildPage(pageTitles[index], pageImages[index]),
          );
        },
      ),
    );
  }

  Widget buildPage(String title, String imageAsset) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imageAsset),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}

// PageTransition Widget to apply transition animations
class PageTransition extends StatelessWidget {
  final Widget child;
  final PageTransitionType animationType;

  PageTransition({required this.child, required this.animationType});
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: (child, animation) {
        switch (animationType) {
          case PageTransitionType.fade:
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          case PageTransitionType.rightToLeft:
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(1.0, 0.0),
                end: Offset(0.0, 0.0),
              ).animate(animation),
              child: child,
            );
          // Add more animation types as needed
          default:
            return child;
        }
      },
      child: child,
    );
  }
}

enum PageTransitionType {
  fade,
  rightToLeft,
  // Add more animation types as needed
}

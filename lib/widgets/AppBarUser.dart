// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:retirement_management_system/pages/home.dart';
import 'package:retirement_management_system/saving/goal.dart';


class AppBarUser extends StatelessWidget {
  const AppBarUser({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
    iconTheme: IconThemeData(
    color: Colors.black, // Set the color of the menu icon to black
  ),
      title: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
      onTap: () {
                Navigator.push(
                  context,
                MaterialPageRoute(
              builder: (context) =>
                HomePage()));
      },
        child: Image.asset('assets/rms.png', height: 220,width: 100,
          ),
          ),
          const SizedBox(
            width: 4,
            height: 5
          ),
          // const Text('RETIREMENT MANAGEMENT SYSTEM'),
        ],
      ),
      centerTitle: true,
      titleSpacing: 20,
      toolbarHeight: 65,
      backgroundColor: Colors.orange,
          actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
         child: GestureDetector(
       onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GoalContributionScreen()),
    );
  },
  child: Text(
    'GOAL',
    style: TextStyle(
      color: Colors.black, // Set the text color to blue, or any color you prefer
      fontSize: 16, // Set the font size to your desired value
      // decoration: TextDecoration.underline, // Add an underline to indicate it's clickable
    ),
  ),
),
        )
      ],
    );
  }
}

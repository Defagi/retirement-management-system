// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:retirement_management_system/calculate/pensioncalculate.dart';
import 'package:retirement_management_system/expense/expense.dart';
import 'package:retirement_management_system/options/planPage.dart';
import 'package:retirement_management_system/pages/investing.dart';
import 'package:retirement_management_system/saving/loan.dart';
import 'package:retirement_management_system/saving/saving.dart';
import 'package:retirement_management_system/widgets/home.dart';
import '../pages/advisory.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
          Container(
  padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
  width: 300,
  height: 140,
  color: Colors.orange, // Replace Colors.blue with your desired background color
  child: Column(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: const [
      Text(
        "RETIREMENT MANAGEMENT SYSTEM",
        style: TextStyle(color: Colors.black, fontSize: 20),
      ),
    ],
  ),
        ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.home,
                      size: 40,
                      color: Colors.black,
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(14, 0, 0, 0),
                      child: Text.rich(TextSpan(children: [
                        TextSpan(text: "HOME",
                        recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomePageUser()));
                                      },
                                              style: TextStyle(
                            fontSize:15 , color: Colors.black),
                                      )
                      ])
                      ),
                    )
                  ],
                ),
              ),
                            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.money,
                      size: 40,
                      color: Colors.black,
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(14, 0, 0, 0),
                      child: Text.rich(TextSpan(children: [
                        TextSpan(text: "SAVINGS",
                        recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SavingsPlanManagementPage()));
                                      },
                                        style: TextStyle(
                                      fontSize:15 , color: Colors.black),
                                      )
                      ])
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.monetization_on,
                      size: 40,
                      color: Colors.black,
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(14, 0, 0, 0),
                      child: Text.rich(TextSpan(children: [
                        TextSpan(text: "EXPENSES",
                        recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ExpenseApp()));
                                      },
                                        style: TextStyle(
                                      fontSize:15 , color: Colors.black),
                                      )
                      ])
                      ),
                    )
                  ],
                ),
              ),
                           Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.monetization_on,
                      size: 40,
                      color: Colors.black,
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(14, 0, 0, 0),
                      child: Text.rich(TextSpan(children: [
                        TextSpan(text: "LOAN",
                        recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoanManagementApp()));
                                      },
                                        style: TextStyle(
                                      fontSize:15 , color: Colors.black),
                                      )
                      ])
                      ),
                    )
                  ],
                ),
              ),
                           Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.monetization_on,
                      size: 40,
                      color: Colors.black,
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(14, 0, 0, 0),
                      child: Text.rich(TextSpan(children: [
                        TextSpan(text: "GOAL",
                        recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    GoalScreen()));
                                      },
                                        style: TextStyle(
                                      fontSize:15 , color: Colors.black),
                                      )
                      ])
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.construction,
                      size: 40,
                      color: Colors.black,
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(14, 0, 0, 0),
                      child: Text.rich(TextSpan(children: [
                        TextSpan(text: "PORTFOLIO CONSTRUCTION",
                        recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MonthsServedCalculator()));
                                      },
                                            style: TextStyle(
                            fontSize:15 , color: Colors.black),
                                      )
                      ])
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.store,
                      size: 40,
                      color: Colors.black,
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(14, 0, 0, 0),
                      child: Text.rich(TextSpan(children: [
                        TextSpan(text: "INVESTING FIRMS",
                        recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    InvestmentFirmListPage()));
                                      },
                                              style: TextStyle(
                            fontSize:15 , color: Colors.black),
                                      )
                      ])
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.people,
                      size: 40,
                      color: Colors.black,
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(14.0, 0, 0, 0),
                      child: Text.rich(TextSpan(children: [
                        TextSpan(text: "ADVISOR PORTAL",
                        recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AdvisorPage()));
                                      },
                                              style: TextStyle(
                            fontSize:15 , color: Colors.black),
                                      )
                      ])
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
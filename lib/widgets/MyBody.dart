// ignore_for_file: prefer_const_constructors, file_names, prefer_const_literals_to_create_immutables, unused_import

import 'package:flutter/material.dart';
import 'package:retirement_management_system/financial/reg2.dart';
import 'package:retirement_management_system/pages/investing.dart';
import 'package:retirement_management_system/pages/login_page.dart';

class MyBody extends StatelessWidget {
  const MyBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'RETIREMENT MANAGEMENT SYSTEM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Your Tomorrow is Today',
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 45),
          // Center(
          //   child: ElevatedButton(
          //     style: ButtonStyle(
          //       backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
          //     ),
          //     onPressed: () {
          //       // Navigate to the investment options page
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => InvestmentFirmListPage()),
          //       );
          //     },
          //     child: Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Text('View The Best Investment Options'),
          //         SizedBox(width: 8), // Adjust spacing between text and image
          //         Image.asset('assets/investment_icon.jpg', height: 24, width: 24),
          //       ],
          //     ),
          //   ),
          // ),
          SizedBox(height: 45),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      'This feature aids in saving planning, and allocation of funds for a comprehensive strategy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('SAVING MANAGEMENT'),
                          SizedBox(width: 8),
                          Image.asset('assets/saving_icon.jpg', height: 24, width: 24),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Column(
                  children: [
                    Text(
                      ' Effectively manage expenses, track spending, set budgets, analyze habits, and make informed decisions.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                       color: Colors.black54,
                        fontSize: 15,
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('EXPENSES MANAGEMENT'),
                          SizedBox(width: 8),
                          Image.asset('assets/expenses_icon.jpg', height: 24, width: 24),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Column(
                  children: [
                    Text(
                      'This simplifies financial goals, milestone setting, progress tracking, and adjustments.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('GOAL MANAGEMENT'),
                          SizedBox(width: 8),
                          Image.asset('assets/goal_icon.jpg', height: 24, width: 24),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Column(
                  children: [
                    Text(
                      'This tool calculates monthly investment returns and wealth gain, estimating maturity based on projected annual rates and periods.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('INVESTMENT CALCULATOR'),
                          SizedBox(width: 8),
                          Image.asset('assets/investment_calculator_icon.png', height: 24, width: 24),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Column(
                  children: [
                    Text(
                      'This feature streamlines loan tracking and management by enabling input of loan details, monitoring progress, calculating repayment schedules, and maintaining organization.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('LOAN MANAGEMENT'),
                          SizedBox(width: 8),
                          Image.asset('assets/loan_icon.jpg', height: 24, width: 24),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Column(
                  children: [
                    Text(
                      'Trust our financial advisors for reliable,investment and retirement advice with affordable price.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('FINANCIAL ADVISORS'),
                          SizedBox(width: 8),
                          Image.asset('assets/advisor_icon.jpg', height: 24, width: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 45),
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
    );
  }
}

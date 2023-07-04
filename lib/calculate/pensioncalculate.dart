// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, use_key_in_widget_constructors, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:retirement_management_system/calculate/ape.dart';
import 'package:retirement_management_system/options/retirementplan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MonthsServedCalculator extends StatefulWidget {
  @override
  _MonthsServedCalculatorState createState() => _MonthsServedCalculatorState();
}

class _MonthsServedCalculatorState extends State<MonthsServedCalculator> {
  late int startYear;
  late int expectedRetirementYear;
  int monthsServed = 0;
  double ape = 0;
  double fullPension = 0;
  double commutedPension = 0;
  double monthlyPension = 0;
  bool isVoluntary = false;

  // Add a function to check if the user has already calculated pension details
  Future<void> checkUserPensionDetails() async {
    try {
      final users = FirebaseAuth.instance.currentUser;
      if (users != null) {
        final DocumentSnapshot documentSnapshot =
            await FirebaseFirestore.instance.collection('retirement').doc(users.uid).get();

        if (documentSnapshot.exists) {
          final data = documentSnapshot.data() as Map<String, dynamic>;
          setState(() {
            startYear = data['startYear'];
            expectedRetirementYear = data['expectedRetirementYear'];
            monthsServed = data['monthsServed'];
            ape = data['ape'];
            fullPension = data['fullPension'];
            commutedPension = data['commutedPension'];
            monthlyPension = data['monthlyPension'];
            isVoluntary = data['isVoluntary'];
          });
          print('Pension details loaded from Firebase for user: ${users.email}');
        } else {
          print('No pension details found for user: ${users.email}');
        }
      } else {
        print('User not logged in. Cannot load pension details.');
      }
    } catch (e) {
      print('Error loading pension details: $e');
    }
  }

  // Add a function to store the pension details to Firebase Firestore
  void storePensionDetails() async {
    try {
      final CollectionReference retirementCollection =
          FirebaseFirestore.instance.collection('retirement');

      final Map<String, dynamic> pensionDetails = {
        'startYear': startYear,
        'expectedRetirementYear': expectedRetirementYear,
        'monthsServed': monthsServed,
        'ape': ape,
        'fullPension': fullPension,
        'commutedPension': commutedPension,
        'monthlyPension': monthlyPension,
        'isVoluntary': isVoluntary,
        'timestamp': FieldValue.serverTimestamp(),
      };

      final users = FirebaseAuth.instance.currentUser;
      if (users != null) {
        await retirementCollection.doc(users.uid).set(pensionDetails);
        print('Pension details saved to Firebase for user: ${users.email}');
      } else {
        print('User not logged in. Pension details not saved.');
      }
    } catch (e) {
      print('Error saving pension details: $e');
    }
  }

  void calculateMonthsServed() {
    DateTime startDate = DateTime(startYear);
    DateTime retirementDate = DateTime(expectedRetirementYear);
    monthsServed = ((retirementDate.year - startDate.year) * 12) +
        (retirementDate.month - startDate.month);

    CalculateAPE apeCalculator = CalculateAPE();
    List<int> topYears = apeCalculator.findTopYearsForUsername(
        apeCalculator.filePath, apeCalculator.sheetName, apeCalculator.nameColumn, 'CurrentUsername', 3);
    ape = apeCalculator.calculateAPEForYears(apeCalculator.filePath, apeCalculator.sheetName, topYears);

    setState(() {});
  }

  void calculatePensions() {
    if (monthsServed < 180) {
      monthlyPension = (1 / 580) * monthsServed * ape * (1 / 12) * 0.67;
      commutedPension = 0;
      fullPension = 0;
    } else {
      if (isVoluntary) {
        commutedPension =
            (1 / 580) * monthsServed * ape * 12.5 * 0.33; // Voluntary retirement when the age is 55
        fullPension = 0;
        monthlyPension = 0;
      } else {
        commutedPension = 0;
        fullPension = (1 / 580) * monthsServed * ape; // 60
      }
      setState(() {});
    }
  }
  @override
  void initState() {
    super.initState();
    checkUserPensionDetails(); // Load pension details when the widget is created
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Know Your Pension'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Start Year of Employment',
              ),
              onChanged: (value) {
                setState(() {
                  startYear = int.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Expected Year of Retirement',
              ),
              onChanged: (value) {
                setState(() {
                  expectedRetirementYear = int.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Retirement Type:'),
                SizedBox(width: 10),
                DropdownButton<bool>(
                  value: isVoluntary,
                  items: [
                    DropdownMenuItem<bool>(
                      value: false,
                      child: Text('Compulsory'),
                    ),
                    DropdownMenuItem<bool>(
                      value: true,
                      child: Text('Voluntary'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      isVoluntary = value ?? false;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
              ),
              onPressed: () {
                calculateMonthsServed();
                calculatePensions();
                storePensionDetails();
              },
              child: Text(
                'Calculate',
              ),
            ),
            SizedBox(height: 40),
            DataTable(
              columns: [
                DataColumn(label: Text('Pension Type')),
                DataColumn(label: Text('Value')),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text('Number of Months Served')),
                  DataCell(Text('$monthsServed')),
                ]),
                DataRow(cells: [
                  DataCell(Text('Full Pension (Tshs)')),
                  DataCell(Text('$fullPension')),
                ]),
                DataRow(cells: [
                  DataCell(Text('Commuted Pension (Tshs)')),
                  DataCell(Text('$commutedPension')),
                ]),
                DataRow(cells: [
                  DataCell(Text('Monthly Pension (Tshs)')),
                  DataCell(Text('$monthlyPension')),
                ]),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
              ),
              onPressed: () {
                // Navigate to the investment options page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RetirementPlanPage(),
                  ),
                );
              },
              child: Text('Explore The Best Investment Options'),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SavingsPlanManagementPage extends StatefulWidget {
  const SavingsPlanManagementPage({Key? key}) : super(key: key);

  @override
  _SavingsPlanManagementPageState createState() =>
      _SavingsPlanManagementPageState();
}

class _SavingsPlanManagementPageState extends State<SavingsPlanManagementPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController goalController = TextEditingController();
  TextEditingController monthlyContributionController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  double totalSavings = 0.0;
  double advisedMonthlyContribution = 0.0;
  int suggestedDuration = 0;

  @override
  void dispose() {
    goalController.dispose();
    monthlyContributionController.dispose();
    durationController.dispose();
    super.dispose();
  }

  void calculateTotalSavings() async {
    double goalAmount = double.tryParse(goalController.text) ?? 0.0;
    double monthlyContribution =
        double.tryParse(monthlyContributionController.text) ?? 0.0;
    int duration = int.tryParse(durationController.text) ?? 0;

    double total = monthlyContribution * duration;
    double remainingAmount = goalAmount - total;

    if (remainingAmount <= 0) {
      // Goal already met
      setState(() {
        totalSavings = total;
        advisedMonthlyContribution = 0.0;
        suggestedDuration = 0;
      });
    } else {
      double requiredMonthlyContribution = remainingAmount / duration;

      double maxSavings = 0.0;
      int maxDuration = 0;
      for (int i = 1; i <= duration; i++) {
        double currentTotal = monthlyContribution * i;
        if (currentTotal > maxSavings) {
          maxSavings = currentTotal;
          maxDuration = i;
        }
      }
      setState(() {
        totalSavings = total;
        advisedMonthlyContribution = requiredMonthlyContribution;
        suggestedDuration = maxDuration;
      });

      // Save the savings plan details to Firestore for the specific user
      try {
        final User? user = _auth.currentUser;
        if (user != null) {
          final userId = user.uid;
          final userDocRef = _firestore.collection('users').doc(userId);

          await userDocRef.set({
            'goalAmount': goalAmount,
            'monthlyContribution': monthlyContribution,
            'duration': duration,
            'totalSavings': totalSavings,
            'advisedMonthlyContribution': advisedMonthlyContribution,
            'suggestedDuration': suggestedDuration,
          });

          // Add a subcollection 'savings' under the user's document
          final savingsCollectionRef = userDocRef.collection('savings');
          await savingsCollectionRef.add({
            'date': Timestamp.now(), // You can store the date of the savings transaction
            'amount': totalSavings, // You can store the total savings amount
          });

          print('Savings plan details saved to Firestore.');
        }
      } catch (e) {
        print('Error saving savings plan details: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Savings Plan Management'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Manage your savings plan',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: goalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Goal Amount (Tshs)',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: monthlyContributionController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Monthly Contribution (Tshs)',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Duration (in months)',
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.orange,
                  ),
                ),
                onPressed: calculateTotalSavings,
                child: Text(
                  'Calculate Total Savings',
                  style: TextStyle(),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Total Savings:',
              style: TextStyle(fontSize: 18.0, color: Colors.black54),
            ),
            Text(
              totalSavings.toStringAsFixed(2),
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            if (advisedMonthlyContribution > 0)
              Text(
                'To meet your goal amount, add ${advisedMonthlyContribution.toStringAsFixed(2)} Tshs per month.',
                style: TextStyle(fontSize: 18.0, color: Colors.black45),
              ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:retirement_management_system/options/planPage.dart';



class RetirementPlanPage extends StatefulWidget {
  @override
  _RetirementPlanPageState createState() => _RetirementPlanPageState();
}

class _RetirementPlanPageState extends State<RetirementPlanPage> {
  late int currentAge;
  late int desiredRetirementAge;
  late double income;
  late double expectedMonthlyExpenses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Retirement Plan'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your Retirement Plan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(labelText: 'Current Age'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  currentAge = int.parse(value);
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Desired Retirement Age'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  desiredRetirementAge = int.parse(value);
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Income'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  income = double.parse(value);
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Expected Monthly Expenses'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  expectedMonthlyExpenses = double.parse(value);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                ),
                onPressed: () {
                  final retirementPlan = RetirementPlan(
                    currentAge: currentAge,
                    desiredRetirementAge: desiredRetirementAge,
                    income: income,
                    expectedMonthlyExpenses: expectedMonthlyExpenses,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RetirementPlanResultPage(
                        retirementPlan: retirementPlan,
                      ),
                    ),
                  );
                },
                child: Text('Calculate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class RetirementPlan {
  final int currentAge;
  final int desiredRetirementAge;
  final double income;
  final double expectedMonthlyExpenses;
  RetirementPlan({
    required this.currentAge,
    required this.desiredRetirementAge,
    required this.income,
    required this.expectedMonthlyExpenses,
  });
}
class RetirementPlanResultPage extends StatefulWidget {
  final RetirementPlan retirementPlan;

  RetirementPlanResultPage({required this.retirementPlan});

  @override
  _RetirementPlanResultPageState createState() => _RetirementPlanResultPageState();
}

class _RetirementPlanResultPageState extends State<RetirementPlanResultPage> {
  late int remainingYears;
  late double remainingAmount;
  late double monthlyRemainder;
  late double retirementAmount;
  @override
  void initState() {
    super.initState();
    calculateRemainingYearsAndAmount();
    calculateMonthlyRemainder();
    calculateRetirementAmount();
  }
  void calculateRemainingYearsAndAmount() {
    double monthlyExpenses = widget.retirementPlan.expectedMonthlyExpenses;
    double remainingIncome = widget.retirementPlan.income - monthlyExpenses;

    if (remainingIncome <= 0) {
      remainingYears = 0;
      remainingAmount = 0;
    } else {
      remainingYears = widget.retirementPlan.desiredRetirementAge - widget.retirementPlan.currentAge;
      remainingAmount = remainingIncome * remainingYears * 12;
    }
  }
  void calculateMonthlyRemainder() {
    monthlyRemainder =  widget.retirementPlan.income - widget.retirementPlan.expectedMonthlyExpenses;
  }
  void calculateRetirementAmount() {
    retirementAmount = widget.retirementPlan.income * 12 * remainingYears - (widget.retirementPlan.expectedMonthlyExpenses * 12 * remainingYears);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Retirement Plan Result'),
      ),
        body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Retirement Plan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Remaining Years until Retirement: $remainingYears',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Monthly Amount Remaining: \$${monthlyRemainder.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Retirement Amount: \$${retirementAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
                        SizedBox(height: 40),
                     ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.orange),
              ),
              onPressed: () {
                // Navigate to the investment options page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GoalScreen()),
                );
              },
              child: Text('Creat your Plan'),
            ),
          ],
        ),
      ),
        )
    );
  }
}

// ignore_for_file: unused_import, library_private_types_in_public_api, prefer_const_constructors, use_key_in_widget_constructors, prefer_final_fields, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:retirement_management_system/options/planPage.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart'; // Import the fl_chart library

class GoalData {
  final String id;
  final String userId;
  final String goal;
  double progressAmount;
  final double targetAmount;
  DateTime? completionTime;
  bool reached;

  GoalData({
    required this.id,
    required this.userId,
    required this.goal,
    required this.progressAmount,
    required this.targetAmount,
    this.completionTime,
    this.reached = false,
  });

  GoalData.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        userId = snapshot.data()!['userId'],
        goal = snapshot.data()!['goalName'],
        progressAmount = snapshot.data()!['progressAmount'],
        targetAmount = snapshot.data()!['targetAmount'],
        completionTime = snapshot.data()!['completionTime'] != null
            ? (snapshot.data()!['completionTime'] as Timestamp).toDate()
            : null,
        reached = snapshot.data()!['reached'] ?? false;
}

class GoalContributionScreen extends StatefulWidget {
  @override
  _GoalContributionScreenState createState() => _GoalContributionScreenState();
}

class _GoalContributionScreenState extends State<GoalContributionScreen> {
  final List<GoalData> goals = [];
  TextEditingController _contributionController = TextEditingController();
  GoalData? _selectedGoal;

  @override
  void dispose() {
    _contributionController.dispose();
    super.dispose();
  }

  Future<void> _viewGoals() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('goals')
              .where('userId', isEqualTo: user.uid)
              .get();
      List<GoalData> userGoals = querySnapshot.docs
          .map((doc) => GoalData.fromSnapshot(doc))
          .toList();
      setState(() {
        goals.clear();
        goals.addAll(userGoals);
      });
    }
  }

  Future<void> _updateGoal(GoalData goal) async {
    await FirebaseFirestore.instance.collection('goals').doc(goal.id).update({
      'progressAmount': goal.progressAmount,
      'completionTime': goal.completionTime,
      'reached': goal.reached,
    });
  }

  Future<void> _addContribution() async {
    if (_selectedGoal == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please select a goal to add contribution.'),
          actions: <Widget>[
            TextButton(
                 style: ElevatedButton.styleFrom(
               backgroundColor: Colors.orange,
                ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    double contribution = double.tryParse(_contributionController.text) ?? 0;
    if (contribution <= 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Invalid contribution amount. Please enter a valid number greater than 0.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _selectedGoal!.progressAmount += contribution;
      if (_selectedGoal!.progressAmount >= _selectedGoal!.targetAmount) {
        _selectedGoal!.progressAmount = _selectedGoal!.targetAmount;
        _selectedGoal!.reached = true;
        _selectedGoal!.completionTime = DateTime.now();
      }
      _updateGoal(_selectedGoal!);
    });

    _contributionController.clear();
  }

  // Function to generate data for the pie chart
  List<PieChartSectionData> getGoalChartData() {
    List<PieChartSectionData> sections = [];
    for (var goal in goals) {
      if (goal.reached) {
        sections.add(
          PieChartSectionData(
            title: goal.goal,
            value: goal.targetAmount,
            color: Colors.green,
          ),
        );
      } else {
        sections.add(
          PieChartSectionData(
            title: goal.goal,
            value: goal.progressAmount,
            color: Colors.blue,
          ),
        );
      }
    }
    return sections;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Goal Progress'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Select Goal Dropdown
            Text('Select a goal to add contribution:'),
            DropdownButton<GoalData>(
              value: _selectedGoal,
              onChanged: (GoalData? newValue) {
                setState(() {
                  _selectedGoal = newValue;
                });
              },
              items: goals.map<DropdownMenuItem<GoalData>>((GoalData goal) {
                return DropdownMenuItem<GoalData>(
                  value: goal,
                  child: Text(goal.goal),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            // Contribution Input
            Text('Enter contribution amount:'),
            TextField(
              controller: _contributionController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter contribution',
              ),
            ),
            SizedBox(height: 20),
            // Add Contribution Button
            ElevatedButton(
              onPressed: _addContribution,
              child: Text('Add Contribution'),
            ),
            SizedBox(height: 20),
            // Display the pie chart
            AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  sections: getGoalChartData(),
                  // You can customize other chart properties here if needed
                ),
              ),
            ),
            SizedBox(height: 20),
            // Display other goal-related information here
            Text('Total Goals: ${goals.length}'),
            // You can display other goal-related data as needed
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _viewGoals,
        child: Icon(Icons.refresh),
        backgroundColor: Colors.orange,
      ),
    );
  }
}

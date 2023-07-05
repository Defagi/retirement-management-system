// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, unused_local_variable, use_build_context_synchronously, use_key_in_widget_constructors, file_names

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoalData {
  final String goal;
  final double targetAmount;
  final double progressAmount;
  final DateTime completionTime;
  final DateTime deadline;
  bool reached; // Added boolean field to track if the goal has been reached

  GoalData(this.goal, this.targetAmount, this.progressAmount, this.completionTime, this.deadline,
      {this.reached = false});

  static fromSnapshot(QueryDocumentSnapshot<Object?> doc) {}
}

class GoalScreen extends StatefulWidget {
  @override
  _GoalScreenState createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  final List<GoalData> goals = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _targetAmountController = TextEditingController();
  final TextEditingController _progressAmountController =
  TextEditingController();
  late DateTime _completionTime = DateTime.now();
  late DateTime _deadline = DateTime.now();

  void _addGoal() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final goal = _goalController.text;
    final targetAmount = double.parse(_targetAmountController.text);
    final progressAmount = double.parse(_progressAmountController.text);

    // Check if the goal already exists
    if (goals.any((existingGoal) => existingGoal.goal == goal)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Goal Already Exists'),
            content: Text('The goal "$goal" is already available.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('goals')
          .add({
        'goal': goal,
        'targetAmount': targetAmount,
        'progressAmount': progressAmount,
        'completionTime': _completionTime,
        'deadline': _deadline,
        'reached': false,
      });
    }

    setState(() {
      goals.add(GoalData(goal, targetAmount,progressAmount, _completionTime, _deadline));
      _goalController.clear();
      _targetAmountController.clear();
      _progressAmountController.clear();
      _completionTime = DateTime.now();
      _deadline = DateTime.now();
    });
  }

  void _viewGoals() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('goals')
          .get();
      final goalList = snapshot.docs
          .map((doc) => GoalData(
                doc['goal'],
                doc['targetAmount'],
                doc['progressAmount'],
                doc['completionTime'].toDate(),
                doc['deadline'].toDate(),
                reached: doc['reached'],
              ))
          .toList();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Goals'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: goalList.map((goal) => _buildGoalCard(goal)).toList(),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Goal Tracker'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _goalController,
                    decoration: InputDecoration(labelText: 'Goal'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a goal.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _targetAmountController,
                    keyboardType: TextInputType.number,
                    decoration:
                        InputDecoration(labelText: 'Target Amount (Tshs)'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a target amount.';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid target amount.';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 10),
                  Text('Completion Time: ${_completionTime.toString()}'),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.orange),
                    ),
                    onPressed: () async {
                      final selectedTime = await showDatePicker(
                        context: context,
                        initialDate: _completionTime,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (selectedTime != null) {
                        setState(() {
                          _completionTime = selectedTime;
                        });
                      }
                    },
                    child: Text('Select Completion Time'),
                  ),
                  SizedBox(height: 16),
                  Text('Deadline: ${_deadline.toString()}'),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.orange),
                    ),
                    onPressed: () async {
                      final selectedTime = await showDatePicker(
                        context: context,
                        initialDate: _deadline,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (selectedTime != null) {
                        setState(() {
                          _deadline = selectedTime;
                        });
                      }
                    },
                    child: Text('Select Deadline'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.orange),
                    ),
                    onPressed: _addGoal,
                    child: Text('Add Goal'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Goals',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            if (goals.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text('Goal'),
                    ),
                    DataColumn(
                      label: Text('Target Amount'),
                    ),
                    // DataColumn(
                    //   label: Text('Progress Amount'),
                    // ),
                    DataColumn(
                      label: Text('Completion Time'),
                    ),
                    DataColumn(
                      label: Text('Deadline'),
                    ),
                    DataColumn(
                      label: Text('Reached'),
                    ),
                  ],
                  rows: goals.map((goal) {
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(Text(goal.goal)),
                        DataCell(Text(goal.targetAmount.toString())),
                        // DataCell(Text(goal.progressAmount.toString())),
                        DataCell(Text(goal.completionTime.toString())),
                        DataCell(Text(goal.deadline.toString())),
                        DataCell(
                          Checkbox(
                            value: goal.reached,
                            onChanged: (value) {
                              setState(() {
                                goal.reached = value!;
                              });
                              _updateGoal(goal);
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            if (goals.isEmpty) Text('No goals added yet.'),
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.orange),
              ),
              onPressed: _viewGoals,
              child: Text('View Goals'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard(GoalData goal) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Goal: ${goal.goal}'),
            Text('Target Amount: ${goal.targetAmount} Tshs'),
            // Text('Progress Amount: ${goal.progressAmount} Tshs'),
            Text('Completion Time: ${goal.completionTime}'),
            Text('Deadline: ${goal.deadline}'),
            Text('Reached: ${goal.reached ? "Yes" : "No"}'),
          ],
        ),
      ),
    );
  }

  void _updateGoal(GoalData goal) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final goalRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('goals')
          .doc(goal.goal);
      await goalRef.update({
        'reached': goal.reached,
      });
    }
  }
}

// ignore_for_file: unused_local_variable, prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_auth/firebase_auth.dart';

class ExpenseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Management',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: ExpenseHomePage(),
    );
  }
}

class ExpenseHomePage extends StatefulWidget {
  @override
  _ExpenseHomePageState createState() => _ExpenseHomePageState();
}

class _ExpenseHomePageState extends State<ExpenseHomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  String? _getUserUID() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  void _addExpense() {
    final title = _titleController.text;
    final amount = double.tryParse(_amountController.text);

    if (title.isNotEmpty && amount != null && amount > 0) {
      final now = DateTime.now();
      final month = DateFormat('MMMM yyyy').format(now);

      final uid = _getUserUID();
      if (uid != null) {
        _firestore.collection('users').doc(uid).collection('expenses').add({
          'title': title,
          'amount': amount,
          'date': now,
          'month': month,
        });
      }

      _titleController.clear();
      _amountController.clear();
    }
  }

  void _removeExpense(String expenseId) {
    final uid = _getUserUID();
    if (uid != null) {
      _firestore.collection('users').doc(uid).collection('expenses').doc(expenseId).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Expense Management'),
      ),
      body: Column(
        children: [
          ExpenseForm(
            titleController: _titleController,
            amountController: _amountController,
            addExpense: _addExpense,
          ),
          Expanded(
            child: ExpenseList(
              firestore: _firestore,
              removeExpense: _removeExpense,
              userUID: _getUserUID(),
            ),
          ),
          TotalExpense(firestore: _firestore, userUID: _getUserUID()),
          ElevatedButton(
            child: Text('View Weekly Report'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WeeklyExpensePage(firestore: _firestore, userUID: _getUserUID()),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ExpenseForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController amountController;
  final Function addExpense;

  ExpenseForm({
    required this.titleController,
    required this.amountController,
    required this.addExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 3.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Amount'),
              ),
              ElevatedButton(
                onPressed: () => addExpense(),
                child: Text('Add Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpenseList extends StatelessWidget {
  final FirebaseFirestore firestore;
  final Function removeExpense;
  final String? userUID;

  ExpenseList({required this.firestore, required this.removeExpense, required this.userUID});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('users').doc(userUID).collection('expenses').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final expenseDocs = snapshot.data?.docs ?? [];

        return ListView.builder(
          itemCount: expenseDocs.length,
          itemBuilder: (context, index) {
            final doc = expenseDocs[index];
            final expenseId = doc.id;
            final title = doc['title'];
            final amount = doc['amount'];
            final date = (doc['date'] as Timestamp).toDate();

            return Card(
              child: ListTile(
                title: Text(title),
                subtitle: Text('Amount: \$${amount.toStringAsFixed(2)}'),
                trailing: Text(DateFormat('MMM d, y').format(date)),
                onLongPress: () => removeExpense(expenseId),
              ),
            );
          },
        );
      },
    );
  }
}

class TotalExpense extends StatelessWidget {
  final FirebaseFirestore firestore;
  final String? userUID;

  TotalExpense({required this.firestore, required this.userUID});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('users').doc(userUID).collection('expenses').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        final expenseDocs = snapshot.data?.docs ?? [];
        double totalExpense = 0;

        for (final doc in expenseDocs) {
          final amount = doc['amount'] as double;
          totalExpense += amount;
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Total Expense: \$${totalExpense.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}

class WeeklyExpensePage extends StatelessWidget {
  final FirebaseFirestore firestore;
  final String? userUID;

  WeeklyExpensePage({required this.firestore, required this.userUID});

  List<ExpenseData> _getWeeklyExpenseData(List<QueryDocumentSnapshot> expenseDocs) {
    final Map<String, double> weeklyExpenseMap = {};

    for (final doc in expenseDocs) {
      final amount = doc['amount'] as double;
      final date = (doc['date'] as Timestamp).toDate();
      final weekNumber = DateFormat('ww').format(date);
      final weekStartDate = DateTime.parse('${DateFormat('y-MM-dd').format(date)} 00:00:00');
      final weekEndDate = weekStartDate.add(Duration(days: 7));

      if (weekStartDate.isBefore(DateTime.now())) {
        final weekRange = '${DateFormat('MMM d').format(weekStartDate)} - ${DateFormat('MMM d').format(weekEndDate)}';
        if (weeklyExpenseMap.containsKey(weekRange)) {
          weeklyExpenseMap[weekRange] = weeklyExpenseMap[weekRange]! + amount;
        } else {
          weeklyExpenseMap[weekRange] = amount;
        }
      }
    }

    final List<ExpenseData> weeklyData = [];

    weeklyExpenseMap.forEach((weekRange, amount) {
      weeklyData.add(ExpenseData(weekRange, amount));
    });

    return weeklyData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weekly Expense Report'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('users').doc(userUID).collection('expenses').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final expenseDocs = snapshot.data?.docs ?? [];
          final weeklyData = _getWeeklyExpenseData(expenseDocs);

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: charts.BarChart(
              [
                charts.Series<ExpenseData, String>(
                  id: 'WeeklyExpense',
                  colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
                  domainFn: (ExpenseData expenseData, _) => expenseData.weekRange,
                  measureFn: (ExpenseData expenseData, _) => expenseData.amount,
                  data: weeklyData,
                ),
              ],
              animate: true,
              vertical: false,
              behaviors: [charts.ChartTitle('Week Range', behaviorPosition: charts.BehaviorPosition.bottom, titleOutsideJustification: charts.OutsideJustification.middleDrawArea), charts.ChartTitle('Amount (\$)', behaviorPosition: charts.BehaviorPosition.start, titleOutsideJustification: charts.OutsideJustification.middleDrawArea)],
            ),
          );
        },
      ),
    );
  }
}

class ExpenseData {
  final String weekRange;
  final double amount;

  ExpenseData(this.weekRange, this.amount);
}



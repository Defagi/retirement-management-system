// ignore_for_file: prefer_const_constructors, unused_local_variable, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retirement_management_system/data/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyBodyUser extends StatelessWidget {
  const MyBodyUser({Key? key}) : super(key: key);

  String? _getUserUID() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }
  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      // Replace 'users' with the collection name where user data is stored
      stream: FirebaseFirestore.instance.collection('users').doc(_getUserUID()).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userData = snapshot.data!.data();

          // If userData is null or empty, you can display a loading/error message
          if (userData == null || userData.isEmpty) {
            return Center(
              child: Text('No data found.'),
            );
          }

          return SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Display fetched data here
                        Text("Loan Information: ${userData['loanInformation'] ?? 'N/A'}"),
                        Text("Expense Information: ${userData['expenseInformation'] ?? 'N/A'}"),
                        Text("Saving Information: ${userData['savingInformation'] ?? 'N/A'}"),
                        Text("Goals Information: ${userData['goalInformation'] ?? 'N/A'}"),
                        Text("Retirement Information: ${userData['retirementInformation'] ?? 'N/A'}"),
                        Text("Appointment Information: ${userData['appointmentInformation'] ?? 'N/A'}"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          // Display a loading spinner or some other indicator while data is loading
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

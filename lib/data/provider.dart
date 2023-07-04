// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retirement_management_system/data/models.dart';

class UserDataProvider extends ChangeNotifier {
  UserData? _userData;

  UserData? get userData => _userData;

  Future<void> fetchUserData(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;

        _userData = UserData(
          loanInformation: data['loans'],
          expenseInformation: data['expenses'],
          savingInformation: data['savings'],
           goalInformation: data['goals'],
          retirementInformation: data['retirement'],
          appointmentInformation: data['appointments'],
        );

        notifyListeners();
      }
    } catch (e) {
      // Handle any errors while fetching data
      print('Error fetching user data: $e');
    }
  }
}

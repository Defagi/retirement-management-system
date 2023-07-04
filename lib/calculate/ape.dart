// ignore_for_file: avoid_print

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';

class CalculateAPE {
  final String filePath =
      'C:\\Users\\SASHA\\Documents\\GitHub\\retirement-management-system\\retirementdata.xlsx';
  final String sheetName = 'retirementdata';
  final int yearColumnIndex = 0; // Replace '0' with the actual column index where the years are located
  final int valueColumnIndex = 1; // Replace '1' with the actual column index where the values are located
  final String nameColumn = 'Name';
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  Future<void> processAPECalculation() async {
    if (_formKey.currentState!.validate()) {
      try {
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();
        final users = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (users.user != null) {
          String currentUsername = users.user!.email ?? '';

          bool validUsername =
              isUsernameValid(filePath, sheetName, nameColumn, currentUsername);

          if (validUsername) {
            final List<int> topYears = findTopYearsForUsername(
                filePath, sheetName, nameColumn, currentUsername, 3);
            final double ape =
                calculateAPEForYears(filePath, sheetName, topYears);

            print('Username: $currentUsername');
            print('The top 3 years with the highest contributions are: $topYears');
            print('APE (Average of three years\' contributions with the highest values): $ape');
          } else {
            print('Valid username not found. No access granted.');
          }
        } else {
          print('User login failed.');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  bool isUsernameValid(
      String filePath, String sheetName, String nameColumn, String username) {
    final bytes = File(filePath).readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);

    final sheet = excel.tables[sheetName]; // Access the table directly

    final headersRow = sheet!.rows[0];
    int nameIndex = headersRow.indexWhere((cell) => cell?.value == nameColumn);
    if (nameIndex == -1) {
      print('Column $nameColumn not found in the Excel sheet.');
      return false;
    }
    for (var row in sheet.rows) {
      final name = row[nameIndex]?.value;
      if (name == username) {
        return true;
      }
    }
    return false;
  }

  double calculateAPEForYears(
      String filePath, String sheetName, List<int> years) {
    final bytes = File(filePath).readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);
    final sheet = excel.tables[sheetName]; // Access the table directly
    double totalValue = 0;
    for (var row in sheet!.rows) {
      final year = row[yearColumnIndex]?.value;
      final value = row[valueColumnIndex]?.value;
      if (year != null && value != null && years.contains(year)) {
        totalValue += value;
      }
    }
    return totalValue / years.length;
  }

  List<int> findTopYearsForUsername(
      String filePath, String sheetName, String nameColumn, String username, int numYears) {
    final bytes = File(filePath).readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);
    final sheet = excel.tables[sheetName]; // Access the table directly
    final Map<int, double> yearsMap = {};
    final headersRow = sheet!.rows[0];
    int nameIndex = headersRow.indexWhere((cell) => cell?.value == nameColumn);
    if (nameIndex == -1) {
      print('Column $nameColumn not found in the Excel sheet.');
      return [];
    }
    for (var row in sheet.rows) {
      final name = row[nameIndex]?.value;
      if (name == username) {
        final year = row[yearColumnIndex]?.value;
        final value = row[valueColumnIndex]?.value;
        if (year != null && value != null) {
          yearsMap[year] = value;
        }
      }
    }
    final sortedYears = yearsMap.keys.toList()
      ..sort((a, b) => yearsMap[b]!.compareTo(yearsMap[a]!));

    return sortedYears.take(numYears).toList();
  }
}



// ignore_for_file: prefer_const_constructors, unused_element, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdvisorWelcomePage extends StatefulWidget {
  const AdvisorWelcomePage({Key? key}) : super(key: key);

  @override
  _AdvisorWelcomePageState createState() => _AdvisorWelcomePageState();
}

class _AdvisorWelcomePageState extends State<AdvisorWelcomePage> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String advisorName = '';
  late String advisorEmail;

  Future<void> getUserData(String userUid) async {
    final advisorSnapshot = await _firestore.collection('advisors').doc(userUid).get();
    if (advisorSnapshot.exists) {
      final advisorData = advisorSnapshot.data();
      setState(() {
        advisorName = advisorData?['firstName'] ?? '';
        advisorEmail = advisorData?['email'] ?? '';
      });
    }
  }

  Widget _buildAdvisorImage(String imageUrl) {
    if (imageUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(imageUrl),
      );
    } else {
      return CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey,
        child: Icon(
          Icons.person,
          color: Colors.white,
          size: 40,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (advisorName.isEmpty || advisorEmail.isEmpty) {
      // Show loading indicator
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      // Show the welcome page content
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text('Congratulations, $advisorName!'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // _buildAdvisorImage(advisorData?['imageUrl'] ?? ''),
            SizedBox(height: 20),
             Image.asset('assets/welcome_image.png'),
            Text(
              'Now wait for a client',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(advisorEmail),
          ],
        ),
      );
    }
  }
}

// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, avoid_print, unused_local_variable

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:retirement_management_system/financial/advisorstate.dart';

class AdvisorPage extends StatefulWidget {
  const AdvisorPage({Key? key});
  @override
  State<AdvisorPage> createState() => _AdvisorPageState();
}

class _AdvisorPageState extends State<AdvisorPage> {


  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Widget _buildAdvisorImage(String imageUrl) {
    if (imageUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(imageUrl),
      );
    } else {
      return CircleAvatar(
        radius: 30,
        backgroundColor: Colors.grey,
        child: Icon(
          Icons.person,
          color: Colors.white,
          size: 40,
        ),
      );
    }
  }

  Future<void> recordAppointment(String advisorId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final userId = currentUser.uid;

        final appointmentData = {
          'userName': userId,
          'advisorId': advisorId,
          'appointmentTime': DateTime.now(),
        };

        await _firestore.collection('appointments').add(appointmentData);

        print('Appointment recorded successfully!');
      }
    } catch (e) {
      print('Failed to record appointment: $e');
    }
  }

  void navigateToAppointmentRecordsPage(String advisorId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentRecordsPage(advisorId: advisorId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('ADVISORS'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('advisors').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot> advisors = snapshot.data!.docs;
            int numberOfAdvisors = advisors.length;
            return ListView.builder(
              itemCount: numberOfAdvisors,
              itemBuilder: (context, index) {
                Map<String, dynamic>? advisorData = advisors[index].data() as Map<String, dynamic>?;
                String advisorName = advisorData?['firstName'] ?? '';
                String advisorname = advisorData?['lastName'] ?? '';
                String advisorEmail = advisorData?['email'] ?? '';
                String advisorNumber = advisorData?['phoneNumber'] ?? '';
                String advisorExperience = advisorData?['experience'] ?? '';
                String advisorCertificate = advisorData?['certification'] ?? '';
                String advisorExpertise = advisorData?['expertise'] ?? '';
                return ListTile(
                  leading: _buildAdvisorImage(advisorData?['image'] ?? ''),
                  title: Text(advisorName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(advisorname),
                      Text(advisorEmail),
                      Text(advisorNumber),
                      Text(advisorExperience),
                      Text(advisorCertificate),
                      Text(advisorExpertise),
                    ],
                  ),
                  trailing: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                      minimumSize: MaterialStateProperty.all<Size>(Size(100, 30)),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Appointment Made'),
                            content: Text('Financial Advisor will check you soon.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  recordAppointment(advisorData?['advisorId']);
                                  navigateToAppointmentRecordsPage(advisorData?['advisorId']);
                                },
                                child: Text(
                                  'Ok',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      'Make Appointment',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

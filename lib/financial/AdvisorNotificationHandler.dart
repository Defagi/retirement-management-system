// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, file_names, unnecessary_cast, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentRecordsPage extends StatefulWidget {
  final String advisorId;

  const AppointmentRecordsPage({required this.advisorId});

  @override
  State<AppointmentRecordsPage> createState() => _AppointmentRecordsPageState();
}

class _AppointmentRecordsPageState extends State<AppointmentRecordsPage> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController communicationController = TextEditingController();

  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    communicationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Appointment Records'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('advisorId', isEqualTo: widget.advisorId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error.toString()}'),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Process snapshot data
          final appointmentDocs = snapshot.data!.docs;
          final appointments =
              appointmentDocs.map((doc) => doc.data()).toList();

          if (appointments.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/waiting.png', height: 150),
                  Text('Don\'t worry, just wait a little and you will get a client!'),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index] as Map<String, dynamic>;

              return ListTile(
                title: Text('User: ${appointment['userName']}'),
                subtitle: Text('Time: ${appointment['appointmentTime'].toDate().toString()}'),
                // Add additional appointment details as needed
                trailing: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Verify Appointment'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Do you want to verify this appointment?'),
                              TextFormField(
                                controller: dateController,
                                decoration: InputDecoration(labelText: 'Date'),
                              ),
                              TextFormField(
                                controller: timeController,
                                decoration: InputDecoration(labelText: 'Time'),
                              ),
                              TextFormField(
                                controller: communicationController,
                                decoration: InputDecoration(labelText: 'Means of Communication'),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Perform verification action here
                                final verificationData = {
                                  'date': dateController.text,
                                  'time': timeController.text,
                                  'communication': communicationController.text,
                                };
                                _saveVerificationData(verificationData);
                                Navigator.of(context).pop();
                              },
                              child: Text('Yes'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('No'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    'Verify Appointment',
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
        },
      ),
    );
  }

  void _saveVerificationData(Map<String, dynamic> data) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userId = currentUser.uid;
        await FirebaseFirestore.instance
            .collection('appointments')
            .doc(userId)
            .update(data);

        print('Appointment verification data saved successfully!');
      }
    } catch (e) {
      print('Failed to save appointment verification data: $e');
    }
  }
}

// ignore_for_file: prefer_const_constructors, sort_child_properties_last, unused_import, use_key_in_widget_constructors, prefer_final_fields, avoid_print, use_build_context_synchronously, prefer_is_not_empty

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:retirement_management_system/common/theme_helper.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:retirement_management_system/pages/reg2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:retirement_management_system/widgets/home.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _firstnamecontroller = TextEditingController();
  TextEditingController _lastnamecontroller = TextEditingController();
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _phonenumbercontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  bool _checkedValue = false;
  bool _isPasswordVisible = false;

  Future<bool> isEmailAlreadyUsed(String email) async {
    final snapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }
  Future<void> sendWelcomeEmail(String email) async {
     final smtpServer = gmail("edwardsasha27@gmail.com", "ngegeshi2000");

    final message = Message()
     ..from = Address("edwardsasha27@gmail.com", "RetirementManagementSystem")
      ..recipients.add(email)
      ..subject = "Welcome to the System"
      ..text = "Welcome to use the system! Thank you for signing up.";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.toString()}');
    } on MailerException catch (e) {
      print('Message not sent. ${e.message}');
    }
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
        title: Text("Register here"),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(children: [
                Form(
                  key: _formKey,
                  child: Column(children: [
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: TextFormField(
                        controller: _firstnamecontroller,
                        decoration: ThemeHelper().textInputDecoration(
                            'First Name', 'Enter your first name'),
                      ),
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: TextFormField(
                        controller: _lastnamecontroller,
                        decoration: ThemeHelper().textInputDecoration(
                            'Last Name', 'Enter your last name'),
                      ),
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      child: TextFormField(
                        controller: _emailcontroller,
                        decoration: ThemeHelper().textInputDecoration(
                            "E-mail address", "Enter your email"),
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (!(val!.isEmpty) &&
                              !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$")
                                  .hasMatch(val)) {
                            return 'Please enter a valid email address';
                          } else {
                            return null;
                          }
                        },
                      ),
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      child: TextFormField(
                        controller: _phonenumbercontroller,
                        decoration: ThemeHelper().textInputDecoration(
                            "Phone Number", "Enter your phone number"),
                        keyboardType: TextInputType.phone,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please enter your phone number";
                          } else if (!RegExp(r"^\+?[0-9]{10,12}$")
                              .hasMatch(val)) {
                            return "Please enter a valid phone number";
                          } else {
                            return null;
                          }
                        },
                      ),
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      child: TextFormField(
                        controller: _passwordcontroller,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          suffixIcon: GestureDetector(
                            onTap: _togglePasswordVisibility,
                            child: Icon(
                              _isPasswordVisible
                                  ? FontAwesomeIcons.eyeSlash
                                  : FontAwesomeIcons.eye,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        obscureText: !_isPasswordVisible,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a password';
                          } else if (value.length < 8) {
                            return 'Password should be at least 8 characters long';
                          } else if (!RegExp(
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                              .hasMatch(value)) {
                            return 'Password should contain at least one uppercase letter, one lowercase letter, one digit, and one special character (!@#\$&*~)';
                          }
                          return null;
                        },
                      ),
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _checkedValue,
                          onChanged: (value) {
                            setState(() {
                              _checkedValue = value!;
                            });
                          },
                        ),
                        Text(
                          "I agree to the terms and conditions",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: HexColor("#3B7CFF"),
                      ),
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.orange),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final email = _emailcontroller.text;
                            final isEmailUsed = await isEmailAlreadyUsed(email);

                            if (isEmailUsed) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Email is already in use.'),
                                ),
                              );
                            } else {
                              final UserCredential userCredential =
                                  await _auth.createUserWithEmailAndPassword(
                                      email: email,
                                      password: _passwordcontroller.text);

                              await _firestore
                                  .collection('users')
                                  .doc(userCredential.user!.uid)
                                  .set({
                                'firstName': _firstnamecontroller.text,
                                'lastName': _lastnamecontroller.text,
                                'email': email,
                                'phoneNumber': _phonenumbercontroller.text,
                                'password': _passwordcontroller.text,
                              });

                               await sendWelcomeEmail(email); // Send the welcome email to the user
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePageUser(),
                                ),
                              );
                            }
                          }
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                  ]),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

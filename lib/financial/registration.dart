// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, sort_child_properties_last, prefer_final_fields, use_key_in_widget_constructors, avoid_print, prefer_is_not_empty, unused_label

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:retirement_management_system/common/theme_helper.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:retirement_management_system/financial/request.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FinancialAdvisorRegistrationForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FinancialAdvisorRegistrationForm();
  }
}

class _FinancialAdvisorRegistrationForm extends State<FinancialAdvisorRegistrationForm> {
  File? _selectedImage;
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _firstnamecontroller = TextEditingController();
  TextEditingController _lastnamecontroller = TextEditingController();
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _phonenumbercontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  TextEditingController _experiencecontroller = TextEditingController();
  TextEditingController _certificationcontroller = TextEditingController();
  TextEditingController _expertisecontroller = TextEditingController();
  bool _checkedValue = false;
  bool _isPasswordVisible = false;

  // Function to handle image selection from the gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  // Function to upload the selected image to Firebase Storage
  Future<String?> _uploadImage() async {
    if (_selectedImage != null) {
      try {
        final fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final destination = 'images/$fileName';
        final reference = FirebaseStorage.instance.ref(destination);
        final uploadTask = reference.putFile(_selectedImage!);
        final snapshot = await uploadTask;
        final imageUrl = await snapshot.ref.getDownloadURL();
        return imageUrl;
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
    return null;
  }

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
        title: Text("Financial Advisor Registration"),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          child: TextFormField(
                            controller: _firstnamecontroller,
                            decoration: ThemeHelper().textInputDecoration(
                              'First Name',
                              'Enter your first name',
                            ),
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: TextFormField(
                            controller: _lastnamecontroller,
                            decoration: ThemeHelper().textInputDecoration(
                              'Last Name',
                              'Enter your last name',
                            ),
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 10.0),
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
                        SizedBox(height: 10.0),
                        Container(
                          child: TextFormField(
                            controller: _phonenumbercontroller,
                            decoration: ThemeHelper().textInputDecoration(
                              "Phone Number",
                              "Enter your phone number",
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your phone number";
                              } else if (!RegExp(r"^\+?[0-9]{10,12}$").hasMatch(val)) {
                                return "Please enter a valid phone number";
                              } else {
                                return null;
                              }
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 10.0),
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
                        SizedBox(height: 10.0),
                        Container(
                          child: TextFormField(
                            controller: _experiencecontroller,
                            decoration: ThemeHelper().textInputDecoration(
                              "Professional Experience",
                              'Please enter Professional Experience',
                            ),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your age";
                              } else {
                                return null;
                              }
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 10, ),
                        Container(
                          child: TextFormField(
                            controller: _certificationcontroller,
                            decoration: ThemeHelper().textInputDecoration(
                              "Certification",
                              "Enter your Certification",
                            ),
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 10),
                        Container(
                          child: TextFormField(
                            controller: _expertisecontroller,
                            decoration: ThemeHelper().textInputDecoration(
                              "Area of Expertise",
                              "Enter your area of Expertise",
                            ),
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          child: TextFormField(
                            readOnly: true, // Make the text field read-only
                            onTap: _pickImage, // Open the image picker on tap
                            decoration: ThemeHelper().textInputDecoration(
                              'Select Image', // Display "Select Image" as the hint text
                              '',
                            ),
                            validator: (val) {
                              if (_selectedImage == null) {
                                return 'Please select an image';
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                         SizedBox(
                      height: 20,
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
                        SizedBox(height: 15.0),
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: HexColor("#3B7CFF"),
                          ),
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
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
                                      
                              final imageUrl = await _uploadImage();

                              await _firestore.collection('advisors').doc(userCredential.user!.uid).set({
                                'firstName': _firstnamecontroller.text,
                                'lastName': _lastnamecontroller.text,
                                'email': _emailcontroller.text,
                                'phoneNumber': _phonenumbercontroller.text,
                                'password': _passwordcontroller.text,
                                'experience': _experiencecontroller.text,
                                'certification': _certificationcontroller.text,
                                'expertise': _expertisecontroller.text,
                                'image': imageUrl,
                              });

                              await sendWelcomeEmail(email);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => AdvisorWelcomePage(),
                                ),
                              );
                            }
                          }
                       },
                            child: Text(
                              "Register",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]
          ),          
        ),
      );
    }
  }


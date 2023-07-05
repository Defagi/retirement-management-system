// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retirement_management_system/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:retirement_management_system/data/provider.dart';
import 'package:retirement_management_system/firebase_options.dart';


void main() async {


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserDataProvider>(
          create: (_) => UserDataProvider(),
        ),
      ],
      child: Rms(),
    ),
  ); 
}

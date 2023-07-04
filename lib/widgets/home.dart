// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, unused_element, avoid_print, empty_statements, use_build_context_synchronously

import 'package:flutter/material.dart';
// import 'package:retirement_management_system/data/service_rating.dart';
import 'package:retirement_management_system/messages/ConversationScreen.dart';
import 'package:retirement_management_system/widgets/AppBarUser.dart';
import 'package:retirement_management_system/pages/body.dart';
import 'package:retirement_management_system/widgets/MyDrawer.dart';

class HomePageUser extends StatefulWidget {
  const HomePageUser({super.key});

  @override
  _HomePageUserState createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: AppBarUser(),
      ),
      body: MyBodyUser(),
            floatingActionButton: SizedBox(
        width: 120,
        height: 48,
        child: FloatingActionButton(
          onPressed: () async {
            // Create a new conversation
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ConversationScreen(),
              ),
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: Colors.orange,
          child: const Text('Chat with us'),
        ),
        )
        );
      }
  }





import 'package:chattingapp/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const HomePage({super.key, required this.userModel, required this.firebaseUser});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat App"),
      ),
      body: SafeArea(
          child: Container(
        color: Colors.black,
      )),
    );
  }
}

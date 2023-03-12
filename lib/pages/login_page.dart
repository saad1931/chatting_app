// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:html';

import 'package:chattingapp/models/user_model.dart';
import 'package:chattingapp/pages/sign_up_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email == "" || password == "") {
      print("Please fill all the fields!");
    } else {
      
      login(email, password);
    }
  }

  void login(String email, String password) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      print(ex.code.toString());
    }
    if (credential != null) {
      String uid = credential.user!.uid;

      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      UserModel userModel =
          UserModel.fromMap(userData.data() as Map<String, dynamic>);

      log("Login Successfully!");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return HomePage(
              userModel: userModel, firebaseUser:credential!.user!
              );
        }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Chatting App",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: emailController,
                    decoration:
                        const InputDecoration(labelText: "E-mail Address"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Password"),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CupertinoButton(
                      color: Theme.of(context).colorScheme.secondary,
                      onPressed: () {
                        checkValues();
                      },
                      child: const Text(
                        "Log In",
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
      // ignore: avoid_unnecessary_containers
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Don't have an account?",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            CupertinoButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const SignUp();
                  }));
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

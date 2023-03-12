
import 'package:chattingapp/models/user_model.dart';
import 'package:chattingapp/pages/complete_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cPassword = cPasswordController.text.trim();

    if (email == "" || password == "" || cPassword == "") {
      print("please fill all the fields!");
    } else if (password != cPassword) {
      print("Password and confirm password not matched");
    } else {
      signUp(email, password);
    }
  }

  void signUp(String email, String password) async {
    UserCredential? Credential;
    try {
      Credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      print(ex.code.toString());
    }

    if (Credential != null) {
      String uid = Credential.user!.uid;
      UserModel newUser = UserModel(
        uid: uid,
        email: email,
        fullname: "",
        profilepic: "",
      );
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newUser.toMaP())
          .then((value) {
        print("New user created!");
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CompliteProfile(
              userModel: newUser, firebaseUser: Credential!.user!);
        }));
      });
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
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: emailController,
                    decoration:
                        const InputDecoration(labelText: "E-mail Address"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Password"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: cPasswordController,
                    obscureText: true,
                    decoration:
                        const InputDecoration(labelText: "Confirm Password"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CupertinoButton(
                      color: Theme.of(context).colorScheme.secondary,
                      onPressed: () {
                        checkValues();
                      },
                      child: const Text(
                        "Sign Up",
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
              "Already have an account?",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            CupertinoButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Log In",
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

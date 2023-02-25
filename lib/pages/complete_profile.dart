import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompliteProfile extends StatefulWidget {
  const CompliteProfile({super.key});

  @override
  State<CompliteProfile> createState() => _CompliteProfileState();
}

class _CompliteProfileState extends State<CompliteProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:const Text("Complete Profile"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: ListView(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
               const SizedBox(height: 20,),
               CupertinoButton(
                 onPressed: (){},
                 child: const CircleAvatar(
                  radius: 60,
                  child: Icon(Icons.person,size: 60,),
              ),
               ),
              const SizedBox(height: 20,),
              const TextField(
                decoration: InputDecoration(
                  labelText: "Full Name"
                ),
              ),
              const SizedBox(height: 30,),
              CupertinoButton(
                      color: Theme.of(context).colorScheme.secondary,
                      onPressed: () {},
                      child: const Text(
                        "Submit",
                      ))
            ],
          ),
        )),
    );
  }
}
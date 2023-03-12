// ignore_for_file: prefer_is_empty

import 'package:chattingapp/models/user_model.dart';
import 'package:chattingapp/pages/chatroom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchPage(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  // bool isShowUsers = false;
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: searchController,
                // onSubmitted: (String _) {
                //   setState(() {
                //     isShowUsers = true;
                //   });
                // },
                decoration: const InputDecoration(labelText: "Email Address"),
              ),
              const SizedBox(
                height: 20,
              ),
              CupertinoButton(
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () {
                    setState(() {});
                  },
                  child: const Text("Search")),
              const SizedBox(
                height: 20,
              ),
              // isShowUsers
              //     ?
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where("email", isEqualTo: searchController.text)
                    .snapshots(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot datasnapshot =
                          snapshot.data as QuerySnapshot;
                      if (datasnapshot.docs.length > 0) {
                        Map<String, dynamic> userMap =
                            datasnapshot.docs[0].data() as Map<String, dynamic>;

                        UserModel searchedUser = UserModel.fromMap(userMap);
                        return ListTile(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const ChatRoom();
                            }));
                          },
                          // leading: CircleAvatar(
                          //   backgroundImage: NetworkImage(
                          //     searchedUser.profilepic!,
                          //   ),
                          // ),
                          title: Text(searchedUser.fullname.toString()),
                          subtitle: Text(searchedUser.email.toString()),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                        );

                        // return ListView.builder(
                        //     shrinkWrap: true,
                        //     itemCount:
                        //         (snapshot.data! as dynamic).docs.length,
                        //     itemBuilder: (context, index) {
                        //       return InkWell(
                        //         //onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfileScreen(uid: (snapshot.data! as dynamic).docs[index]['uid']))),
                        //         child: ListTile(
                        //           leading: Text((snapshot.data! as dynamic)
                        //               .docs[index]['fullname']),
                        //           title: Text((snapshot.data! as dynamic)
                        //               .docs[index]['email']),
                        //         ),
                        //       );
                        //     });

                      } else {
                        return const Text("No Result found!");
                      }
                    } else if (snapshot.hasError) {
                      return const Text("An error Occured");
                    } else {
                      return const Text("No Result found");
                    }
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
              )
              // : const Icon(
              //     Icons.search,
              //     size: 50,
              //   )
            ],
          ),
        ),
      )),
    );
  }
}

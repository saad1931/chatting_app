import 'dart:developer';
import 'dart:io';
import 'package:chattingapp/models/user_model.dart';
import 'package:chattingapp/pages/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CompliteProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const CompliteProfile(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<CompliteProfile> createState() => _CompliteProfileState();
}

class _CompliteProfileState extends State<CompliteProfile> {
  File? imageFile;
  TextEditingController fullNameController = TextEditingController();
  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? croppedImage = (await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 45,
    ));

    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

  void showPhotoOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(
              child: Text("Upload profile picture"),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.camera);
                  },
                  leading: Icon(Icons.camera_alt),
                  title: Text("Take a photo"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.gallery);
                  },
                  leading: Icon(Icons.photo_album),
                  title: Text("Select from gallery"),
                ),
              ],
            ),
          );
        });
  }

  void checkValues() {
    String fullname = fullNameController.text.trim();

    if (fullname == "" ) {
      imageFile == null;
      print("please fill fullname field");
    } else {
      uploadData();
      log("Data uploaded..");
    }
  }

  void uploadData() async {
    // UploadTask uploadTask = FirebaseStorage.instance
    //     .ref("prifilepictures")
    //     .child(widget.userModel.uid.toString())
    //     .putFile(imageFile!);

    // TaskSnapshot snapshot = await uploadTask;

    // String imageUrl = await snapshot.ref.getDownloadURL();
     String fullname = fullNameController.text.trim();

    widget.userModel.fullname = fullname;
    //widget.userModel.profilepic = imageUrl;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMaP())
        .then((value) {
      log("Data uploaded");
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return HomePage(
            userModel: widget.userModel, firebaseUser: widget.firebaseUser);
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Complete Profile"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: ListView(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const SizedBox(
              height: 20,
            ),
            CupertinoButton(
              onPressed: () {
                showPhotoOptions();
              },
              child: CircleAvatar(
                  backgroundImage:
                      (imageFile != null) ? FileImage(imageFile!) : null,
                  radius: 60,
                  child: (imageFile == null)
                      ? const Icon(
                          Icons.person,
                          size: 60,
                        )
                      : null),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(labelText: "Full Name"),
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
                  "Submit",
                ))
          ],
        ),
      )),
    );
  }
}

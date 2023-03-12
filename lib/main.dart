import 'package:chattingapp/models/firebase_helper.dart';
import 'package:chattingapp/models/user_model.dart';
import 'package:chattingapp/pages/complete_profile.dart';
import 'package:chattingapp/pages/homepage.dart';
import 'package:chattingapp/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBvId8DtH_oHzxQhhj1m9LV37twDMRUTlE",
          appId: "1:611288581043:web:f4683c68ecf66baea001c6",
          messagingSenderId: "611288581043",
          projectId: "chattingapp-40127",
          storageBucket: 'chattingapp-40127.appspot.com'),
    );
  } else {
    await Firebase.initializeApp();
  }
  User? currentUser = FirebaseAuth.instance.currentUser;
  if(currentUser != null){
    UserModel? thisUserModel =await FirebaseHelper.getUserModelById(currentUser.uid);
    if(thisUserModel != null){
      runApp( MyAppLoggedIn(userModel:thisUserModel ,firebaseUser: currentUser,));
    }
    else{
      runApp(const MyApp());
    }
  }
  else{
    runApp(const MyApp());
  }
  
}

//Not logged in
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

//logged in
class MyAppLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const MyAppLoggedIn(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(userModel: userModel, firebaseUser: firebaseUser),
    );
  }
}

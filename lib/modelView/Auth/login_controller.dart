import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meettown/res/global.dart';
import 'package:meettown/view/BottomNavbar/BottomNavbar.dart';
import 'package:meettown/view/Dashboard/home.dart';

class LoginController extends ChangeNotifier {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _checkBox = false;
  bool loading = false;

  bool get checkBox => _checkBox;

  void setCheckboxValue(v) {
    _checkBox = v;
    notifyListeners();
  }

  setLoading(val) {
    loading = val;
    notifyListeners();
  }

  Future<void> signInUserAccount(context, String email, String password) async {
    try {
      // Create user account with email and password
      setLoading(true);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // User account created successfully
      print('Account Login successfully');

      UserId = userCredential.user!.uid;

      UserId = userCredential.user!.uid;

      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('users/$UserId').get();
      if (snapshot.exists) {
        print(snapshot.value);
        final Map<dynamic, dynamic>? data = snapshot.value as Map?;
        if (data != null) {
          final userData = data.cast<String, dynamic>();
          UserName = userData["firstName"];
          image = userData["Image"];
        } else {
          print("User data is null or not a map.");
        }
      } else {
        print('No data available.');
      }

      Get.snackbar(
        "Success",
        "Account Login Successfully", // Display the error message
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
      );
      Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (_) => CustomNavbar()),
  (route) => false, // This removes all the previous routes
);
      
      // SignUp(context);
    } on FirebaseAuthException catch (e) {
      setLoading(false);

      // An error occurred while creating the user account
      Get.snackbar(
        "Error",
        e.message!, // Display the error message
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
      );
      // You can handle different error scenarios here
    } catch (e) {
      setLoading(false);

      Get.snackbar(
        "Error",
        e.toString()!, // Display the error message
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
      );
    }
  }

  void login(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CustomNavbar()));
  }
}

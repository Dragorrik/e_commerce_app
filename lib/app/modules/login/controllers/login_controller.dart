import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    emailController.text = "aarikanan@gmail.com";
    passwordController.text = "123456";
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Email and password cannot be empty',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        Get.offAllNamed('/product-list');
      } else {
        Get.snackbar('Error', 'Login failed',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Login Error', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Logout Error', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}

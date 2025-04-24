import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> register(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Send verification email
        await userCredential.user!.sendEmailVerification();

        Get.snackbar(
          'Verification Email Sent',
          'Please check your inbox and verify your email before logging in.',
          snackPosition: SnackPosition.BOTTOM,
        );

        // Optionally redirect to login
        Get.offAllNamed('/login');
      } else {
        Get.snackbar('Error', 'Registration failed');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      // Call back
      Get.back(); // go back
      Get.snackbar(
        'Success',
        'Password reset email sent. Check your inbox (or spam).',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

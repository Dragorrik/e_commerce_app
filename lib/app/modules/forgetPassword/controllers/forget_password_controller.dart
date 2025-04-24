import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar("Success", "Password reset link sent to $email");
      Get.back(); // Go back to login screen
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}

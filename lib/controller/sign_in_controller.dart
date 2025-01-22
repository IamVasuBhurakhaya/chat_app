import 'package:chat_app/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../routes/routes.dart';

class LoginController extends GetxController {
  // Login New User
  void login({required String email, required String password}) {
    Future<User?> user =
        FirebaseServices.firebaseServices.login(email, password);
    user.then((value) {
      if (value != null) {
        Get.offNamed(AppRoutes.home);
        Get.snackbar('Success', 'Login Successfully');
      } else {
        Get.snackbar('Error', 'Login Failed');
      }
    });
  }

  //Anonymous Login
  void loginAnonymous() {
    Future<User?> user = FirebaseServices.firebaseServices.loginAnonymous();
    user.then((value) {
      if (value != null) {
        Get.offNamed(AppRoutes.home);
        Get.snackbar('Success', 'Login Successfully');
      } else {
        Get.snackbar('Error', 'Login Failed');
      }
    });
  }
}


import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../services/auth_services.dart';

class RegisterController extends GetxController {
  //Sign up with email and password
  void register({required String email, required String password}) {
    Future<User?> user =
        FirebaseServices.firebaseServices.register(email, password);
    user.then((value) {
      if (value != null) {
        Get.snackbar('Success', 'Register Successfully');
        Get.back();
      } else {
        Get.snackbar('Error', 'Register Failed');
      }
    });
  }
}

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

import '../model/user_model.dart';
import '../routes/routes.dart';
import '../services/auth_services.dart';
import '../services/fireStore_service.dart';

class SignInController extends GetxController {
  RxBool isPassword = true.obs;

  void hidePassword() {
    isPassword.value = !isPassword.value;
  }

  Future<void> signInUser(
      {required String email, required String password}) async {
    String msg = await FirebaseAuthService.auth
        .signInUsers(email: email, password: password);
    if (msg == "Success") {
      Get.offNamed(AppRoutes.home);
      toastification.show(
        title: const Text("Success"),
        description: const Text("SignIn successful"),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.success,
      );
    } else {
      toastification.show(
        title: const Text("Failed"),
        description: const Text("SignIn un-successful"),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.error,
      );
    }
  }

  Future<void> signInAnonymous() async {
    User? user = await FirebaseAuthService.auth.signInAnonymous();
    if (user != null) {
      Get.offNamed(AppRoutes.home);
      toastification.show(
        title: const Text("Success"),
        description: const Text("SignIn successful"),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.success,
      );
    } else {
      toastification.show(
        title: const Text("Failed"),
        description: const Text("SignIn un-successful"),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.error,
      );
    }
  }

  Future<void> signInGoogle() async {
    String? user = await FirebaseAuthService.auth.signInGoogle();
    if (user == "Success") {
      Get.offNamed(AppRoutes.home);
      var userStatus = FirebaseAuthService.auth.statusUser;

      if (userStatus != null) {
        await FireStoreService.fireStoreService.addUsers(
          modal: UserModal(
            uid: userStatus.uid,
            name: userStatus.displayName,
            email: userStatus.email,
            password: "",
            image: userStatus.photoURL,
            token: await FirebaseMessaging.instance.getToken(),
          ),
        );
      }
      toastification.show(
        title: const Text("Success"),
        description: const Text("SignIn successful"),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.success,
      );
    } else {
      toastification.show(
        title: const Text("Failed"),
        description: const Text("SignIn un-successful"),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.error,
      );
    }
  }
}

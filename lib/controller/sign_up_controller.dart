import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toastification/toastification.dart';

import '../model/user_model.dart';
import '../services/auth_services.dart';
import '../services/firestore_service.dart';

class RegisterController extends GetxController {
  RxBool isPassword = true.obs;
  RxBool isCPassword = true.obs;
  File? image;

  void changeVisibilityPassword() {
    isPassword.value = !isPassword.value;
  }

  void changeVisibilityCPassword() {
    isCPassword.value = !isCPassword.value;
  }

  Future<void> registerNewUser({
    required String userName,
    required String email,
    required String password,
    required String image,
  }) async {
    String msg = await AuthService.authService.registerUser(
      email: email,
      password: password,
    );

    if (msg == 'Success') {
      Get.back();

      FireStoreService.fireStoreService.addUser(
        user: UserModel(
          uid: AuthService.authService.currentUser?.uid ?? "",
          name: userName,
          email: email,
          password: password,
          image: image,
          token: await FirebaseMessaging.instance.getToken() ?? "",
        ),
      );

      toastification.show(
        title: const Text("Success"),
        description: const Text(
          "register success.. 😪",
        ),
        autoCloseDuration: const Duration(
          seconds: 3,
        ),
        type: ToastificationType.success,
        style: ToastificationStyle.minimal,
      );
    } else {
      toastification.show(
        title: const Text("Register Failed"),
        description: Text(
          msg,
        ),
        autoCloseDuration: const Duration(
          seconds: 3,
        ),
        type: ToastificationType.error,
        style: ToastificationStyle.minimal,
      );
    }
  }

  Future<void> pickUserImage() async {
    ImagePicker picker = ImagePicker();

    XFile? xFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (xFile != null) {
      image = File(xFile.path);
    }

    update();
  }
}

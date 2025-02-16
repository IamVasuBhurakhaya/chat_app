import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toastification/toastification.dart';

import '../model/user_model.dart';
import '../services/auth_services.dart';
import '../services/fireStore_service.dart';

class SignUpController extends GetxController {
  File? image;
  RxBool isPassword = true.obs;
  RxBool isCPassword = true.obs;

  void hidePassword() {
    isPassword.value = !isPassword.value;
  }

  void hideCPassword() {
    isCPassword.value = !isCPassword.value;
  }

  Future<void> signUp(
      {required String email,
      required String password,
      required String image,
      required String userName}) async {
    String? msg = await FirebaseAuthService.auth.createUsers(
      email: email,
      password: password,
    );

    if (msg == "Success") {
      Get.back();

      FireStoreService.fireStoreService.addUsers(
        modal: UserModal(
          uid: FirebaseAuthService.auth.statusUser?.uid ?? '',
          name: userName,
          email: email,
          password: password,
          image: image,
          token: await FirebaseMessaging.instance.getToken(),
        ),
      );

      toastification.show(
        title: const Text("Success"),
        autoCloseDuration: const Duration(seconds: 3),
        description: const Text("You sign up successfully"),
        type: ToastificationType.success,
      );

      Get.back();
    } else {
      toastification.show(
        title: const Text("Failed"),
        autoCloseDuration: const Duration(seconds: 3),
        description: Text(msg!),
        type: ToastificationType.error,
      );
    }
  }

  Future<void> galleryPicker() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      image = File(file.path);
      Get.back();
    }
    update();
  }

  Future<void> cameraPicker() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.camera);
    if (file != null) {
      image = File(file.path);
      Get.back();
    }
    update();
  }
}

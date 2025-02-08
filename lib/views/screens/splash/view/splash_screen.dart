import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/routes.dart';
import '../../../../services/auth_services.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 10), () {
      log("Current User : ${AuthService.authService.currentUser}");
      (AuthService.authService.currentUser != null)
          ? Get.offNamed(Routes.home)
          : Get.offNamed(Routes.login);
    });
    return Scaffold(
      backgroundColor: const Color(0xfff2f6fa),
      body: Center(
        child: Image.asset(
          'assets/images/logo.gif',
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../routes/routes.dart';
import '../../../../services/auth_services.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 4),
      () => FirebaseAuthService.auth.statusUser != null
          ? Get.offNamed(AppRoutes.home)
          : Get.offNamed(AppRoutes.login),
    );
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/whatshapp_bg.jpg',
                ),
                fit: BoxFit.cover)),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/app_icon.png',
              fit: BoxFit.cover,
              height: 200.sp,
              width: 200.sp,
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "Doodle",
              style: TextStyle(
                color: const Color(0xFF25D366),
                fontSize: 46.sp,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

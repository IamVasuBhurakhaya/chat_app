import 'package:chat_app/utils/extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../controller/sign_in_controller.dart';
import '../../../../routes/routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    var loginKey = GlobalKey<FormState>();

    var controller = Get.put(LoginController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(
              'assets/images/login.gif',
            ),
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Form(
                  key: loginKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextFormField(
                        controller: emailController,
                        validator: (val) => val!.isEmpty
                            ? "required email.."
                            : (!val.isVerifyEmail())
                                ? "email is not valid"
                                : null,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xfff2f6fa),
                          hintText: "Enter email",
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.grey,
                          ),
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Obx(() {
                        return TextFormField(
                          obscureText: controller.isPassword.value,
                          controller: passwordController,
                          validator: (val) =>
                              val!.isEmpty ? "required password.." : null,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xfff2f6fa),
                            hintText: "Enter password",
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.grey,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                controller.changeVisibilityPassword();
                              },
                              icon: Icon(
                                (controller.isPassword.value)
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                        );
                      }),
                      SizedBox(
                        height: 20.h,
                      ),
                      Align(
                        child: GestureDetector(
                          onTap: () {
                            if (loginKey.currentState!.validate()) {
                              controller.loginNewUser(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                            }
                          },
                          child: Container(
                            height: 50.h,
                            width: 140.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(0xff518cf7),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Align(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            controller.signInWithGoogle();
                          },
                          icon: Icon(
                            Icons.g_mobiledata,
                            size: 25.sp,
                          ),
                          label: const Text("Sign In With Google"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Text.rich(
              TextSpan(
                text: "Don't have an account ? ",
                children: [
                  TextSpan(
                    text: "Register",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.toNamed(Routes.register);
                      },
                    style: const TextStyle(
                      color: Color(0xff518cf7),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xff518cf7),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:chat_app/utils/extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

import '../../../../controller/sign_up_controller.dart';
import '../../../../services/api_services.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController userNameContrller = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController cPasswordController = TextEditingController();
    var registerKey = GlobalKey<FormState>();

    var controller = Get.put(RegisterController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Image.asset(
            //   'assets/images/register.gif',
            //   height: 280.h,
            // ),
            const Spacer(),
            Expanded(
              flex: 8,
              child: SingleChildScrollView(
                child: Form(
                  key: registerKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            GetBuilder<RegisterController>(builder: (context) {
                              return CircleAvatar(
                                radius: 65.w,
                                foregroundImage: (controller.image != null)
                                    ? FileImage(controller.image!)
                                    : null,
                                child: (controller.image != null)
                                    ? const Text("")
                                    : Icon(
                                        Icons.person,
                                        size: 45.sp,
                                      ),
                              );
                            }),
                            FloatingActionButton.small(
                              onPressed: () {
                                controller.pickUserImage();
                              },
                              child: const Icon(Icons.add_a_photo_outlined),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "Username",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextFormField(
                        controller: userNameContrller,
                        validator: (val) =>
                            val!.isEmpty ? "required username.." : null,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xfff2f6fa),
                          hintText: "Enter username",
                          prefixIcon: const Icon(
                            Icons.person,
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
                        height: 10.h,
                      ),
                      Text(
                        "Conform Password",
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
                          obscureText: controller.isCPassword.value,
                          controller: cPasswordController,
                          validator: (val) => val!.isEmpty
                              ? "required conform password.."
                              : null,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xfff2f6fa),
                            hintText: "Enter conform password",
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.grey,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                controller.changeVisibilityCPassword();
                              },
                              icon: Icon(
                                (controller.isCPassword.value)
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
                          onTap: () async {
                            if (registerKey.currentState!.validate() &&
                                controller.image != null) {
                              String userName = userNameContrller.text.trim();
                              String email = emailController.text.trim();
                              String password = passwordController.text.trim();
                              String cPassword =
                                  cPasswordController.text.trim();

                              if (password == cPassword) {
                                String image = await APIService.apiService
                                    .uploadUserImage(image: controller.image!);

                                controller.registerNewUser(
                                  userName: userName,
                                  email: email,
                                  password: password,
                                  image: image,
                                );
                              } else {
                                toastification.show(
                                  title: const Text("ERROR"),
                                  description: const Text(
                                    "password and conform password had not matched",
                                  ),
                                  autoCloseDuration: const Duration(
                                    seconds: 3,
                                  ),
                                  type: ToastificationType.error,
                                  style: ToastificationStyle.flatColored,
                                );
                              }
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
                              "Register",
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
                    ],
                  ),
                ),
              ),
            ),
            Text.rich(
              TextSpan(
                text: "Already have an account ? ",
                children: [
                  TextSpan(
                    text: "Login",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.back();
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

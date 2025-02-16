import 'package:chat_app/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../controller/sign_up_controller.dart';
import '../../../../services/api_services.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController userNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passController = TextEditingController();
    TextEditingController cPassController = TextEditingController();
    SignUpController controller = Get.put(SignUpController());
    GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 14.h,
            ),
            Text(
              "New to Doodle?",
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(
              height: 18.h,
            ),
            Form(
              key: registerFormKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        GetBuilder<SignUpController>(builder: (context) {
                          return CircleAvatar(
                            backgroundColor: Colors.white60,
                            radius: 80,
                            foregroundImage: controller.image != null
                                ? FileImage(controller.image!)
                                : null,
                            child: Container(
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  image: AssetImage('assets/images/dummy.jpg'),
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                            ),
                          );
                        }),
                        FloatingActionButton.small(
                          backgroundColor:
                              const Color(0xFF25D366).withOpacity(0.8),
                          onPressed: () {
                            Get.defaultDialog(
                              title: "Select Image",
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      controller.cameraPicker();
                                    },
                                    label: const Text("Camera"),
                                    icon: const Icon(Icons.camera_alt_rounded),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      controller.galleryPicker();
                                    },
                                    label: const Text("Gallery"),
                                    icon: const Icon(
                                        CupertinoIcons.photo_on_rectangle),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    TextFormField(
                      controller: userNameController,
                      validator: (value) =>
                          value!.isEmpty ? "required username" : null,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Enter Username",
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.green),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    TextFormField(
                      controller: emailController,
                      validator: (value) => value!.isEmpty
                          ? "required email"
                          : value.isValidEmail()
                              ? null
                              : "Please enter proper email!!",
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Enter email",
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.green),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Obx(() {
                      return TextFormField(
                        controller: passController,
                        obscureText: controller.isPassword.value,
                        validator: (value) =>
                            value!.isEmpty ? "Please enter password" : null,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Enter password",
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.green),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.hidePassword();
                            },
                            icon: Icon(
                              controller.isPassword.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: 10.h),
                    Obx(() {
                      return TextFormField(
                        controller: cPassController,
                        obscureText: controller.isCPassword.value,
                        validator: (value) => value!.isEmpty
                            ? "Please enter confirm password"
                            : null,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Re-Enter password",
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.green),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.hidePassword();
                            },
                            icon: Icon(
                              controller.isPassword.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (registerFormKey.currentState!.validate() &&
                              controller.image != null) {
                            if (passController.text == cPassController.text) {
                              String img = await APIService.apiService
                                  .profileImageUpload(image: controller.image!);

                              controller.signUp(
                                email: emailController.text.trim(),
                                password: passController.text.trim(),
                                image: img,
                                userName: userNameController.text.trim(),
                              );
                            } else {
                              passController.clear();
                              cPassController.clear();
                              Get.snackbar('Failed',
                                  'Password and confirm password should be match');
                            }
                          }

                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF25D366), // WhatsApp green
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Text.rich(
                      TextSpan(
                        text: 'Already have a account? ',
                        children: [
                          TextSpan(
                            text: 'Log in',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.back();
                              },
                            style: const TextStyle(
                                color: Color(0xFF25D366),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

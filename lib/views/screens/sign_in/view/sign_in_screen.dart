import 'package:chat_app/utils/extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../controller/sign_in_controller.dart';
import '../../../../routes/routes.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passController = TextEditingController();
    SignInController controller = Get.put(SignInController());
    GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/whatshapp_bg.jpg'),
            fit: BoxFit.cover,
            opacity: 0.7,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/app_icon.png',
              height: 80.h,
            ),
            SizedBox(height: 10.h),
            Text(
              "Welcome Back,",
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: Form(
                key: loginFormKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          validator: (value) => value!.isEmpty
                              ? "E-mail is required"
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
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400),
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
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.green),
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
                        SizedBox(height: 36.h),
                        SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            onPressed: () {
                              if (loginFormKey.currentState!.validate()) {
                                controller.signInUser(
                                  email: emailController.text.trim(),
                                  password: passController.text.trim(),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFF25D366), // WhatsApp green
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 14.h),
                        Text.rich(
                          TextSpan(
                            text: 'New to Doodle? ',
                            children: [
                              TextSpan(
                                text: 'Sign Up',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.toNamed(AppRoutes.register);
                                  },
                                style: const TextStyle(
                                    color: Color(0xFF25D366),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 2,
                                color: Colors.grey,
                              ),
                            ),
                            Text(" Or "),
                            Expanded(
                              child: Divider(
                                thickness: 2,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.signInAnonymous();
                              },
                              child: CircleAvatar(
                                radius: 20.sp,
                                backgroundColor: Colors.grey.shade300,
                                child: Image.asset(
                                  'assets/images/person_logo.png',
                                  height: 24.sp,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 12.w,
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.signInGoogle();
                              },
                              child: CircleAvatar(
                                radius: 20.sp,
                                backgroundColor: Colors.grey.shade300,
                                child: Image.asset(
                                  'assets/images/google_logo.png',
                                  height: 26.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:chat_app/utils/extensions.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import '../../../../controller/sign_in_controller.dart';
// import '../../../../routes/routes.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   @override
//   Widget build(BuildContext context) {
//     TextEditingController emailController = TextEditingController();
//     TextEditingController passController = TextEditingController();
//     LoginController controller = Get.put(LoginController());
//     GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Container(
//         decoration: BoxDecoration(
//             image: DecorationImage(
//                 image: AssetImage('assets/images/whatshapp_bg.jpg'),
//                 fit: BoxFit.cover)),
//         padding: EdgeInsets.all(20.w),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               'assets/images/WhatsApp_logo.jpg',
//               height: 80.h,
//             ),
//             SizedBox(height: 20.h),
//             Text(
//               "Welcome Back",
//               style: TextStyle(
//                 fontSize: 22.sp,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black87,
//               ),
//             ),
//             SizedBox(height: 30.h),
//             Form(
//               key: loginFormKey,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: emailController,
//                     validator: (value) => value!.isEmpty
//                         ? "E-mail is required"
//                         : value.isValidEmail()
//                         ? null
//                         : "Please enter a valid email",
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white,
//                       hintText: "Enter email",
//                       labelText: 'Email',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(color: Colors.grey.shade400),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(color: Colors.green),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 15.h),
//                   Obx(() {
//                     return TextFormField(
//                       controller: passController,
//                       obscureText: controller.isPassword.value,
//                       validator: (value) =>
//                       value!.isEmpty ? "Please enter password" : null,
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.white,
//                         hintText: "Enter password",
//                         labelText: 'Password',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(color: Colors.grey.shade400),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(color: Colors.green),
//                         ),
//                         suffixIcon: IconButton(
//                           onPressed: () {
//                             controller.changePasswordVisibilty();
//                           },
//                           icon: Icon(
//                             controller.isPassword.value
//                                 ? Icons.visibility_off
//                                 : Icons.visibility,
//                             color: Colors.grey.shade600,
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//                   SizedBox(height: 20.h),
//                   SizedBox(
//                     width: double.infinity,
//                     height: 45.h,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         if (loginFormKey.currentState!.validate()) {
//                           controller.loginUser(
//                             email: emailController.text.trim(),
//                             password: passController.text.trim(),
//                           );
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFF25D366), // WhatsApp green
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: Text(
//                         "Login",
//                         style: TextStyle(
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 15.h),
//                   Text.rich(
//                     TextSpan(
//                       text: 'New to WhatsApp? ',
//                       children: [
//                         TextSpan(
//                           text: 'Sign Up',
//                           recognizer: TapGestureRecognizer()
//                             ..onTap = () {
//                               Get.toNamed(AppRoutes.register);
//                             },
//                           style: TextStyle(
//                             color: Color(0xFF25D366), // WhatsApp green
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 20.h),
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Expanded(
//                         child: Divider(
//                           thickness: 1,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 10),
//                         child: Text(
//                           "OR",
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       ),
//                       Expanded(
//                         child: Divider(
//                           thickness: 1,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 16.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           controller.anonymouslyLogin();
//                         },
//                         child: CircleAvatar(
//                           radius: 20.sp,
//                           backgroundColor: Colors.grey.shade300,
//                           child: Image.asset(
//                             'assets/images/person_logo.png',
//                             height: 20.sp,
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 12.w),
//                       GestureDetector(
//                         onTap: () {
//                           controller.googleLogin();
//                         },
//                         child: CircleAvatar(
//                           radius: 20.sp,
//                           backgroundColor: Colors.grey.shade300,
//                           child: Image.asset(
//                             'assets/images/google_logo.png',
//                             height: 20.sp,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

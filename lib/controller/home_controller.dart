import 'package:get/get.dart';

import '../services/auth_services.dart';

class HomeController extends GetxController {
  // RxString userName = "John".obs;
  // RxString email = "john@gmail.com".obs;
  // RxString image =
  //     "https://static.vecteezy.com/system/resources/previews/019/900/322/non_2x/happy-young-cute-illustration-face-profile-png.png"
  //         .obs;
  //
  // void getCurrentUser() {
  //   var user = AuthService.authService.currentUser;
  //
  //   if (user != null) {
  //     userName.value =
  //         user.displayName ?? user.email?.split('@')[0].toUpperCase() ?? "John";
  //     email.value = user.email ?? "john@gmail.com";
  //     image.value = user.photoURL ??
  //         "https://static.vecteezy.com/system/resources/previews/019/900/322/non_2x/happy-young-cute-illustration-face-profile-png.png";
  //   }
  // }

  Future<void> signOut() async {
    await AuthService.authService.logOut();
  }
}

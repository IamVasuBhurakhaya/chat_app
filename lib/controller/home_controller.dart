import 'package:get/get.dart';
import '../routes/routes.dart';
import '../services/auth_services.dart';

class HomeController extends GetxController {
  void logOut() {
    FirebaseAuthService.auth.signOutUser();
    Get.offNamed(AppRoutes.login);
  }
}

import 'package:chat_app/views/screens/home/view/home_screen.dart';
import 'package:get/get.dart';

import '../views/screens/sign_in/view/sign_in_screen.dart';
import '../views/screens/sign_up/view/sign_up_screen.dart';
import '../views/screens/splash/view/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: login, page: () => const LoginPage()),
    GetPage(name: register, page: () => const RegisterPage()),
    GetPage(name: home, page: () => const HomePage()),
  ];
}

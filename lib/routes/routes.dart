import 'package:chat_app/views/screens/settings/settings.dart';
import 'package:get/get.dart';

import '../views/screens/chats/chat_screen.dart';
import '../views/screens/home/view/home_screen.dart';
import '../views/screens/sign_in/view/sign_in_screen.dart';
import '../views/screens/sign_up/view/sign_up_screen.dart';
import '../views/screens/splash/view/splash_screen.dart';

class AppRoutes {
  static String splash = '/';
  static String login = '/login';
  static String register = '/register';
  static String home = '/home';
  static String chat = '/chat';
  static String userList = '/userList';
  static String setting = '/setting';

  static List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: login,
      page: () => LoginPage(),
    ),
    GetPage(
      name: register,
      page: () => RegisterPage(),
    ),
    GetPage(
      name: home,
      page: () => HomePage(),
    ),
    GetPage(
      name: chat,
      page: () => ChatPage(),
    ),
    GetPage(
      name: setting,
      page: () => SettingsPage(),
    ),
  ];
}

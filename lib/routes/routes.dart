import 'package:get/get.dart';
import '../views/screens/chats/chat_screen.dart';
import '../views/screens/home/view/home_screen.dart';
import '../views/screens/sign_in/view/sign_in_screen.dart';
import '../views/screens/sign_up/view/sign_up_screen.dart';
import '../views/screens/splash/view/splash_screen.dart';

class Routes {
  static String splash = '/';
  static String login = '/login';
  static String register = '/register';
  static String home = '/home';
  static String chat = '/chat';

  static List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: register,
      page: () => const RegisterScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: chat,
      page: () => const ChatPage(),
      transition: Transition.cupertino,
    ),
  ];
}

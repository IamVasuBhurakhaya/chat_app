import 'package:chat_app/views/screens/chat_header/view/chats_header.dart';
import 'package:chat_app/views/screens/settings/view/settings.dart';
import 'package:get/get.dart';
import '../views/screens/chats/view/chat_screen.dart';
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
  static String chatHeader = '/chatHeader';

  static List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: login,
      page: () => const SignInScreen(),
    ),
    GetPage(
      name: register,
      page: () => const SignUpScreen(),
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: chat,
      page: () => const ChatScreen(),
    ),
    GetPage(
      name: setting,
      page: () => const SettingScreen(),
    ),
    GetPage(
      name: chatHeader,
      page: () => const ChatsHeader(),
    ),
  ];
}

import 'package:get/get.dart';
import 'package:virtoustack_assignment/modules/auth/auth_binding.dart';
import 'package:virtoustack_assignment/modules/auth/auth_screen.dart';
import 'package:virtoustack_assignment/modules/home/home_binding.dart';
import 'package:virtoustack_assignment/modules/home/home_screen.dart';
import 'package:virtoustack_assignment/routes/app_routes.dart';

class AppPages {
  static final List<GetPage> pages = [
    // GetPage(name: AppRoutes.initialRoute, page: () => const LandingScreen(), ),
    GetPage(name: AppRoutes.authRoute, page: () => const AuthScreen(), binding: AuthBinding()),
    GetPage(name: AppRoutes.homeRoute, page: () => const HomeScreen(), binding: HomeBinding()),
  ];
}

import 'dart:math';
import 'package:virtoustack_assignment/common/storage_service.dart';
import 'package:virtoustack_assignment/routes/app_routes.dart';

class AppUtils {
  // Storage keys
  static const String userId = "USER_ID";

  static String checkUser() {
    if (StorageService.instance.fetch(AppUtils.userId) != null) {
      return AppRoutes.homeRoute;
    } else {
      return AppRoutes.authRoute;
    }
  }

  static String generateItemId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(5, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }
}

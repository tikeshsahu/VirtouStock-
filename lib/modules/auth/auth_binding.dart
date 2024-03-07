import 'package:get/get.dart';
import 'package:virtoustack_assignment/modules/auth/auth_controller.dart';


class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController(), fenix: true);
  }
}
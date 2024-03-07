import 'package:get/get.dart';
import 'package:virtoustack_assignment/modules/home/home_controller.dart';


class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(), fenix: true);
  }
}
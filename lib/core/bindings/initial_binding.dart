import 'package:get/get.dart';
import 'package:travel_crm/core/controllers/auth_controller.dart';
import 'package:travel_crm/core/controllers/theme_controller.dart';
import 'package:travel_crm/core/controllers/navigation_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core Controllers - Available throughout the app
    Get.put(AuthController(), permanent: true);
    Get.put(ThemeController(), permanent: true);
    Get.put(NavigationController(), permanent: true);
  }
}

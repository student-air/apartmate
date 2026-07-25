import 'package:get/get.dart';
import 'package:apartmate/routes/app_routes.dart';

class SplashController extends GetxController {
  void skip() => _goToLogin();

  void _goToLogin() {
    if (Get.currentRoute == AppRoutes.splash) {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
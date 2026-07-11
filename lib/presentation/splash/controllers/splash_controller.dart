import 'package:get/get.dart';
import 'package:apartmate/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 2200), _goToLogin);
  }

  void skip() => _goToLogin();

  void _goToLogin() {
    if (Get.currentRoute == AppRoutes.splash) {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
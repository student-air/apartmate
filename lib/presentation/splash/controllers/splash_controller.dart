import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _init();
  }

  void skip() => _goToLogin();

  Future<void> _init() async {
    if (Get.context != null) {
      await precacheImage(
        const AssetImage('assets/images/logo.png'),
        Get.context!,
      );
    }
    await Future.delayed(const Duration(milliseconds: 2200));
    _goToLogin();
  }

  void _goToLogin() {
    if (Get.currentRoute == AppRoutes.splash) {
      Get.offAllNamed(AppRoutes.login);
    }
  }
} 
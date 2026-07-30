import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/routes/app_routes.dart';
import 'package:apartmate/domain/repositories/i_auth_repository.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _init();
  }

  void skip() => _goToNext();

  Future<void> _init() async {
    if (Get.context != null) {
      await precacheImage(
        const AssetImage('assets/images/logo.png'),
        Get.context!,
      );
    }
    await Future.delayed(const Duration(milliseconds: 2200));
    _goToNext();
  }

  void _goToNext() {
    if (Get.currentRoute != AppRoutes.splash) return;

    final authRepository = Get.find<IAuthRepository>();
    final isLoggedIn = authRepository.currentUser != null;

    if (isLoggedIn) {
      Get.offAllNamed(AppRoutes.dashboard);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
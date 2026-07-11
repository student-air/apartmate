import 'package:get/get.dart';
import 'package:apartmate/presentation/splash/bindings/splash_binding.dart';
import 'package:apartmate/presentation/splash/views/splash_view.dart';
import 'package:apartmate/routes/app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
  ];
}
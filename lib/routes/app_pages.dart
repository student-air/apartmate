import 'package:get/get.dart';
import 'package:apartmate/presentation/splash/bindings/splash_binding.dart';
import 'package:apartmate/presentation/splash/views/splash_view.dart';
import 'package:apartmate/presentation/auth/bindings/auth_binding.dart';
import 'package:apartmate/presentation/auth/views/login_view.dart';
import 'package:apartmate/presentation/auth/views/signup_view.dart';
import 'package:apartmate/presentation/society_register/bindings/society_register_binding.dart';
import 'package:apartmate/presentation/society_register/views/society_register_view.dart';
import 'package:apartmate/routes/app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.societyRegister,
      page: () => const SocietyRegisterView(),
      binding: SocietyRegisterBinding(),
    ),
  ];
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/bindings/initial_binding.dart';
import 'package:apartmate/core/constants/app_strings.dart';
import 'package:apartmate/core/theme/app_theme.dart';
import 'package:apartmate/routes/app_pages.dart';
import 'package:apartmate/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ApartMateApp());
}

class ApartMateApp extends StatelessWidget {
  const ApartMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      builder: (context, child) {
        // Precache once when the first frame has a real context
        precacheImage(const AssetImage('assets/images/logo.png'), context);
        return child ?? const SizedBox.shrink();
      },
    );
  }
}

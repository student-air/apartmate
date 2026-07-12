import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/bindings/initial_binding.dart';
import 'package:apartmate/core/constants/app_strings.dart';
import 'package:apartmate/core/theme/app_theme.dart';
import 'package:apartmate/routes/app_pages.dart';
import 'package:apartmate/routes/app_routes.dart';

void main() {
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
    );
  }
}
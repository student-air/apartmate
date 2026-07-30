import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:apartmate/core/bindings/initial_binding.dart';
import 'package:apartmate/core/constants/app_strings.dart';
import 'package:apartmate/core/theme/app_theme.dart';
import 'package:apartmate/core/services/app_notification_service.dart';
import 'package:apartmate/routes/app_pages.dart';
import 'package:apartmate/routes/app_routes.dart';
import 'package:apartmate/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Local Notifications
  await AppNotificationService.init();

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
        // Precache logo image
        precacheImage(const AssetImage('assets/images/logo.png'), context);
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
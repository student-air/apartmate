import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/utils/validators.dart';
import 'package:apartmate/domain/repositories/i_auth_repository.dart';
import 'package:apartmate/routes/app_routes.dart';
import 'package:apartmate/core/utils/app_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';

class AuthController extends GetxController {
  final IAuthRepository _authRepository;
  AuthController(this._authRepository);

  // Login form
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final isPasswordVisible = false.obs;

  // Signup form
  final fullNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final signupPasswordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();
  final isSignupPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isResettingPassword = false.obs;

  final isLoading = false.obs;
  final loginShakeTrigger = 0.obs;
  final loginError = RxnString();

  final signupShakeTrigger = 0.obs;
  final emailError = RxnString();
  final phoneError = RxnString();

  @override
  void onInit() {
    super.onInit();
    emailCtrl.addListener(() => emailError.value = null);
    phoneCtrl.addListener(() => phoneError.value = null);
  }

  void togglePasswordVisibility() => isPasswordVisible.toggle();
  void toggleSignupPasswordVisibility() => isSignupPasswordVisible.toggle();
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.toggle();

  Future<void> login() async {
    if (usernameCtrl.text.trim().isEmpty || passwordCtrl.text.trim().isEmpty) {
      loginError.value = 'Please enter your username and password';
      loginShakeTrigger.value++;
      return;
    }
    isLoading.value = true;
    try {
      await _authRepository.login(username: usernameCtrl.text.trim(), password: passwordCtrl.text);
      loginError.value = null;
      Get.offAllNamed(AppRoutes.dashboard);
    } catch (_) {
      loginError.value = 'Incorrect username or password';
      loginShakeTrigger.value++;
    } finally {
      isLoading.value = false;
    }
  }

//   Future<void> loginWithGoogle() async {
//   isLoading.value = true;
//   try {
//     await _authRepository.loginWithGoogle();
//     Get.offAllNamed(AppRoutes.dashboard);
//   } catch (e) {
//     final msg = e.toString();
//     if (!msg.contains('aborted-by-user') && !msg.contains('canceled')) {
//       AppSnackbar.error('Google sign-in failed', 'Please try again');
//     }
//   } finally {
//     isLoading.value = false;
//   }
// }

Future<void> loginWithGoogle() async {
  isLoading.value = true;
  try {
    final result = await _authRepository.loginWithGoogle();
    final isNew = result.isNewUser;

    if (isNew) {
      Get.offAllNamed(AppRoutes.societyRegister);
      return;
    }

    final society = await Get.find<ISocietyRepository>().getCurrentSociety();
    if (society == null) {
      Get.offAllNamed(AppRoutes.societyRegister);
      return;
    }

    Get.offAllNamed(AppRoutes.dashboard);
  } catch (e) {
    if (e is FirebaseAuthException && e.code == 'aborted-by-user') return;
    AppSnackbar.error('Google sign-in failed', e.toString());
  } finally {
    isLoading.value = false;
  }
}

  Future<void> loginWithApple() async {
    isLoading.value = true;
    try {
      await _authRepository.loginWithApple();
      Get.offAllNamed(AppRoutes.dashboard);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUpWithGoogle() async {
  isLoading.value = true;
  try {
    await _authRepository.loginWithGoogle();
    // Same flow as email Register → handoff → society register
    Get.offNamed(AppRoutes.signupHandoff, arguments: 'Google');
  } catch (e) {
    final msg = e.toString();
    if (!msg.contains('aborted-by-user') &&
        !msg.contains('canceled') &&
        !msg.contains('cancelled')) {
      AppSnackbar.error('Google sign-in failed', 'Please try again');
    }
  } finally {
    isLoading.value = false;
  }
}

  Future<void> signUpWithApple() async {
    isLoading.value = true;
    try {
      await _authRepository.loginWithApple();
      Get.offNamed(AppRoutes.signupHandoff, arguments: 'Apple');
    } finally {
      isLoading.value = false;
    }
  }
  

Future<void> forgotPassword() async {
  final emailCtrl = TextEditingController(text: usernameCtrl.text.trim());
  final result = await Get.dialog<String>(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Reset password', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            const Text(
              'Enter the email for your account. We\'ll send a reset link.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'you@gmail.com',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Get.back(result: emailCtrl.text.trim()),
                child: const Text('Send reset link'),
              ),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    ),
  );

  if (result == null || result.isEmpty) return;

  isResettingPassword.value = true;
  try {
    await _authRepository.sendPasswordResetEmail(result);
    AppSnackbar.success('Email sent', 'Check $result for a password reset link');
  } catch (e) {
    AppSnackbar.error('Reset failed', e.toString());
  } finally {
    isResettingPassword.value = false;
  }
}
  Future<void> signUp() async {
    if (fullNameCtrl.text.trim().isEmpty ||
        emailCtrl.text.trim().isEmpty ||
        phoneCtrl.text.trim().isEmpty ||
        signupPasswordCtrl.text.isEmpty) {
      signupShakeTrigger.value++;
      AppSnackbar.error('Missing info', 'Please fill in all required fields');
      return;
    }
    if (!Validators.isValidEmail(emailCtrl.text)) {
      emailError.value = 'Enter a valid email address';
      return;
    }
    if (!Validators.isValidPhone(phoneCtrl.text)) {
      phoneError.value = 'Use format 03XXXXXXXXX or +92 3XX XXXXXXX';
      return;
    }
    if (signupPasswordCtrl.text != confirmPasswordCtrl.text) {
      AppSnackbar.error('Password mismatch', 'Passwords do not match');
      return;
    }
    final passwordError = Validators.passwordErrorMessage(signupPasswordCtrl.text);
    if (passwordError != null) {
      AppSnackbar.error('Weak password', passwordError);
      return;
    }
    isLoading.value = true;
    try {
      await _authRepository.signUp(
        fullName: fullNameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        password: signupPasswordCtrl.text,
      );
      Get.toNamed(AppRoutes.signupHandoff, arguments: 'Email');
    } finally {
      isLoading.value = false;
    }
  }

  void goToSignup() => Get.toNamed(AppRoutes.signup);
  void goToLogin() => Get.back();

  @override
  void onClose() {
    usernameCtrl.dispose();
    passwordCtrl.dispose();
    fullNameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    signupPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }
}
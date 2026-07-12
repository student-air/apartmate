import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/domain/repositories/i_auth_repository.dart';
import 'package:apartmate/routes/app_routes.dart';
import 'package:apartmate/core/utils/validators.dart';

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

  final isLoading = false.obs;

  void togglePasswordVisibility() => isPasswordVisible.toggle();
  void toggleSignupPasswordVisibility() => isSignupPasswordVisible.toggle();
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.toggle();

  Future<void> login() async {
    if (usernameCtrl.text.trim().isEmpty || passwordCtrl.text.trim().isEmpty) {
      Get.snackbar('Missing info', 'Please enter your username and password');
      return;
    }
    isLoading.value = true;
    try {
      await _authRepository.login(username: usernameCtrl.text.trim(), password: passwordCtrl.text);
      Get.offAllNamed(AppRoutes.dashboard);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
    isLoading.value = true;
    try {
      await _authRepository.loginWithGoogle();
      Get.offAllNamed(AppRoutes.dashboard);
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

  Future<void> signUp() async {
    if (fullNameCtrl.text.trim().isEmpty ||
        emailCtrl.text.trim().isEmpty ||
        phoneCtrl.text.trim().isEmpty ||
        signupPasswordCtrl.text.isEmpty) {
      Get.snackbar('Missing info', 'Please fill in all required fields');
      return;
    }
    if (signupPasswordCtrl.text != confirmPasswordCtrl.text) {
      Get.snackbar('Password mismatch', 'Passwords do not match');
      return;
    }
    final passwordError = Validators.passwordErrorMessage(signupPasswordCtrl.text);
    if (passwordError != null) {
      Get.snackbar('Weak password', passwordError);
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
      Get.toNamed(AppRoutes.signup); // placeholder — updated once society_register exists
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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/utils/validators.dart';
import 'package:apartmate/domain/repositories/i_auth_repository.dart';
import 'package:apartmate/routes/app_routes.dart';
import 'package:apartmate/core/utils/app_snackbar.dart';

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

  Future<void> signUpWithGoogle() async {
    isLoading.value = true;
    try {
      await _authRepository.loginWithGoogle();
      Get.toNamed(AppRoutes.societyRegister);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUpWithApple() async {
    isLoading.value = true;
    try {
      await _authRepository.loginWithApple();
      Get.toNamed(AppRoutes.societyRegister);
    } finally {
      isLoading.value = false;
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
      Get.toNamed(AppRoutes.societyRegister);
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
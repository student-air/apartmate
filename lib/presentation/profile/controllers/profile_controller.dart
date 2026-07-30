import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/data/models/user_model.dart';
import 'package:apartmate/domain/repositories/i_auth_repository.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';
import 'package:apartmate/core/constants/app_strings.dart';
import 'package:apartmate/routes/app_routes.dart';
import 'package:apartmate/core/widgets/notification_preferences_sheet.dart';
import 'package:apartmate/core/widgets/privacy_security_sheet.dart';
import 'package:apartmate/core/widgets/help_support_sheet.dart';
import 'package:apartmate/core/utils/app_snackbar.dart';
import 'package:apartmate/core/widgets/terms_of_service_sheet.dart';
import 'package:apartmate/core/services/app_notification_service.dart';
import 'package:apartmate/core/utils/app_snackbar.dart';

class ProfileController extends GetxController {
  final IAuthRepository _authRepository;
  final ISocietyRepository _societyRepository;
  ProfileController(this._authRepository, this._societyRepository);

  UserModel? get user => _authRepository.currentUser;

  final ownerName = ''.obs;
  String get fullName => ownerName.value.isEmpty ? (user?.fullName ?? 'Guest') : ownerName.value;
  String get initials {
    final name = ownerName.value.isNotEmpty ? ownerName.value : (user?.fullName ?? '');
    if (name.trim().isEmpty) return '?';
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    
    return (first + last).toUpperCase();
  }

  String get email {
    final value = user?.email ?? '';
    return value.isEmpty ? AppStrings.emailHint : value;
  }

  String get phone {
    final value = user?.phone ?? '';
    return value.isEmpty ? AppStrings.phoneHint : value;
  }

  String get role => user?.role ?? '';

  final societyName = ''.obs;
  final societyAddress = ''.obs;
  final isLoading = false.obs;
  final ownerPhotoPath = Rxn<String>();
  final societyContactNumber = ''.obs;

  // ── Notification Preferences state ──
  final notifyUpdates = true.obs;
  final notifyComplaints = true.obs;
  final notifyRequests = true.obs;
  final notifySound = false.obs;

  // ── Privacy & Security state ──
  final biometricLoginEnabled = false.obs;
  final currentPasswordCtrl = TextEditingController();
  final newPasswordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();
  final isChangingPassword = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSociety();
  }

  Future<void> _loadSociety() async {
    isLoading.value = true;
    try {
      final society = await _societyRepository.getCurrentSociety();
      societyName.value = society?.name ?? '';
      societyAddress.value = society != null ? '${society.address}, ${society.city}' : '';
      ownerPhotoPath.value = society?.ownerPhotoPath;
      ownerName.value = society?.ownerName ?? '';
      societyContactNumber.value = society?.contactNumber ?? '';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshSociety() => _loadSociety();

  void goToEditProfile() => Get.toNamed(AppRoutes.editProfile);

  // ── Menu actions ──
  void openNotificationPreferences() => showNotificationPreferencesSheet();
  void openPrivacyAndSecurity() => showPrivacySecuritySheet();
  void openHelpAndSupport() => showHelpSupportSheet();
  void openTermsOfService() => showTermsOfServiceSheet();

  void toggleBiometricLogin(bool value) {
    biometricLoginEnabled.value = value;
    AppSnackbar.info(
      value ? 'Biometric login enabled' : 'Biometric login disabled',
      value ? 'You can now sign in with fingerprint or face unlock' : 'Password will be required to sign in',
    );
  }

  Future<void> changePassword() async {
    if (currentPasswordCtrl.text.trim().isEmpty ||
        newPasswordCtrl.text.trim().isEmpty ||
        confirmPasswordCtrl.text.trim().isEmpty) {
      AppSnackbar.error('Missing info', 'Please fill in all password fields');
      return;
    }
    if (newPasswordCtrl.text.trim().length < 8) {
      AppSnackbar.error('Weak password', 'New password must be at least 8 characters');
      return;
    }
    if (newPasswordCtrl.text.trim() != confirmPasswordCtrl.text.trim()) {
      AppSnackbar.error('Mismatch', 'New password and confirmation don\'t match');
      return;
    }

    isChangingPassword.value = true;
    try {
      // No real backend yet — this simulates the request.
      await Future.delayed(const Duration(milliseconds: 600));
      currentPasswordCtrl.clear();
      newPasswordCtrl.clear();
      confirmPasswordCtrl.clear();
      Get.back();
      AppSnackbar.success('Password updated', 'Your password has been changed successfully');
    } finally {
      isChangingPassword.value = false;
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    Get.offAllNamed(AppRoutes.login);
  }

  void confirmLogout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You will need to sign in again to access your account.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              logout();
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  Future<void> sendPasswordResetLink() async {
    final email = user?.email ?? '';
    if (email.isEmpty) {
      Get.snackbar('No email on file', 'Add an email to your profile first');
      return;
    }
    // No real backend yet — simulates sending the reset email.
    await Future.delayed(const Duration(milliseconds: 500));
    AppSnackbar.info('Reset link sent', 'Check $email for a password reset link');
  }

  Future<void> setNotifyUpdates(bool value) async {
    if (value && !await AppNotificationService.hasPermission()) {
      final granted = await AppNotificationService.requestPermission();
      if (!granted) {
        AppSnackbar.error('Permission denied', 'Enable notifications in device settings to receive alerts');
        return;
      }
    }
    notifyUpdates.value = value;
  }

  Future<void> setNotifyComplaints(bool value) async {
    if (value && !await AppNotificationService.hasPermission()) {
      final granted = await AppNotificationService.requestPermission();
      if (!granted) {
        AppSnackbar.error('Permission denied', 'Enable notifications in device settings to receive alerts');
        return;
      }
    }
    notifyComplaints.value = value;
  }

  Future<void> setNotifyRequests(bool value) async {
    if (value && !await AppNotificationService.hasPermission()) {
      final granted = await AppNotificationService.requestPermission();
      if (!granted) {
        AppSnackbar.error('Permission denied', 'Enable notifications in device settings to receive alerts');
        return;
      }
    }
    notifyRequests.value = value;
  }

  void setNotifySound(bool value) => notifySound.value = value;

  @override
  void onClose() {
    currentPasswordCtrl.dispose();
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }
}
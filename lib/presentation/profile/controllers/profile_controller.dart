import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/data/models/user_model.dart';
import 'package:apartmate/domain/repositories/i_auth_repository.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';
import 'package:apartmate/routes/app_routes.dart';
import 'package:apartmate/core/utils/app_snackbar.dart ';

class ProfileController extends GetxController {
  final IAuthRepository _authRepository;
  final ISocietyRepository _societyRepository;
  final ownerName = ''.obs;
  ProfileController(this._authRepository, this._societyRepository);

  UserModel? get user => _authRepository.currentUser;

  String get fullName {
  if (ownerName.value.trim().isNotEmpty) return ownerName.value.trim();
  return user?.fullName ?? 'Guest';
}
  String get initials {
  final name = ownerName.value.trim();
  if (name.isEmpty) return user?.initials ?? '?';
  final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
  final first = parts.first[0];
  final last = parts.length > 1 ? parts.last[0] : '';
  return (first + last).toUpperCase();
}
  String get email => user?.email ?? '';
  String get phone => user?.phone ?? '';
  String get role => user?.role ?? '';

  final societyName = ''.obs;
  final societyAddress = ''.obs;
  final isLoading = false.obs;
  final ownerPhotoPath = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    _loadSociety();
  }

  @override
  void onReady() {
    super.onReady();
    _loadSociety();
}

  Future<void> _loadSociety() async {
    isLoading.value = true;
    try {
      final society = await _societyRepository.getCurrentSociety();
      ownerName.value = society?.ownerName ?? '';
      societyName.value = society?.name ?? '';
      societyAddress.value = society != null ? '${society.address}, ${society.city}' : '';
      ownerPhotoPath.value = society?.ownerPhotoPath;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshSociety() => _loadSociety();

  void goToEditProfile() => Get.toNamed(AppRoutes.editProfile);

  void showComingSoon(String feature) {
    AppSnackbar.info('Coming soon', '$feature isn\'t available yet');
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
}
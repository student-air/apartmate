import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/data/models/user_model.dart';
import 'package:apartmate/domain/repositories/i_auth_repository.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';
import 'package:apartmate/routes/app_routes.dart';

class ProfileController extends GetxController {
  final IAuthRepository _authRepository;
  final ISocietyRepository _societyRepository;
  ProfileController(this._authRepository, this._societyRepository);

  UserModel? get user => _authRepository.currentUser;

  String get initials => user?.initials ?? '?';
  String get fullName => user?.fullName ?? 'Guest';
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

  Future<void> _loadSociety() async {
    isLoading.value = true;
    try {
      final society = await _societyRepository.getCurrentSociety();
      societyName.value = society?.name ?? '';
      societyAddress.value = society != null ? '${society.address}, ${society.city}' : '';
      ownerPhotoPath.value = society?.ownerPhotoPath;
    } finally {
      isLoading.value = false;
    }
  }

  void goToEditProfile() => Get.toNamed(AppRoutes.editProfile);

  void showComingSoon(String feature) {
    Get.snackbar('Coming soon', '$feature isn\'t available yet');
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
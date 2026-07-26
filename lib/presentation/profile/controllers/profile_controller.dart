// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:apartmate/data/models/user_model.dart';
// import 'package:apartmate/domain/repositories/i_auth_repository.dart';
// import 'package:apartmate/domain/repositories/i_society_repository.dart';
// import 'package:apartmate/routes/app_routes.dart';
// import 'package:apartmate/core/utils/app_snackbar.dart ';

// class ProfileController extends GetxController {
//   final IAuthRepository _authRepository;
//   final ISocietyRepository _societyRepository;
//   final ownerName = ''.obs;
//   ProfileController(this._authRepository, this._societyRepository);

//   UserModel? get user => _authRepository.currentUser;

//   String get fullName {
//   if (ownerName.value.trim().isNotEmpty) return ownerName.value.trim();
//   return user?.fullName ?? 'Guest';
// }
//   String get initials {
//   final name = ownerName.value.trim();
//   if (name.isEmpty) return user?.initials ?? '?';
//   final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
//   final first = parts.first[0];
//   final last = parts.length > 1 ? parts.last[0] : '';
//   return (first + last).toUpperCase();
// }
//   String get email => user?.email ?? '';
//   String get phone => user?.phone ?? '';
//   String get role => user?.role ?? '';

//   final societyName = ''.obs;
//   final societyAddress = ''.obs;
//   final isLoading = false.obs;
//   final ownerPhotoPath = Rxn<String>();

//   @override
//   void onInit() {
//     super.onInit();
//     _loadSociety();
//   }

//   @override
//   void onReady() {
//     super.onReady();
//     _loadSociety();
// }

//   Future<void> _loadSociety() async {
//     isLoading.value = true;
//     try {
//       final society = await _societyRepository.getCurrentSociety();
//       ownerName.value = society?.ownerName ?? '';
//       societyName.value = society?.name ?? '';
//       societyAddress.value = society != null ? '${society.address}, ${society.city}' : '';
//       ownerPhotoPath.value = society?.ownerPhotoPath;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> refreshSociety() => _loadSociety();

//   void goToEditProfile() => Get.toNamed(AppRoutes.editProfile);

//   void showComingSoon(String feature) {
//     AppSnackbar.info('Coming soon', '$feature isn\'t available yet');
//   }

//   Future<void> logout() async {
//     await _authRepository.logout();
//     Get.offAllNamed(AppRoutes.login);
//   }

//   void confirmLogout() {
//     Get.dialog(
//       AlertDialog(
//         title: const Text('Log out?'),
//         content: const Text('You will need to sign in again to access your account.'),
//         actions: [
//           TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
//           TextButton(
//             onPressed: () {
//               Get.back();
//               logout();
//             },
//             child: const Text('Log Out'),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/data/models/user_model.dart';
import 'package:apartmate/domain/repositories/i_auth_repository.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';
import 'package:apartmate/core/constants/app_strings.dart';
import 'package:apartmate/routes/app_routes.dart';

class ProfileController extends GetxController {
  final IAuthRepository _authRepository;
  final ISocietyRepository _societyRepository;
  ProfileController(this._authRepository, this._societyRepository);

  UserModel? get user => _authRepository.currentUser;

  // Name/initials now come from the registered society's owner name (kept
  // in sync with whatever's edited via the Edit Society sheet), instead of
  // the logged-in account's name, which never changes when society details
  // are edited.
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

  // Show the expected format as a placeholder when nothing's been entered,
  // instead of a bare "—".
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
    } finally {
      isLoading.value = false;
    }
  }

  /// Call after editing society details so this screen reflects the change
  /// immediately, same as DashboardController.refreshSociety().
  Future<void> refreshSociety() => _loadSociety();

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
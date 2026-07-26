import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:apartmate/core/utils/app_snackbar.dart';
import 'package:apartmate/core/utils/validators.dart';
import 'package:apartmate/data/models/user_model.dart';
import 'package:apartmate/domain/repositories/i_auth_repository.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';
import 'package:apartmate/presentation/profile/controllers/profile_controller.dart';

class EditProfileController extends GetxController {
  final IAuthRepository _authRepository;
  final ISocietyRepository _societyRepository;
  EditProfileController(this._authRepository, this._societyRepository);

  static const int maxPhotoSizeBytes = 3 * 1024 * 1024; // 3MB

  final ownerNameCtrl = TextEditingController();
  final fullNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  final photo = Rxn<File>();
  final isSaving = false.obs;
  final isLoading = false.obs;
  final shakeTrigger = 0.obs;

  UserModel? get _current => _authRepository.currentUser;

  @override
  void onInit() {
    super.onInit();
    _prefill();
  }

  Future<void> _prefill() async {
    final user = _current;
    if (user != null) {
      fullNameCtrl.text = user.fullName;
      emailCtrl.text = user.email;
      phoneCtrl.text = user.phone;
      if (user.photoPath != null && user.photoPath!.isNotEmpty) {
        photo.value = File(user.photoPath!);
      }
    }

    isLoading.value = true;
    try {
      final society = await _societyRepository.getCurrentSociety();
      ownerNameCtrl.text = society?.ownerName ?? '';
      if (photo.value == null && society?.ownerPhotoPath != null && society!.ownerPhotoPath!.isNotEmpty) {
        photo.value = File(society.ownerPhotoPath!);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickPhoto() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked == null) return;
    final file = File(picked.path);
    final sizeInBytes = await file.length();
    if (sizeInBytes > maxPhotoSizeBytes) {
      AppSnackbar.error('File too large', 'Photo must be under 3MB');
      return;
    }
    photo.value = file;
  }

  Future<void> save() async {
    if (ownerNameCtrl.text.trim().isEmpty ||
        fullNameCtrl.text.trim().isEmpty ||
        emailCtrl.text.trim().isEmpty ||
        phoneCtrl.text.trim().isEmpty) {
      shakeTrigger.value++;
      AppSnackbar.error('Missing info', 'Please fill in all fields');
      return;
    }
    final emailError = Validators.emailErrorMessage(emailCtrl.text);
    if (emailError != null) {
      shakeTrigger.value++;
      AppSnackbar.error('Invalid email', emailError);
      return;
    }
    final phoneError = Validators.phoneErrorMessage(phoneCtrl.text);
    if (phoneError != null) {
      shakeTrigger.value++;
      AppSnackbar.error('Invalid phone', phoneError);
      return;
    }

    final current = _current;
    if (current == null) return;

    isSaving.value = true;
    try {
      await _authRepository.updateProfile(
        current.copyWith(
          fullName: fullNameCtrl.text.trim(),
          email: emailCtrl.text.trim(),
          phone: phoneCtrl.text.trim(),
          photoPath: photo.value?.path,
        ),
      );

      await _societyRepository.updateOwnerProfile(
        ownerName: ownerNameCtrl.text.trim(),
        ownerPhotoPath: photo.value?.path,
      );

      if (Get.isRegistered<ProfileController>()) {
        await Get.find<ProfileController>().refreshSociety();
      }

      Get.back();
      AppSnackbar.success('Saved', 'Profile updated successfully');
    } catch (e, st) {
      debugPrint('EditProfileController.save() failed: $e\n$st');
      AppSnackbar.error('Save failed', e.toString());
    } finally {
      isSaving.value = false;
    }
  }
  @override
  void onClose() {
    ownerNameCtrl.dispose();
    fullNameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    super.onClose();
  }
}
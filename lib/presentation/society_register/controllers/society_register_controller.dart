import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:apartmate/data/models/society_model.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';
import 'package:apartmate/routes/app_routes.dart';
import 'package:apartmate/core/utils/app_snackbar.dart';



class SocietyRegisterController extends GetxController {
  final ISocietyRepository _societyRepository;
  static const int maxPictures = 3;
  static const int maxFileSizeBytes = 3 * 1024 * 1024; // 3MB

  SocietyRegisterController(this._societyRepository);

  final societyNameCtrl = TextEditingController();
  final ownerNameCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final contactCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final societyPictures = <File>[].obs;

  final countries = const ['Pakistan', 'UAE', 'Saudi Arabia', 'USA'];
  final selectedCountry = 'Pakistan'.obs;

  final cities = const ['Karachi', 'Lahore', 'Islamabad', 'Multan', 'Rawalpindi'];
  final selectedCity = 'Islamabad'.obs;
  final ownerPhoto = Rxn<File>();
  final isSubmitting = false.obs;

  Future<void> pickOwnerPhoto() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked == null) return;
    final file = File(picked.path);
    final sizeInBytes = await file.length();
    if (sizeInBytes > maxFileSizeBytes) {
      AppSnackbar.error('File too large', 'Owner photo must be under 3MB');
      return;
    }
    ownerPhoto.value = file;
  }

  void setCountry(String? value) {
    if (value != null) selectedCountry.value = value;
  }

  Future<void> submit() async {
    if (societyNameCtrl.text.trim().isEmpty || ownerNameCtrl.text.trim().isEmpty) {
      AppSnackbar.info('Missing info', 'Please fill in the required fields');
      return;
    }
    isSubmitting.value = true;
    try {
      await _societyRepository.registerSociety(
        SocietyModel(
          id: 'society-${DateTime.now().millisecondsSinceEpoch}',
          name: societyNameCtrl.text.trim(),
          ownerName: ownerNameCtrl.text.trim(),
          address: addressCtrl.text.trim(),
          city: cityCtrl.text.trim(),
          country: selectedCountry.value,
          contactNumber: contactCtrl.text.trim(),
          description: descriptionCtrl.text.trim(),
          submittedAt: DateTime.now(),
        ),
      );
      Get.toNamed(AppRoutes.registrationStatus);
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    societyNameCtrl.dispose();
    ownerNameCtrl.dispose();
    addressCtrl.dispose();
    cityCtrl.dispose();
    contactCtrl.dispose();
    descriptionCtrl.dispose();
    super.onClose();
  }
}

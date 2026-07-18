import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:apartmate/data/models/society_model.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';
import 'package:apartmate/routes/app_routes.dart';
import 'package:apartmate/core/utils/app_snackbar.dart';
import 'package:apartmate/core/utils/validators.dart';



class SocietyRegisterController extends GetxController {
  final ISocietyRepository _societyRepository;

  static const int maxFileSizeBytes = 3 * 1024 * 1024; // 3MB

  SocietyRegisterController(this._societyRepository);

  final societyNameCtrl = TextEditingController();
  final ownerNameCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final contactCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();

  final selectedCountry = ''.obs;
  final selectedState = ''.obs;
  final selectedCity = ''.obs;

  void setCountry(String value) => selectedCountry.value = value;
  void setState(String value) => selectedState.value = value;
  void setCity(String value) => selectedCity.value = value;

  final ownerPhoto = Rxn<File>();
  final isSubmitting = false.obs;

  Future<void> pickOwnerPhotoFromCamera() => _pickFrom(ImageSource.camera);
  Future<void> pickOwnerPhotoFromGallery() => _pickFrom(ImageSource.gallery);

  Future<void> _pickFrom(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source, imageQuality: 85);
    if (picked == null) return;
    final file = File(picked.path);
    final sizeInBytes = await file.length();
    if (sizeInBytes > maxFileSizeBytes) {
      AppSnackbar.error('File too large', 'Owner photo must be under 3MB');
    return;
  }
    ownerPhoto.value = file;
}

  Future<void> submit() async {
    if (societyNameCtrl.text.trim().isEmpty ||
        ownerNameCtrl.text.trim().isEmpty ||
        addressCtrl.text.trim().isEmpty ||
        contactCtrl.text.trim().isEmpty ||
        selectedCountry.value.isEmpty ) {
      AppSnackbar.info('Missing info', 'Please fill in all required fields');
      return;
    }
    if (!Validators.isValidPhone(contactCtrl.text)) {
      AppSnackbar.info('Invalid phone', 'Use format 03XXXXXXXXX or\n+92 3XX XXXXXXX');
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
          city: selectedCity.value,
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

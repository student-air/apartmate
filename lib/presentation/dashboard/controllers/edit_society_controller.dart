import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/data/models/society_model.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';
import 'package:apartmate/core/utils/app_snackbar.dart';
import 'package:apartmate/core/utils/validators.dart';
import 'package:apartmate/presentation/dashboard/controllers/dashboard_controller.dart';

/// Backs the "Edit Society" bottom sheet opened from the Dashboard.
/// Unlike [SocietyRegisterController] (full-screen, used for the initial
/// registration), this one never navigates — it just saves and closes,
/// then tells the Dashboard to refresh so the header updates immediately.
class EditSocietyController extends GetxController {
  final ISocietyRepository _societyRepository;
  EditSocietyController(this._societyRepository);

  final societyNameCtrl = TextEditingController();
  final ownerNameCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final contactCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();

  final selectedCountry = ''.obs;
  final selectedState = ''.obs;
  final selectedCity = ''.obs;

  final isLoading = true.obs; // true while the existing society is being fetched
  final isSaving = false.obs;
  final shakeTrigger = 0.obs;
  final phoneError = RxnString();

  SocietyModel? _original;

  void setCountry(String value) => selectedCountry.value = value;
  void setState(String value) => selectedState.value = value;
  void setCity(String value) => selectedCity.value = value;

  /// What to show under the picker: the newly picked city/country if the
  /// person touched the picker, otherwise whatever was already saved.
  String get currentLocationLabel {
    final city = selectedCity.value.isNotEmpty ? selectedCity.value : (_original?.city ?? '');
    final country = selectedCountry.value.isNotEmpty ? selectedCountry.value : (_original?.country ?? '');
    final parts = [city, country].where((s) => s.isNotEmpty);
    return parts.isEmpty ? 'Not set' : parts.join(', ');
  }

  @override
  void onInit() {
    super.onInit();
    _prefill();
    contactCtrl.addListener(() => phoneError.value = null);
  }

  Future<void> _prefill() async {
    isLoading.value = true;
    final existing = await _societyRepository.getCurrentSociety();
    _original = existing;
    if (existing != null) {
      societyNameCtrl.text = existing.name;
      ownerNameCtrl.text = existing.ownerName;
      addressCtrl.text = existing.address;
      contactCtrl.text = existing.contactNumber;
      descriptionCtrl.text = existing.description ?? '';
    }
    isLoading.value = false;
  }

  Future<void> save() async {
    if (societyNameCtrl.text.trim().isEmpty ||
        ownerNameCtrl.text.trim().isEmpty ||
        addressCtrl.text.trim().isEmpty ||
        contactCtrl.text.trim().isEmpty) {
      shakeTrigger.value++;
      AppSnackbar.info('Missing info', 'Please fill in all required fields');
      return;
    }
    if (!Validators.isValidPhone(contactCtrl.text)) {
      phoneError.value = 'Use format 03XXXXXXXXX or +92 3XX XXXXXXX';
      return;
    }

    isSaving.value = true;
    try {
      await _societyRepository.registerSociety(
        SocietyModel(
          id: _original?.id ?? 'society-${DateTime.now().millisecondsSinceEpoch}',
          name: societyNameCtrl.text.trim(),
          ownerName: ownerNameCtrl.text.trim(),
          address: addressCtrl.text.trim(),
          // country/state/city pickers don't support an initial value, so if
          // the person didn't touch them, keep whatever was already saved.
          city: selectedCity.value.isNotEmpty ? selectedCity.value : (_original?.city ?? ''),
          country: selectedCountry.value.isNotEmpty ? selectedCountry.value : (_original?.country ?? ''),
          contactNumber: contactCtrl.text.trim(),
          description: descriptionCtrl.text.trim(),
          registrationStatus: _original?.registrationStatus ?? SocietyRegistrationStatus.approved,
          submittedAt: _original?.submittedAt ?? DateTime.now(),
        ),
      );

      if (Get.isRegistered<DashboardController>()) {
        await Get.find<DashboardController>().refreshSociety();
      }

      FocusManager.instance.primaryFocus?.unfocus();
      Get.back(); // close the sheet
      AppSnackbar.success('Saved', 'Society details updated');
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    societyNameCtrl.dispose();
    ownerNameCtrl.dispose();
    addressCtrl.dispose();
    contactCtrl.dispose();
    descriptionCtrl.dispose();
    super.onClose();
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/utils/app_snackbar.dart';
import 'package:apartmate/presentation/updates/controllers/updates_badge_controller.dart';
import 'package:apartmate/data/models/society_model.dart';
import 'package:apartmate/data/models/update_model.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';
import 'package:apartmate/domain/repositories/i_update_repository.dart';
import 'package:apartmate/core/services/app_notification_service.dart';
import 'package:apartmate/presentation/profile/controllers/profile_controller.dart';

/// Backs the "Send Notice" bottom sheet, opened from the '+' FAB.
class SendUpdateController extends GetxController {
  final IUpdateRepository _updateRepository;
  final ISocietyRepository _societyRepository;
  SendUpdateController(this._updateRepository, this._societyRepository);

  static const Map<String, UpdateType> presets = {
    'Maintenance Alert': UpdateType.general,
    'Security Alert': UpdateType.general,
    'General Notice': UpdateType.general,
    'Announcement': UpdateType.announcement,
  };

  static const sendToOptions = ['All', 'Building', 'Floor', 'Flat'];

  final descriptionCtrl = TextEditingController();
  final flatNumberCtrl = TextEditingController();

  final selectedPreset = 'Maintenance Alert'.obs;
  final sendTo = 'All'.obs;

  // Cascading selection state
  final buildings = <BuildingModel>[].obs;
  final selectedBuilding = Rxn<BuildingModel>();
  final selectedFloor = Rxn<int>();
  final isLoadingBuildings = false.obs;

  final isSending = false.obs;
  final shakeTrigger = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadBuildings();
  }

  /// Prefills the sheet for a specific flat — used when opened from a
  /// Resident card. Waits for buildings to finish loading (if still in
  /// flight) so the building/floor lookups below don't race the initial
  /// _loadBuildings() call from onInit(). 
  // Future<void> prefillForFlat({
  //   required String buildingName,
  //   required int floor,
  //   required String flatNumber,
  // }) async {
  //   while (isLoadingBuildings.value) {
  //     await Future.delayed(const Duration(milliseconds: 50));
  //   }
  //   sendTo.value = 'Flat';
  //   final match = buildings.firstWhereOrNull((b) => b.name == buildingName);
  //   selectedBuilding.value = match;
  //   selectedFloor.value = floor;
  //   flatNumberCtrl.text = flatNumber;
  // }

  final isLocationLocked = false.obs;

  Future<void> prefillForFlat({
    required String buildingName,
    required int floor,
    required String flatNumber,
  }) async {
    while (isLoadingBuildings.value) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    sendTo.value = 'Flat';
    final match = buildings.firstWhereOrNull((b) => b.name == buildingName);
    selectedBuilding.value = match;
    selectedFloor.value = floor;
    flatNumberCtrl.text = flatNumber;
    isLocationLocked.value = true;
  }

  Future<void> _loadBuildings() async {
    isLoadingBuildings.value = true;
    try {
      final result = await _societyRepository.getBuildings();
      buildings.assignAll(result);
    } finally {
      isLoadingBuildings.value = false;
    }
  }

  /// Floors available for the currently selected building, based on that
  /// building's configured "Total Floors" (from Building Detail setup).
  /// 0 represents Ground Floor, so a building with e.g. 3 total floors
  /// yields [0, 1, 2] -> "Ground Floor", "1st Floor", "2nd Floor" — one
  /// dropdown entry per floor actually entered at registration.
  List<int> get availableFloors {
    final total = selectedBuilding.value?.details?.totalFloors ?? 0;
    return List.generate(total, (i) => i);
  }

  /// Human-readable label for a floor value from [availableFloors].
  static String floorLabel(int floor) {
    if (floor == 0) return 'Ground Floor';
    return '$floor${_ordinalSuffix(floor)} Floor';
  }

  static String _ordinalSuffix(int n) {
    if (n % 100 >= 11 && n % 100 <= 13) return 'th';
    switch (n % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  void setPreset(String value) => selectedPreset.value = value;

  void setSendTo(String value) {
    sendTo.value = value;
    // Reset downstream selections whenever the audience type changes.
    selectedBuilding.value = null;
    selectedFloor.value = null;
    flatNumberCtrl.clear();
  }

  void setBuilding(BuildingModel? building) {
    selectedBuilding.value = building;
    selectedFloor.value = null; // reset floor when building changes
    flatNumberCtrl.clear();
  }

  void setFloor(int? floor) => selectedFloor.value = floor;

  void addAttachment() {
    AppSnackbar.info('Coming soon', 'Attachments aren\'t supported yet');
  }

  Future<void> send() async {
    if (descriptionCtrl.text.trim().isEmpty) {
      shakeTrigger.value++;
      AppSnackbar.info('Missing info', 'Please fill in the description');
      return;
    }

    isSending.value = true;
    try {
      await _updateRepository.addUpdate(
        UpdateModel(
          id: 'update-${DateTime.now().millisecondsSinceEpoch}',
          type: presets[selectedPreset.value] ?? UpdateType.general,
          title: selectedPreset.value,
          category: selectedPreset.value,
          description: descriptionCtrl.text.trim(),
          postedAt: DateTime.now(),
          sendTo: sendTo.value,
          buildingName: selectedBuilding.value?.name,
          floor: selectedFloor.value,
          flatNumber: flatNumberCtrl.text.trim().isEmpty ? null : flatNumberCtrl.text.trim(),
        ),
      );
      if (Get.isRegistered<ProfileController>() && Get.find<ProfileController>().notifyUpdates.value) {
        await AppNotificationService.show(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          title: selectedPreset.value,
          body: descriptionCtrl.text.trim(),
        );
      }
    } finally {
      isSending.value = false;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    await Future.delayed(const Duration(milliseconds: 250));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.back();
      AppSnackbar.success('Sent', 'Your notice has been sent');
      if (Get.isRegistered<UpdatesBadgeController>()) {
        Get.find<UpdatesBadgeController>().increment();
      }
    });
  }

  @override
  void onClose() {
    descriptionCtrl.dispose();
    flatNumberCtrl.dispose();
    super.onClose();
  }
}
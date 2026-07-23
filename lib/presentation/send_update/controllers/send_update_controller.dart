import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/utils/app_snackbar.dart';
import 'package:apartmate/presentation/updates/controllers/updates_badge_controller.dart';
import 'package:apartmate/data/models/society_model.dart';
import 'package:apartmate/data/models/update_model.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';
import 'package:apartmate/domain/repositories/i_update_repository.dart';

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

  final titleCtrl = TextEditingController();
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
    if (titleCtrl.text.trim().isEmpty || descriptionCtrl.text.trim().isEmpty) {
      shakeTrigger.value++;
      AppSnackbar.info('Missing info', 'Please fill in the title and description');
      return;
    }
    if (sendTo.value != 'All' && selectedBuilding.value == null) {
      shakeTrigger.value++;
      AppSnackbar.info('Missing info', 'Please select a building');
      return;
    }
    if (sendTo.value == 'Floor' && selectedFloor.value == null) {
      shakeTrigger.value++;
      AppSnackbar.info('Missing info', 'Please select a floor');
      return;
    }
    if (sendTo.value == 'Flat' && flatNumberCtrl.text.trim().isEmpty) {
      shakeTrigger.value++;
      AppSnackbar.info('Missing info', 'Please enter a flat number');
      return;
    }

    isSending.value = true;
    try {
      await _updateRepository.addUpdate(
        UpdateModel(
          id: 'update-${DateTime.now().millisecondsSinceEpoch}',
          type: presets[selectedPreset.value] ?? UpdateType.general,
          category: selectedPreset.value,
          title: titleCtrl.text.trim(),
          description: descriptionCtrl.text.trim(),
          postedAt: DateTime.now(),
        ),
      );
    } finally {
      // Reset the loading flag — and let its Obx rebuild finish — while the
      // sheet is still fully in the tree. Doing this *after* Get.back() would
      // race the Navigator's teardown of this same route and corrupt the
      // element tree (the red "_dependents.isEmpty" assertion).
      isSending.value = false;
    }

    // Close the keyboard if a field still has focus, and give any
    // in-flight animation — a dropdown menu closing, a ripple, the
    // keyboard itself — real wall-clock time to finish before we tear
    // down this route. A zero-duration delay only defers to the next
    // microtask; it doesn't wait out an actual timed animation, which is
    // why that approach alone didn't stop the crash. 250ms comfortably
    // covers Material's default menu-close/ripple durations.
    FocusManager.instance.primaryFocus?.unfocus();
    await Future.delayed(const Duration(milliseconds: 250));

    // Do the actual pop on the next frame, after Flutter's current
    // build/layout/paint pass is fully done, rather than in the middle
    // of whatever triggered this callback.
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
    titleCtrl.dispose();
    descriptionCtrl.dispose();
    flatNumberCtrl.dispose();
    super.onClose();
  }
}
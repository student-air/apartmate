import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
import 'package:apartmate/core/utils/app_snackbar.dart';
import 'package:apartmate/data/models/owner_model.dart';
import 'package:apartmate/domain/repositories/i_owner_repository.dart';

class OwnersController extends GetxController {
  final IOwnerRepository _repo;
  OwnersController(this._repo);

  final owners = <OwnerModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    try {
      owners.value = await _repo.getOwners();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() => load();

  Future<void> deleteOwner(String ownerId) async {
    await _repo.removeOwner(ownerId);
    owners.value = owners.where((o) => o.id != ownerId).toList();
  }

  void confirmDeleteOwner(OwnerModel owner) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.surface,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Delete owner?',
                style: AppTextStyles.h4,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'This will permanently remove "${owner.name}" from the owners list.',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    Get.back(); // close dialog
                    try {
                      await deleteOwner(owner.id);
                      Get.back(); // leave detail screen
                      AppSnackbar.success('Deleted', '${owner.name} was removed');
                    } catch (e) {
                      AppSnackbar.error('Delete failed', e.toString());
                    }
                  },
                  icon: const Icon(Icons.delete_outline, size: 18, color: Colors.white),
                  label: Text(
                    'Delete',
                    style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.danger,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Cancel',
                  style: AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
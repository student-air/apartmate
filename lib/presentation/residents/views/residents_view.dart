import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
import 'package:apartmate/core/widgets/app_bottom_nav.dart';
import 'package:apartmate/core/widgets/app_responsive_container.dart';
import 'package:apartmate/core/widgets/app_skeletons.dart';
import 'package:apartmate/core/widgets/send_update_sheet.dart';
import 'package:apartmate/data/models/resident_model.dart';
import 'package:apartmate/presentation/residents/controllers/residents_controller.dart';
import 'package:apartmate/routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:apartmate/core/utils/app_snackbar.dart';

class ResidentsView extends GetView<ResidentsController> {
  const ResidentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const _FilterDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AppAddFab(
        onPressed: showSendUpdateSheet,
      ),
      // appBar: AppBar(
      //   backgroundColor: AppColors.primaryDark,
      //   titleSpacing: 0,
      //   iconTheme: const IconThemeData(color: Colors.white),
      //   leading: Builder(
      //     builder: (context) => IconButton(
      //       onPressed: () => Scaffold.of(context).openDrawer(),
      //       icon: const Icon(Icons.menu_rounded),
      //     ),
      //   ),
      //   title: Row(
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       Image.asset('assets/images/logo.png', height: 24),
      //       const SizedBox(width: 8),
      //       Text('Residents', style: AppTextStyles.h4.copyWith(color: Colors.white)),
      //     ],
      //   ),
      //   actions: [
      //     Obx(() => controller.hasActiveFilters
      //         ? Padding(
      //             padding: const EdgeInsets.only(right: 8),
      //             child: TextButton(
      //               onPressed: controller.clearFilters,
      //               child: const Text('Clear', style: TextStyle(color: Colors.white)),
      //             ),
      //           )
      //         : const SizedBox.shrink()),
      //   ],
      // ),
      appBar: const _ResidentsAppBar(),
      bottomNavigationBar: AppBottomNav(
        activeTab: AppNavTab.home,
        onHome: () => Get.offAllNamed(AppRoutes.dashboard),
        onUpdates: () => Get.toNamed(AppRoutes.updates),
        onRequests: () => Get.toNamed(AppRoutes.requests),
        onProfile: () => Get.toNamed(AppRoutes.profile),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const AppSkeletonList(itemBuilder: StaffTileSkeleton.new);
        }
        final grouped = controller.groupedByBuilding;
        if (grouped.isEmpty) return const _EmptyResidentsState();

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: AppResponsiveContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: grouped.entries.expand((entry) {
                return [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 4),
                    child: Text(entry.key, style: AppTextStyles.h4),
                  ),
                  ...entry.value.map(
                    (r) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ResidentTile(resident: r),
                    ),
                  ),
                  const SizedBox(height: 8),
                ];
              }).toList(),
            ),
          ),
        );
      }),
    );
  }
}

class _FilterDrawer extends StatelessWidget {
  const _FilterDrawer();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ResidentsController>();
    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Filters', style: AppTextStyles.h3),
              const SizedBox(height: 20),

              Text('Building', style: AppTextStyles.labelLarge),
              const SizedBox(height: 8),
              Obx(() {
                final buildingNames = controller.buildings.map((b) => b.name).toSet().toList();
                return DropdownButtonFormField<String?>(
                  initialValue: controller.selectedBuildingName.value,
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem<String?>(value: null, child: Text('All Buildings')),
                    ...buildingNames.map((name) => DropdownMenuItem<String?>(value: name, child: Text(name))),
                  ],
                  onChanged: controller.setBuildingFilter,
                );
              }),
              const SizedBox(height: 20),

              Text('Floor', style: AppTextStyles.labelLarge),
              const SizedBox(height: 8),
              Obx(() {
                final floors = controller.availableFloorsForFilter;
                final hasBuilding = controller.selectedBuildingName.value != null;
                return DropdownButtonFormField<int?>(
                  initialValue: controller.selectedFloor.value,
                  isExpanded: true,
                  items: [
                    DropdownMenuItem<int?>(
                      value: null,
                      child: Text(hasBuilding ? 'All Floors' : 'Select a building first'),
                    ),
                    ...floors.map((f) => DropdownMenuItem<int?>(value: f, child: Text('Floor $f'))),
                  ],
                  onChanged: !hasBuilding ? null : controller.setFloorFilter,
                );
              }),
              const SizedBox(height: 20),

              Text('Rent Status', style: AppTextStyles.labelLarge),
              const SizedBox(height: 8),
              Obx(() => _FilterChips(
                    selected: controller.rentFilter.value,
                    onSelected: controller.setRentFilter,
                  )),
              const SizedBox(height: 20),

              Text('Maintenance Status', style: AppTextStyles.labelLarge),
              const SizedBox(height: 8),
              Obx(() => _FilterChips(
                    selected: controller.maintenanceFilter.value,
                    onSelected: controller.setMaintenanceFilter,
                  )),

              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.clearFilters,
                  icon: const Icon(Icons.refresh_rounded, size: 18, color: AppColors.accentGreen),
                  label: const Text('Reset Filters', style: TextStyle(color: AppColors.accentGreen)),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: AppColors.primaryDark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radiusFull)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResidentsAppBar extends StatefulWidget implements PreferredSizeWidget {
  const _ResidentsAppBar();

  @override
  State<_ResidentsAppBar> createState() => _ResidentsAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ResidentsAppBarState extends State<_ResidentsAppBar> {
  bool _isSearching = false;
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ResidentsController>();
    return AppBar(
      backgroundColor: AppColors.primaryDark,
      titleSpacing: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      leading: Builder(
        builder: (context) => IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: const Icon(Icons.menu_rounded),
        ),
      ),
      title: _isSearching
          ? TextField(
              controller: _searchCtrl,
              autofocus: true,
              style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
              cursorColor: AppColors.primaryDark,
              decoration: InputDecoration(
                hintText: 'Search by name',
                hintStyle: TextStyle(color: AppColors.primaryDark, fontSize: 16),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onChanged: controller.setSearchQuery,
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/logo.png', height: 24),
                const SizedBox(width: 8),
                Text('Residents', style: AppTextStyles.h4.copyWith(color: Colors.white)),
              ],
            ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              if (_isSearching) {
                _searchCtrl.clear();
                controller.setSearchQuery('');
              }
              _isSearching = !_isSearching;
            });
          },
          icon: Icon(_isSearching ? Icons.close_rounded : Icons.search_rounded, color: AppColors.accentGreen),
        ),
        Obx(() => controller.hasActiveFilters && !_isSearching
            ? Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextButton(
                  onPressed: controller.clearFilters,
                  child: const Text('Clear', style: TextStyle(color: Colors.white)),
                ),
              )
            : const SizedBox.shrink()),
      ],
    );
  }
}

class _FilterChips extends StatelessWidget {
  final PaymentFilter selected;
  final ValueChanged<PaymentFilter> onSelected;
  const _FilterChips({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: PaymentFilter.values.map((filter) {
        final isSelected = filter == selected;
        final label = switch (filter) {
          PaymentFilter.all => 'All',
          PaymentFilter.paid => 'Paid',
          PaymentFilter.unpaid => 'Unpaid',
        };
        return ChoiceChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (_) => onSelected(filter),
          selectedColor: AppColors.accentGreen,
          labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary),
        );
      }).toList(),
    );
  }
}

class _EmptyResidentsState extends StatelessWidget {
  const _EmptyResidentsState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryDark.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppDimens.radiusXl),
              ),
              child: Icon(Icons.groups_rounded, size: 40, color: AppColors.primaryDark.withValues(alpha: 0.4)),
            ),
            const SizedBox(height: 16),
            Text('No residents yet', style: AppTextStyles.h4),
            const SizedBox(height: 4),
            Text(
              'Accepted tenant requests will appear here',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}

class _ResidentTile extends StatelessWidget {
  final ResidentModel resident;
  const _ResidentTile({required this.resident});

  Future<void> _call() async {
    final uri = Uri(scheme: 'tel', path: resident.phone.replaceAll(' ', ''));
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      AppSnackbar.error('Unable to open dialer', 'No phone app available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 3))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryDark.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              resident.initials,
              style: AppTextStyles.labelLarge.copyWith(color: AppColors.primaryDark, fontSize: 16),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(resident.name, style: AppTextStyles.h4),
                const SizedBox(height: 2),
                Text(
                  '${resident.buildingName} · Floor ${resident.floor} · Flat ${resident.flatNumber}',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _call,
            icon: const Icon(Icons.call_rounded, size: 20, color: AppColors.successGreenDark),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.successGreen.withValues(alpha: 0.12),
              shape: const CircleBorder(),
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            onPressed: () => showSendUpdateSheet(
              prefillBuildingName: resident.buildingName,
              prefillFloor: resident.floor,
              prefillFlatNumber: resident.flatNumber,
            ),
            icon: const Icon(Icons.campaign_rounded, size: 20, color: AppColors.textSecondary),
            style: IconButton.styleFrom(backgroundColor: AppColors.surfaceMuted, shape: const CircleBorder()),
          ),
        ],
      ),
    );
  }
}
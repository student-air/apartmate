import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartmate/core/constants/app_colors.dart';
import 'package:apartmate/core/constants/app_dimens.dart';
import 'package:apartmate/core/constants/app_strings.dart';
import 'package:apartmate/core/constants/app_text_styles.dart';
import 'package:apartmate/core/widgets/app_animations.dart';
import 'package:apartmate/core/widgets/app_button.dart';
import 'package:apartmate/core/widgets/app_responsive_container.dart';
import 'package:apartmate/core/widgets/app_toggle.dart';
import 'package:apartmate/presentation/society_setup/controllers/building_detail_controller.dart';

class BuildingDetailView extends GetView<BuildingDetailController> {
  const BuildingDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: -10,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/logo.png', 
            height: 32, fit: BoxFit.cover),
            const SizedBox(width: 2),
            Text(AppStrings.buildingConfiguration, style: AppTextStyles.h4.copyWith(color: Colors.white)),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: AppResponsiveContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Obx(
                      () => AppShakeOnTrigger(
                        trigger: controller.shakeTrigger.value,
                        child: _SectionCard(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: controller.buildingNameCtrl,
                                      focusNode: controller.buildingNameFocusNode,
                                      style: AppTextStyles.h4,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        filled: false,
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                        hintText: 'Building name',
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => controller.buildingNameFocusNode.requestFocus(),
                                    icon: const Icon(Icons.edit_sharp, size: 18, color: AppColors.textSecondary),
                                    style: IconButton.styleFrom(
                                      backgroundColor: AppColors.surfaceMuted,
                                      shape: const CircleBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(AppStrings.structure, style: AppTextStyles.h4),
                    const SizedBox(height: 12),
                    _SectionCard(
                      children: [
                        _NumberRow(
                          title: AppStrings.totalFloors,
                          subtitle: AppStrings.totalFloorsDesc,
                          controller: controller.totalFloorsCtrl,
                          hint: 'e.g. 12',
                        ),
                        const Divider(height: 1),
                        _NumberRow(
                          title: AppStrings.flatsPerFloor,
                          subtitle: AppStrings.flatsPerFloorDesc,
                          controller: controller.flatsPerFloorCtrl,
                          hint: 'e.g. 4',
                        ),
                      ],
                    ),
                    Obx(() {
                      if (controller.totalApartments.value <= 0) return const SizedBox.shrink();
                      return Container(
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryDark.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(AppDimens.radiusLg),
                          border: Border.all(color: AppColors.primaryDark.withValues(alpha: 0.1)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppStrings.totalApartments, style: AppTextStyles.labelLarge),
                            Text('${controller.totalApartments.value}', style: AppTextStyles.h3),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                    Text(AppStrings.flatTypes, style: AppTextStyles.h4),
                    const SizedBox(height: 12),
                    _SectionCard(
                      children: [
                        _NumberRow(title: '1-Bedroom Flats', subtitle: 'Single bedroom units', controller: controller.bed1Ctrl, hint: '0'),
                        const Divider(height: 1),
                        _NumberRow(title: '2-Bedroom Flats', subtitle: 'Double bedroom units', controller: controller.bed2Ctrl, hint: '0'),
                        const Divider(height: 1),
                        _NumberRow(title: '3-Bedroom Flats', subtitle: 'Three bedroom units', controller: controller.bed3Ctrl, hint: '0'),
                        const Divider(height: 1),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Obx(
                            () => _FlatTypeBar(
                              bed1: controller.bed1Count.value,
                              bed2: controller.bed2Count.value,
                              bed3: controller.bed3Count.value,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(AppStrings.parking, style: AppTextStyles.h4),
                    const SizedBox(height: 12),
                    Obx(
                      () => _SectionCard(
                        children: [
                          _ToggleRow(
                            title: AppStrings.dedicatedParking,
                            subtitle: AppStrings.dedicatedParkingDesc,
                            value: controller.hasParking.value,
                            onChanged: controller.toggleParking,
                          ),
                          if (controller.hasParking.value) ...[
                            const Divider(height: 1),
                            _NumberRow(
                              title: AppStrings.parkingSlots,
                              subtitle: AppStrings.parkingSlotsDesc,
                              controller: controller.parkingSlotsCtrl,
                              hint: 'e.g. 48',
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(AppStrings.amenities, style: AppTextStyles.h4),
                    const SizedBox(height: 12),
                    Obx(
                      () => _SectionCard(
                        children: [
                          _ToggleRow(
                            title: AppStrings.elevatorLift,
                            subtitle: AppStrings.elevatorLiftDesc,
                            value: controller.hasLift.value,
                            onChanged: controller.toggleLift,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.borderLight)),
              ),
              child: AppPrimaryButton(
                label: AppStrings.saveBuildingDetails,
                icon: Icons.check,
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                onPressed: controller.save,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final List<Widget> children;
  const _SectionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radius2xl),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _NumberRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final TextEditingController controller;
  final String hint;
  const _NumberRow({required this.title, required this.subtitle, required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.labelLarge),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 96,
            height: 40,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              style: AppTextStyles.labelLarge,
              decoration: InputDecoration(
                hintText: hint,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                fillColor: AppColors.background,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FlatTypeBar extends StatelessWidget {
  final int bed1;
  final int bed2;
  final int bed3;
  const _FlatTypeBar({required this.bed1, required this.bed2, required this.bed3});

  @override
  Widget build(BuildContext context) {
    final total = bed1 + bed2 + bed3;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final w1 = total == 0 ? 0.0 : width * bed1 / total;
        final w2 = total == 0 ? 0.0 : width * bed2 / total;
        final w3 = total == 0 ? 0.0 : width * bed3 / total;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 14,
              width: width,
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(7)),
              clipBehavior: Clip.antiAlias,
              child: Row(
                children: [
                  AnimatedContainer(duration: const Duration(milliseconds: 300), width: w1, color: const Color(0xFF34D399)),
                  AnimatedContainer(duration: const Duration(milliseconds: 300), width: w2, color: const Color(0xFF60A5FA)),
                  AnimatedContainer(duration: const Duration(milliseconds: 300), width: w3, color: const Color(0xFFFBBF24)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _LegendDot(color: const Color(0xFF34D399), label: '1BR: $bed1'),
                _LegendDot(color: const Color(0xFF60A5FA), label: '2BR: $bed2'),
                _LegendDot(color: const Color(0xFFFBBF24), label: '3BR: $bed3'),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 5),
        Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleRow({required this.title, required this.subtitle, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.labelLarge),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          AppToggle(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mohta_app/constants/color_constants.dart';
import 'package:mohta_app/features/item_help/controllers/item_help_controller.dart';
import 'package:mohta_app/features/utils/screen_utils/app_paddings.dart';
import 'package:mohta_app/features/utils/screen_utils/app_spacings.dart';
import 'package:mohta_app/styles/text_styles.dart';
import 'package:mohta_app/widgets/app_appbar.dart';
import 'package:mohta_app/widgets/app_loading_overlay.dart';
import 'package:mohta_app/widgets/app_text_form_field.dart';

class SelectMakeScreen extends StatefulWidget {
  const SelectMakeScreen({
    super.key,
  });

  @override
  State<SelectMakeScreen> createState() => _SelectMakeScreenState();
}

class _SelectMakeScreenState extends State<SelectMakeScreen> {
  final ItemHelpController itemHelpController = Get.find<ItemHelpController>();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await itemHelpController.getMake();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: kColorWhite,
            appBar: AppAppbar(
              title: 'Select Make',
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: kColorTextPrimary,
                  size: 20,
                ),
              ),
            ),
            body: Padding(
              padding: AppPaddings.p10,
              child: Column(
                children: [
                  AppTextFormField(
                    controller: itemHelpController.searchMakeController,
                    hintText: 'Search Make',
                    onChanged: (value) {
                      itemHelpController.filterMakes(value);
                    },
                  ),
                  AppSpaces.v10,
                  Obx(
                    () {
                      if (itemHelpController.isLoading.value) {
                        return const SizedBox.shrink();
                      }

                      if (!itemHelpController.isLoading.value &&
                          itemHelpController.filteredMakes.isEmpty) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              'No makes found.',
                              style: TextStyles.kMediumSofiaSansSemiCondensed(),
                            ),
                          ),
                        );
                      }

                      return Expanded(
                        child: ListView.builder(
                          itemCount: itemHelpController.filteredMakes.length,
                          itemBuilder: (context, index) {
                            final make =
                                itemHelpController.filteredMakes[index];
                            return ListTile(
                              contentPadding: AppPaddings.ph10,
                              minVerticalPadding: 2,
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    make.bName,
                                    style: TextStyles
                                            .kMediumSofiaSansSemiCondensed()
                                        .copyWith(
                                      height: 1.25,
                                    ),
                                  ),
                                  Divider(),
                                ],
                              ),
                              onTap: () {
                                itemHelpController.selectedValues.clear();
                                itemHelpController.selectedMake.value =
                                    make.bName;
                                itemHelpController.selectedMakeCode.value =
                                    make.bCode;

                                itemHelpController.searchMakeController.clear();

                                Get.back();
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        Obx(
          () => AppLoadingOverlay(
            isLoading: itemHelpController.isLoading.value,
          ),
        ),
      ],
    );
  }
}

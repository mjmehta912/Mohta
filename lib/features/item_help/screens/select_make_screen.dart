import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mohta_app/constants/color_constants.dart';
import 'package:mohta_app/features/item_help/controllers/item_help_controller.dart';
import 'package:mohta_app/features/utils/screen_utils/app_paddings.dart';
import 'package:mohta_app/styles/text_styles.dart';
import 'package:mohta_app/widgets/app_appbar.dart';
import 'package:mohta_app/widgets/app_card.dart';
import 'package:mohta_app/widgets/app_loading_overlay.dart';

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
        Scaffold(
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
            child: Obx(
              () {
                if (itemHelpController.isLoading.value) {
                  return const SizedBox.shrink();
                }

                if (!itemHelpController.isLoading.value &&
                    itemHelpController.makes.isEmpty) {
                  return Center(
                    child: Text(
                      'No makes found.',
                      style: TextStyles.kMediumSofiaSansSemiCondensed(),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: itemHelpController.makes.length,
                  itemBuilder: (context, index) {
                    final make = itemHelpController.makes[index];
                    return AppCard(
                      child: Padding(
                        padding: AppPaddings.p10,
                        child: Text(
                          make.bName,
                          style: TextStyles.kMediumSofiaSansSemiCondensed()
                              .copyWith(
                            height: 1,
                          ),
                        ),
                      ),
                      onTap: () {
                        itemHelpController.selectedValues.clear();
                        itemHelpController.selectedMake.value = make.bName;
                        itemHelpController.selectedMakeCode.value = make.bCode;
                        Get.back();
                      },
                    );
                  },
                );
              },
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

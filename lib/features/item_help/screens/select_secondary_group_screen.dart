import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mohta_app/constants/color_constants.dart';
import 'package:mohta_app/features/item_help/controllers/item_help_controller.dart';
import 'package:mohta_app/features/utils/screen_utils/app_paddings.dart';
import 'package:mohta_app/styles/text_styles.dart';
import 'package:mohta_app/widgets/app_appbar.dart';
import 'package:mohta_app/widgets/app_card.dart';
import 'package:mohta_app/widgets/app_loading_overlay.dart';

class SelectSecondaryGroupScreen extends StatefulWidget {
  const SelectSecondaryGroupScreen({
    super.key,
  });

  @override
  State<SelectSecondaryGroupScreen> createState() =>
      _SelectSecondaryGroupScreenState();
}

class _SelectSecondaryGroupScreenState
    extends State<SelectSecondaryGroupScreen> {
  final ItemHelpController itemHelpController = Get.find<ItemHelpController>();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await itemHelpController.getSecondaryGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: kColorWhite,
          appBar: AppAppbar(
            title: 'Select Secondary Group',
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
                    itemHelpController.secondaryGroups.isEmpty) {
                  return Center(
                    child: Text(
                      'No secondary groups found.',
                      style: TextStyles.kMediumSofiaSansSemiCondensed(),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: itemHelpController.secondaryGroups.length,
                  itemBuilder: (context, index) {
                    final secondaryGroup =
                        itemHelpController.secondaryGroups[index];
                    return AppCard(
                      child: Padding(
                        padding: AppPaddings.p10,
                        child: Text(
                          secondaryGroup.igName,
                          style: TextStyles.kMediumSofiaSansSemiCondensed()
                              .copyWith(
                            height: 1,
                          ),
                        ),
                      ),
                      onTap: () {
                        itemHelpController.selectedSecondaryGroup.value =
                            secondaryGroup.igName;
                        itemHelpController.selectedSecondaryGroupCode.value =
                            secondaryGroup.igCode;
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

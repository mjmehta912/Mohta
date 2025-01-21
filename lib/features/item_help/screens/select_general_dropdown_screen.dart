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

class SelectGeneralDropdownScreen extends StatefulWidget {
  const SelectGeneralDropdownScreen({
    super.key,
    required this.descKey,
    required this.descValue,
  });

  final String descKey;
  final String descValue;

  @override
  State<SelectGeneralDropdownScreen> createState() =>
      _SelectGeneralDropdownScreenState();
}

class _SelectGeneralDropdownScreenState
    extends State<SelectGeneralDropdownScreen> {
  final ItemHelpController itemHelpController = Get.find<ItemHelpController>();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await itemHelpController.getGeneralDropdown(
      desc: widget.descValue,
    );
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
              title: 'Select ${widget.descValue}',
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
                    controller: TextEditingController(),
                    hintText: 'Search ${widget.descValue}',
                  ),
                  AppSpaces.v10,
                  Obx(
                    () {
                      if (itemHelpController.isLoading.value) {
                        return const SizedBox.shrink();
                      }

                      if (!itemHelpController.isLoading.value &&
                          itemHelpController.descData.isEmpty) {
                        return Center(
                          child: Text(
                            'No ${widget.descValue} found.',
                            style: TextStyles.kMediumSofiaSansSemiCondensed(),
                          ),
                        );
                      }

                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: itemHelpController.descData.length,
                          itemBuilder: (context, index) {
                            final data = itemHelpController.descData[index];
                            return Padding(
                              padding: AppPaddings.ph10,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.name,
                                    style: TextStyles
                                            .kMediumSofiaSansSemiCondensed()
                                        .copyWith(
                                      height: 1.25,
                                    ),
                                  ),
                                  Divider(),
                                ],
                              ),
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

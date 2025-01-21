import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mohta_app/constants/color_constants.dart';
import 'package:mohta_app/features/item_help/controllers/item_help_controller.dart';
import 'package:mohta_app/features/item_help/screens/select_general_dropdown_screen.dart';
import 'package:mohta_app/features/item_help/screens/select_make_screen.dart';
import 'package:mohta_app/features/item_help/screens/select_party_screen.dart';
import 'package:mohta_app/features/item_help/screens/select_primary_group_screen.dart';
import 'package:mohta_app/features/item_help/screens/select_product_screen.dart';
import 'package:mohta_app/features/item_help/screens/select_secondary_group_screen.dart';
import 'package:mohta_app/features/utils/extensions/app_size_extensions.dart';
import 'package:mohta_app/features/utils/screen_utils/app_paddings.dart';
import 'package:mohta_app/features/utils/screen_utils/app_spacings.dart';
import 'package:mohta_app/styles/font_sizes.dart';
import 'package:mohta_app/styles/text_styles.dart';
import 'package:mohta_app/widgets/app_appbar.dart';
import 'package:mohta_app/widgets/app_button.dart';
import 'package:mohta_app/widgets/app_card_text_field.dart';

class ItemHelpScreen extends StatelessWidget {
  ItemHelpScreen({
    super.key,
  });

  final ItemHelpController _controller = Get.put(
    ItemHelpController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorWhite,
      appBar: AppAppbar(
        title: 'Item Help',
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  _controller.logoutUser();
                },
                child: Text(
                  'Logout',
                  style: TextStyles.kRegularSofiaSansSemiCondensed(
                    fontSize: FontSizes.k16FontSize,
                    color: kColorTextPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  _controller.logoutUser();
                },
                icon: Icon(
                  Icons.logout,
                  color: kColorTextPrimary,
                  size: 25,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: AppPaddings.combined(
          horizontal: 15.appWidth,
          vertical: 10.appHeight,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PARTY',
                    style: TextStyles.kMediumSofiaSansSemiCondensed(),
                  ),
                  Obx(
                    () => AppCardTextField(
                      isSelected: _controller.selectedParty.value.isNotEmpty,
                      onTap: () {
                        Get.to(
                          () => SelectPartyScreen(),
                        );
                      },
                      child: Padding(
                        padding: AppPaddings.p12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(
                                  () => _controller.selectedParty.isNotEmpty
                                      ? SizedBox(
                                          width: 0.75.screenWidth,
                                          child: Text(
                                            _controller.selectedParty.value,
                                            style: TextStyles
                                                .kMediumSofiaSansSemiCondensed(
                                              fontSize: FontSizes.k18FontSize,
                                            ).copyWith(
                                              height: 1,
                                            ),
                                          ),
                                        )
                                      : Text(
                                          'SELECT PARTY',
                                          style: TextStyles
                                              .kRegularSofiaSansSemiCondensed(
                                            color: kColorGrey,
                                            fontSize: FontSizes.k16FontSize,
                                          ).copyWith(
                                            height: 1.25,
                                          ),
                                        ),
                                ),
                                Obx(
                                  () =>
                                      _controller.selectedParty.value.isNotEmpty
                                          ? InkWell(
                                              onTap: () {
                                                _controller
                                                    .selectedParty.value = '';
                                                _controller.selectedPartyCode
                                                    .value = '';
                                              },
                                              child: Icon(
                                                Icons.clear,
                                                size: 25,
                                                color: kColorGrey,
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              AppSpaces.v10,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PRODUCT',
                    style: TextStyles.kMediumSofiaSansSemiCondensed(),
                  ),
                  Obx(
                    () => AppCardTextField(
                      isSelected: _controller.selectedProduct.value.isNotEmpty,
                      onTap: () {
                        Get.to(
                          () => SelectProductScreen(),
                        );
                      },
                      child: Padding(
                        padding: AppPaddings.p12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(
                                  () => _controller.selectedProduct.isNotEmpty
                                      ? SizedBox(
                                          width: 0.75.screenWidth,
                                          child: Text(
                                            _controller.selectedProduct.value,
                                            style: TextStyles
                                                .kMediumSofiaSansSemiCondensed(
                                              fontSize: FontSizes.k18FontSize,
                                            ).copyWith(
                                              height: 1,
                                            ),
                                          ),
                                        )
                                      : Text(
                                          'SELECT PRODUCT',
                                          style: TextStyles
                                              .kRegularSofiaSansSemiCondensed(
                                            color: kColorGrey,
                                            fontSize: FontSizes.k16FontSize,
                                          ).copyWith(
                                            height: 1.25,
                                          ),
                                        ),
                                ),
                                Obx(
                                  () => _controller
                                          .selectedProduct.value.isNotEmpty
                                      ? InkWell(
                                          onTap: () {
                                            _controller.selectedProduct.value =
                                                '';
                                            _controller
                                                .selectedProductCode.value = '';
                                            _controller.nonEmptyDescs.clear();
                                            _controller.selectedValues.clear();
                                            _controller.selectedMake.value = '';
                                            _controller.selectedMakeCode.value =
                                                '';
                                            _controller.selectedPrimaryGroup
                                                .value = '';
                                            _controller.selectedPrimaryGroupCode
                                                .value = '';
                                            _controller.selectedSecondaryGroup
                                                .value = '';
                                            _controller
                                                .selectedSecondaryGroupCode
                                                .value = '';
                                          },
                                          child: Icon(
                                            Icons.clear,
                                            size: 25,
                                            color: kColorGrey,
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Obx(
                () => Visibility(
                  visible: _controller.selectedProductCode.value.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSpaces.v10,
                      Text(
                        'MAKE',
                        style: TextStyles.kMediumSofiaSansSemiCondensed(),
                      ),
                      AppCardTextField(
                        isSelected: _controller.selectedMake.value.isNotEmpty,
                        onTap: () {
                          Get.to(
                            () => SelectMakeScreen(),
                          );
                        },
                        child: Padding(
                          padding: AppPaddings.p10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(
                                    () => _controller.selectedMake.isNotEmpty
                                        ? SizedBox(
                                            width: 0.75.screenWidth,
                                            child: Text(
                                              _controller.selectedMake.value,
                                              style: TextStyles
                                                  .kMediumSofiaSansSemiCondensed(
                                                fontSize: FontSizes.k18FontSize,
                                              ).copyWith(
                                                height: 1,
                                              ),
                                            ),
                                          )
                                        : Text(
                                            'SELECT MAKE',
                                            style: TextStyles
                                                .kRegularSofiaSansSemiCondensed(
                                              color: kColorGrey,
                                              fontSize: FontSizes.k16FontSize,
                                            ).copyWith(
                                              height: 1.25,
                                            ),
                                          ),
                                  ),
                                  Obx(
                                    () => _controller
                                            .selectedMake.value.isNotEmpty
                                        ? InkWell(
                                            onTap: () {
                                              _controller.selectedMake.value =
                                                  '';
                                              _controller
                                                  .selectedMakeCode.value = '';

                                              _controller.selectedValues
                                                  .clear();
                                            },
                                            child: Icon(
                                              Icons.clear,
                                              size: 25,
                                              color: kColorGrey,
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: _controller.selectedProductCode.value.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSpaces.v10,
                      Text(
                        'PRIMARY GROUP',
                        style: TextStyles.kMediumSofiaSansSemiCondensed(),
                      ),
                      AppCardTextField(
                        isSelected:
                            _controller.selectedPrimaryGroup.value.isNotEmpty,
                        onTap: () {
                          Get.to(
                            () => SelectPrimaryGroupScreen(),
                          );
                        },
                        child: Padding(
                          padding: AppPaddings.p12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(
                                    () => _controller
                                            .selectedPrimaryGroup.isNotEmpty
                                        ? SizedBox(
                                            width: 0.75.screenWidth,
                                            child: Text(
                                              _controller
                                                  .selectedPrimaryGroup.value,
                                              style: TextStyles
                                                  .kMediumSofiaSansSemiCondensed(
                                                fontSize: FontSizes.k18FontSize,
                                              ).copyWith(
                                                height: 1,
                                              ),
                                            ),
                                          )
                                        : Text(
                                            'SELECT PRIMARY GROUP',
                                            style: TextStyles
                                                .kRegularSofiaSansSemiCondensed(
                                              color: kColorGrey,
                                              fontSize: FontSizes.k16FontSize,
                                            ).copyWith(
                                              height: 1.25,
                                            ),
                                          ),
                                  ),
                                  Obx(
                                    () => _controller.selectedPrimaryGroup.value
                                            .isNotEmpty
                                        ? InkWell(
                                            onTap: () {
                                              _controller.selectedPrimaryGroup
                                                  .value = '';
                                              _controller
                                                  .selectedPrimaryGroupCode
                                                  .value = '';
                                            },
                                            child: Icon(
                                              Icons.clear,
                                              size: 25,
                                              color: kColorGrey,
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: _controller.selectedProductCode.value.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSpaces.v10,
                      Text(
                        'SECONDARY GROUP',
                        style: TextStyles.kMediumSofiaSansSemiCondensed(),
                      ),
                      AppCardTextField(
                        isSelected:
                            _controller.selectedSecondaryGroup.value.isNotEmpty,
                        onTap: () {
                          Get.to(
                            () => SelectSecondaryGroupScreen(),
                          );
                        },
                        child: Padding(
                          padding: AppPaddings.p12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(
                                    () => _controller
                                            .selectedSecondaryGroup.isNotEmpty
                                        ? SizedBox(
                                            width: 0.75.screenWidth,
                                            child: Text(
                                              _controller
                                                  .selectedSecondaryGroup.value,
                                              style: TextStyles
                                                  .kMediumSofiaSansSemiCondensed(
                                                fontSize: FontSizes.k18FontSize,
                                              ).copyWith(
                                                height: 1,
                                              ),
                                            ),
                                          )
                                        : Text(
                                            'SELECT SECONDARY GROUP',
                                            style: TextStyles
                                                .kRegularSofiaSansSemiCondensed(
                                              color: kColorGrey,
                                              fontSize: FontSizes.k16FontSize,
                                            ).copyWith(
                                              height: 1.25,
                                            ),
                                          ),
                                  ),
                                  Obx(
                                    () => _controller.selectedSecondaryGroup
                                            .value.isNotEmpty
                                        ? InkWell(
                                            onTap: () {
                                              _controller.selectedSecondaryGroup
                                                  .value = '';
                                              _controller
                                                  .selectedSecondaryGroupCode
                                                  .value = '';
                                            },
                                            child: Icon(
                                              Icons.clear,
                                              size: 25,
                                              color: kColorGrey,
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: _controller.selectedProduct.value.isNotEmpty,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _controller.nonEmptyDescs.length,
                    itemBuilder: (context, index) {
                      String desc =
                          _controller.nonEmptyDescs.keys.elementAt(index);
                      String descValue = _controller.nonEmptyDescs[desc]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSpaces.v10,
                          Text(
                            descValue,
                            style: TextStyles.kMediumSofiaSansSemiCondensed(),
                          ),
                          Obx(
                            () => AppCardTextField(
                              isSelected:
                                  _controller.selectedValues[desc] != null,
                              onTap: () {
                                Get.to(
                                  () => SelectGeneralDropdownScreen(
                                    descKey: desc,
                                    descValue: descValue,
                                  ),
                                );
                              },
                              child: Padding(
                                padding: AppPaddings.p12,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Obx(
                                          () => _controller
                                                      .selectedValues[desc] !=
                                                  null
                                              ? SizedBox(
                                                  width: 0.75.screenWidth,
                                                  child: Text(
                                                    _controller
                                                        .selectedValues[desc]!
                                                        .name,
                                                    style: TextStyles
                                                        .kMediumSofiaSansSemiCondensed(
                                                      fontSize:
                                                          FontSizes.k18FontSize,
                                                    ).copyWith(
                                                      height: 1,
                                                    ),
                                                  ),
                                                )
                                              : Text(
                                                  'SELECT $descValue',
                                                  style: TextStyles
                                                      .kRegularSofiaSansSemiCondensed(
                                                    color: kColorGrey,
                                                    fontSize:
                                                        FontSizes.k16FontSize,
                                                  ).copyWith(
                                                    height: 1.25,
                                                  ),
                                                ),
                                        ),
                                        Obx(
                                          () => _controller
                                                      .selectedValues[desc] !=
                                                  null
                                              ? InkWell(
                                                  onTap: () {
                                                    _controller.selectedValues
                                                        .remove(desc);
                                                  },
                                                  child: Icon(
                                                    Icons.clear,
                                                    size: 25,
                                                    color: kColorGrey,
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              AppSpaces.v20,
              Obx(
                () => AppButton(
                  isLoading: _controller.isItemsLoading.value,
                  title: 'Search Item',
                  onPressed: () {
                    _controller.getItems();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

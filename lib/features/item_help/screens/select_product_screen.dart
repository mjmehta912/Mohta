import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mohta_app/constants/color_constants.dart';
import 'package:mohta_app/features/item_help/controllers/item_help_controller.dart';
import 'package:mohta_app/features/utils/screen_utils/app_paddings.dart';
import 'package:mohta_app/styles/text_styles.dart';
import 'package:mohta_app/widgets/app_appbar.dart';
import 'package:mohta_app/widgets/app_card.dart';
import 'package:mohta_app/widgets/app_loading_overlay.dart';

class SelectProductScreen extends StatefulWidget {
  const SelectProductScreen({
    super.key,
  });

  @override
  State<SelectProductScreen> createState() => _SelectProductScreenState();
}

class _SelectProductScreenState extends State<SelectProductScreen> {
  final ItemHelpController itemHelpController = Get.find<ItemHelpController>();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await itemHelpController.getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: kColorWhite,
          appBar: AppAppbar(
            title: 'Select Product',
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
                    itemHelpController.products.isEmpty) {
                  return Center(
                    child: Text(
                      'No products found.',
                      style: TextStyles.kMediumSofiaSansSemiCondensed(),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: itemHelpController.products.length,
                  itemBuilder: (context, index) {
                    final product = itemHelpController.products[index];
                    return AppCard(
                      child: Padding(
                        padding: AppPaddings.p10,
                        child: Text(
                          product.prName,
                          style: TextStyles.kMediumSofiaSansSemiCondensed()
                              .copyWith(
                            height: 1,
                          ),
                        ),
                      ),
                      onTap: () {
                        itemHelpController.selectedMake.value = '';
                        itemHelpController.selectedMakeCode.value = '';
                        itemHelpController.selectedPrimaryGroup.value = '';
                        itemHelpController.selectedPrimaryGroupCode.value = '';
                        itemHelpController.selectedSecondaryGroup.value = '';
                        itemHelpController.selectedSecondaryGroupCode.value =
                            '';
                        itemHelpController.selectedProduct.value =
                            product.prName;
                        itemHelpController.selectedProductCode.value =
                            product.prCode;

                        itemHelpController.nonEmptyDescs.clear();
                        itemHelpController.selectedValues.clear();

                        itemHelpController.nonEmptyDescs.value = {
                          "DESC1": product.desc1,
                          "DESC2": product.desc2,
                          "DESC3": product.desc3,
                          "DESC4": product.desc4,
                          "DESC5": product.desc5,
                          "DESC6": product.desc6,
                          "DESC7": product.desc7,
                          "DESC8": product.desc8,
                          "DESC9": product.desc9,
                          "DESC10": product.desc10,
                          "DESC11": product.desc11,
                          "DESC12": product.desc12,
                        }..removeWhere(
                            (key, value) => value.isEmpty,
                          );

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

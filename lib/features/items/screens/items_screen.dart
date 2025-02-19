import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mohta_app/constants/color_constants.dart';
import 'package:mohta_app/features/item_details/screens/item_details_screen.dart';
import 'package:mohta_app/features/utils/extensions/app_size_extensions.dart';
import 'package:mohta_app/features/utils/screen_utils/app_paddings.dart';
import 'package:mohta_app/features/utils/screen_utils/app_spacings.dart';
import 'package:mohta_app/styles/font_sizes.dart';
import 'package:mohta_app/styles/text_styles.dart';
import 'package:mohta_app/widgets/app_appbar.dart';
import 'package:mohta_app/widgets/app_button.dart';
import 'package:mohta_app/widgets/app_card.dart';
import 'package:mohta_app/widgets/app_text_form_field.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({
    super.key,
    required this.items,
    required this.prCode,
    required this.pCode,
  });

  final List<Map<String, dynamic>> items;
  final String prCode;
  final String pCode;

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Map<int, bool> _expandedStates = {};
  late List<Map<String, dynamic>> _filteredItems;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _searchController.addListener(_filterItems);
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(
      () {
        _filteredItems = widget.items.where(
          (item) {
            return item.values.any(
              (value) =>
                  value != null &&
                  value.toString().toLowerCase().contains(query),
            );
          },
        ).toList();
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Set<String> excludedKeys = {
      "ICODE",
      "BCODE",
      "MCODE",
      "IGCODE",
      "AdjQTY",
    };

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: kColorWhite,
        appBar: AppAppbar(
          title: 'Items',
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
                controller: _searchController,
                hintText: 'Search Items',
              ),
              AppSpaces.v10,
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = _filteredItems[index];
                    final filteredEntries = item.entries
                        .where((entry) => !excludedKeys.contains(entry.key))
                        .toList();

                    final previewEntries = filteredEntries.take(4).toList();
                    final hiddenEntries = filteredEntries.skip(4).toList();

                    final bool isAdjQTYTrue = item['AdjQTY'] == true;
                    final int stk = item['STK'] ?? 0;

                    return AppCard(
                      onTap: () {},
                      child: ExpansionTile(
                        tilePadding: AppPaddings.ph10,
                        childrenPadding: AppPaddings.custom(
                          bottom: 10,
                          left: 10,
                          right: 10,
                        ),
                        onExpansionChanged: (isExpanded) {
                          setState(() {
                            _expandedStates[index] = isExpanded;
                          });
                        },
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...previewEntries.map(
                              (entry) {
                                final Color textColor = _getTextColor(
                                  entry.key,
                                  isAdjQTYTrue,
                                  stk,
                                );

                                return RichText(
                                  text: TextSpan(
                                    style: TextStyles
                                        .kRegularSofiaSansSemiCondensed(
                                      fontSize: FontSizes.k16FontSize,
                                      color: textColor,
                                    ).copyWith(height: 1.25),
                                    children: [
                                      TextSpan(
                                        text: '${entry.key}: ',
                                        style: TextStyles
                                            .kBoldSofiaSansSemiCondensed(
                                          fontSize: FontSizes.k16FontSize,
                                          color: textColor,
                                        ).copyWith(
                                          height: 1.25,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${entry.value ?? 'N/A'}',
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            if (!(_expandedStates[index] ?? false))
                              AppSpaces.v10,
                            if (!(_expandedStates[index] ?? false))
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppButton(
                                    buttonWidth: 0.225.screenWidth,
                                    buttonHeight: 25,
                                    buttonColor: kColorTextPrimary,
                                    titleSize: FontSizes.k14FontSize,
                                    onPressed: () {
                                      Get.to(
                                        () => ItemDetailsScreen(
                                          selectedTabIndex: 0,
                                          prCode: widget.prCode,
                                          iCode: item['ICODE'],
                                          pCode: widget.pCode,
                                        ),
                                      );
                                    },
                                    title: 'View Price',
                                  ),
                                  AppButton(
                                    buttonWidth: 0.225.screenWidth,
                                    buttonHeight: 25,
                                    buttonColor: kColorTextPrimary,
                                    titleSize: FontSizes.k14FontSize,
                                    onPressed: () {
                                      Get.to(
                                        () => ItemDetailsScreen(
                                          selectedTabIndex: 1,
                                          prCode: widget.prCode,
                                          iCode: item['ICODE'],
                                          pCode: widget.pCode,
                                        ),
                                      );
                                    },
                                    title: 'Cmp Stock',
                                  ),
                                ],
                              ),
                          ],
                        ),
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...hiddenEntries.map(
                                (entry) {
                                  final Color textColor = _getTextColor(
                                    entry.key,
                                    isAdjQTYTrue,
                                    stk,
                                  );

                                  return RichText(
                                    text: TextSpan(
                                      style: TextStyles
                                          .kRegularSofiaSansSemiCondensed(
                                        fontSize: FontSizes.k16FontSize,
                                        color: textColor,
                                      ).copyWith(height: 1.25),
                                      children: [
                                        TextSpan(
                                          text: '${entry.key}: ',
                                          style: TextStyles
                                              .kBoldSofiaSansSemiCondensed(
                                            fontSize: FontSizes.k16FontSize,
                                            color: textColor,
                                          ).copyWith(height: 1.25),
                                        ),
                                        TextSpan(
                                          text: '${entry.value ?? 'N/A'}',
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              AppSpaces.v10,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppButton(
                                    buttonWidth: 0.225.screenWidth,
                                    buttonHeight: 25,
                                    buttonColor: kColorTextPrimary,
                                    titleSize: FontSizes.k14FontSize,
                                    onPressed: () {
                                      Get.to(
                                        () => ItemDetailsScreen(
                                          selectedTabIndex: 0,
                                          prCode: widget.prCode,
                                          iCode: item['ICODE'],
                                          pCode: widget.pCode,
                                        ),
                                      );
                                    },
                                    title: 'View Price',
                                  ),
                                  AppButton(
                                    buttonWidth: 0.225.screenWidth,
                                    buttonHeight: 25,
                                    buttonColor: kColorTextPrimary,
                                    titleSize: FontSizes.k14FontSize,
                                    onPressed: () {
                                      Get.to(
                                        () => ItemDetailsScreen(
                                          selectedTabIndex: 1,
                                          prCode: widget.prCode,
                                          iCode: item['ICODE'],
                                          pCode: widget.pCode,
                                        ),
                                      );
                                    },
                                    title: 'Cmp Stock',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTextColor(String key, bool isAdjQTYTrue, int stk) {
    if (isAdjQTYTrue && stk == 0) {
      return key == 'CATREF' ? kColorBlue : kColorRed;
    } else if (!isAdjQTYTrue && stk == 0) {
      return kColorTextPrimary;
    } else if (isAdjQTYTrue && stk > 0) {
      return kColorRed;
    } else if (!isAdjQTYTrue && stk > 0) {
      return key == 'CATREF' ? kColorBlue : kColorTextPrimary;
    }
    return kColorTextPrimary;
  }
}

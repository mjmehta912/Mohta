import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mohta_app/constants/color_constants.dart';
import 'package:mohta_app/features/outstandings/controllers/outstandings_controller.dart';
import 'package:mohta_app/features/outstandings/widgets/outstanding_row.dart';
import 'package:mohta_app/features/utils/extensions/app_size_extensions.dart';
import 'package:mohta_app/features/utils/screen_utils/app_paddings.dart';
import 'package:mohta_app/features/utils/screen_utils/app_spacings.dart';
import 'package:mohta_app/styles/text_styles.dart';
import 'package:mohta_app/widgets/app_appbar.dart';
import 'package:mohta_app/widgets/app_button.dart';
import 'package:mohta_app/widgets/app_card.dart';
import 'package:mohta_app/widgets/app_date_picker_field.dart';
import 'package:mohta_app/widgets/app_dropdown.dart';
import 'package:mohta_app/widgets/app_loading_overlay.dart';
import 'package:mohta_app/widgets/app_text_form_field.dart';

class OutstandingsScreen extends StatefulWidget {
  const OutstandingsScreen({
    super.key,
  });

  @override
  State<OutstandingsScreen> createState() => _OutstandingsScreenState();
}

class _OutstandingsScreenState extends State<OutstandingsScreen> {
  final OutstandingsController _controller = Get.put(
    OutstandingsController(),
  );

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await _controller.getCustomers();

    _controller.billStartDateController.text = '01-01-2018';
    _controller.billEndDateController.text = DateFormat('dd-MM-yyyy').format(
      DateTime.now(),
    );

    _controller.recievableStartDateController.text = '01-01-2018';
    _controller.recievableEndDateController.text =
        DateFormat('dd-MM-yyyy').format(
      DateTime.now(),
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
              title: 'Outstandings',
              leading: IconButton(
                onPressed: () {
                  if (_controller.isFilterScreenVisible.value) {
                    Get.back();
                  } else {
                    _controller.toggleVisibility();
                  }
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: kColorTextPrimary,
                  size: 20,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    _controller.downloadOutstandings();
                  },
                  icon: Icon(
                    Icons.file_download_outlined,
                    color: kColorTextPrimary,
                    size: 25,
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: AppPaddings.p10,
              child: Obx(
                () {
                  if (_controller.isFilterScreenVisible.value) {
                    return SingleChildScrollView(
                      child: Form(
                        key: _controller.filterFormKey,
                        child: Column(
                          children: [
                            Obx(
                              () => AppDropdown(
                                items: _controller.customerNames,
                                hintText: 'Customer',
                                onChanged: (value) {
                                  _controller.onCustomerSelected(value!);
                                },
                                selectedItem: _controller
                                        .selectedCustomer.value.isNotEmpty
                                    ? _controller.selectedCustomer.value
                                    : null,
                                validatorText:
                                    'Please select a party to continue',
                              ),
                            ),
                            AppSpaces.v10,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 0.45.screenWidth,
                                  child: AppDatePickerTextFormField(
                                    dateController:
                                        _controller.billStartDateController,
                                    hintText: 'Bill Start Date',
                                  ),
                                ),
                                SizedBox(
                                  width: 0.45.screenWidth,
                                  child: AppDatePickerTextFormField(
                                    dateController:
                                        _controller.billEndDateController,
                                    hintText: 'Bill End Date',
                                  ),
                                ),
                              ],
                            ),
                            AppSpaces.v10,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 0.45.screenWidth,
                                  child: AppDatePickerTextFormField(
                                    dateController: _controller
                                        .recievableStartDateController,
                                    hintText: 'Rec Start Date',
                                  ),
                                ),
                                SizedBox(
                                  width: 0.45.screenWidth,
                                  child: AppDatePickerTextFormField(
                                    dateController:
                                        _controller.recievableEndDateController,
                                    hintText: 'Rec End Date',
                                  ),
                                ),
                              ],
                            ),
                            AppSpaces.v10,
                            AppTextFormField(
                              controller: _controller.daysController,
                              hintText: 'Days',
                            ),
                            AppSpaces.v10,
                            Obx(
                              () => CheckboxListTile(
                                title: Text(
                                  'Only CD',
                                  style: TextStyles
                                      .kMediumSofiaSansSemiCondensed(),
                                ),
                                value: _controller.onlyCd.value,
                                onChanged: (bool? value) {
                                  if (value != null) {
                                    _controller.onlyCd.value = value;
                                  }
                                },
                                activeColor: kColorPrimary,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                            ),
                            Obx(
                              () => CheckboxListTile(
                                title: Text(
                                  'Due Date wise',
                                  style: TextStyles
                                      .kMediumSofiaSansSemiCondensed(),
                                ),
                                value: _controller.dueDateWise.value,
                                onChanged: (bool? value) {
                                  if (value != null) {
                                    _controller.dueDateWise.value = value;
                                  }
                                },
                                activeColor: kColorPrimary,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                            ),
                            AppSpaces.v20,
                            AppButton(
                              title: 'View Outstandings',
                              onPressed: () {
                                if (_controller.filterFormKey.currentState!
                                    .validate()) {
                                  _controller.toggleVisibility();
                                  _controller.getOutstandings();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        AppTextFormField(
                          controller: _controller.searchController,
                          hintText: 'Search Outstanding',
                          onChanged: (value) {
                            _controller.filterOutstandings(value);
                          },
                        ),
                        AppSpaces.v10,
                        Obx(
                          () {
                            if (_controller.isLoading.value) {
                              return const SizedBox.shrink();
                            }

                            final totalEntry = _controller.filteredOutstandings
                                .firstWhereOrNull(
                              (outstanding) =>
                                  outstanding.invNo.toLowerCase() == 'total',
                            );
                            final grandTotalEntry = _controller
                                .filteredOutstandings
                                .firstWhereOrNull(
                              (outstanding) =>
                                  outstanding.invNo.toLowerCase() ==
                                  'grand total',
                            );
                            final outstandingEntry = _controller
                                .filteredOutstandings
                                .firstWhereOrNull(
                              (outstanding) =>
                                  outstanding.invNo.toLowerCase() ==
                                  'outstanding',
                            );

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _controller.selectedCustomer.value,
                                  style: TextStyles
                                          .kRegularSofiaSansSemiCondensed()
                                      .copyWith(
                                    height: 1.25,
                                  ),
                                ),
                                if (totalEntry != null)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        totalEntry.invNo,
                                        style: TextStyles
                                            .kRegularSofiaSansSemiCondensed(
                                          color: kColorBlue,
                                        ),
                                      ),
                                      Text(
                                        '${totalEntry.amount}',
                                        style: TextStyles
                                            .kBoldSofiaSansSemiCondensed(
                                          color: kColorBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                if (grandTotalEntry != null)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        grandTotalEntry.invNo,
                                        style: TextStyles
                                            .kRegularSofiaSansSemiCondensed(
                                          color: kColorRed,
                                        ),
                                      ),
                                      Text(
                                        '${grandTotalEntry.amount}',
                                        style: TextStyles
                                            .kBoldSofiaSansSemiCondensed(
                                          color: kColorRed,
                                        ),
                                      ),
                                    ],
                                  ),
                                if (outstandingEntry != null)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        outstandingEntry.invNo,
                                        style: TextStyles
                                            .kRegularSofiaSansSemiCondensed(
                                          color: kColorBlue,
                                        ),
                                      ),
                                      Text(
                                        '${outstandingEntry.amount}',
                                        style: TextStyles
                                            .kBoldSofiaSansSemiCondensed(
                                          color: kColorBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            );
                          },
                        ),
                        AppSpaces.v10,
                        Obx(
                          () {
                            if (_controller.isLoading.value) {
                              return const SizedBox.shrink();
                            }
                            if (_controller.filteredOutstandings
                                    .where((outstanding) =>
                                        outstanding.invNo.toLowerCase() !=
                                            'total' &&
                                        outstanding.invNo.toLowerCase() !=
                                            'grand total' &&
                                        outstanding.invNo.toLowerCase() !=
                                            'outstanding')
                                    .isEmpty &&
                                !_controller.isLoading.value) {
                              return Expanded(
                                child: Center(
                                  child: Text(
                                    'No outstandings found.',
                                    style: TextStyles
                                        .kMediumSofiaSansSemiCondensed(),
                                  ),
                                ),
                              );
                            }
                            return Expanded(
                              child: ListView.builder(
                                itemCount: _controller.filteredOutstandings
                                    .where((outstanding) =>
                                        outstanding.invNo.toLowerCase() !=
                                            'total' &&
                                        outstanding.invNo.toLowerCase() !=
                                            'grand total' &&
                                        outstanding.invNo.toLowerCase() !=
                                            'outstanding')
                                    .length,
                                itemBuilder: (context, index) {
                                  final filteredOutOutstandings = _controller
                                      .filteredOutstandings
                                      .where((outstanding) =>
                                          outstanding.invNo.toLowerCase() !=
                                              'total' &&
                                          outstanding.invNo.toLowerCase() !=
                                              'grand total' &&
                                          outstanding.invNo.toLowerCase() !=
                                              'outstanding')
                                      .toList();
                                  final outstanding =
                                      filteredOutOutstandings[index];
                                  return AppCard(
                                    onTap: () {},
                                    child: Padding(
                                      padding: AppPaddings.p10,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          OutstandingRow(
                                            title: 'Type : ',
                                            value: outstanding.type,
                                            textColor: outstanding.remark
                                                    .toLowerCase()
                                                    .contains('pdc')
                                                ? kColorGreen
                                                : outstanding.days <= 0
                                                    ? kColorBlack
                                                    : kColorRed,
                                          ),
                                          OutstandingRow(
                                            title: 'Inv No : ',
                                            value: outstanding.invNo,
                                            textColor: outstanding.remark
                                                    .toLowerCase()
                                                    .contains('pdc')
                                                ? kColorGreen
                                                : outstanding.days <= 0
                                                    ? kColorBlack
                                                    : kColorRed,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              OutstandingRow(
                                                title: 'Date : ',
                                                value: outstanding.date,
                                                textColor: outstanding.remark
                                                        .toLowerCase()
                                                        .contains('pdc')
                                                    ? kColorGreen
                                                    : outstanding.days <= 0
                                                        ? kColorBlack
                                                        : kColorRed,
                                              ),
                                              OutstandingRow(
                                                title: 'Due Date : ',
                                                value: outstanding.dueDate,
                                                textColor: outstanding.remark
                                                        .toLowerCase()
                                                        .contains('pdc')
                                                    ? kColorGreen
                                                    : outstanding.days <= 0
                                                        ? kColorBlack
                                                        : kColorRed,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              OutstandingRow(
                                                title: 'Amount : ',
                                                value: outstanding.amount
                                                    .toString(),
                                                textColor: outstanding.remark
                                                        .toLowerCase()
                                                        .contains('pdc')
                                                    ? kColorGreen
                                                    : outstanding.days <= 0
                                                        ? kColorBlack
                                                        : kColorRed,
                                              ),
                                              OutstandingRow(
                                                title: 'Rec Amount : ',
                                                value: outstanding.recAmount
                                                    .toString(),
                                                textColor: outstanding.remark
                                                        .toLowerCase()
                                                        .contains('pdc')
                                                    ? kColorGreen
                                                    : outstanding.days <= 0
                                                        ? kColorBlack
                                                        : kColorRed,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              OutstandingRow(
                                                title: 'Balance : ',
                                                value: outstanding.balance
                                                    .toString(),
                                                textColor: outstanding.remark
                                                        .toLowerCase()
                                                        .contains('pdc')
                                                    ? kColorGreen
                                                    : outstanding.days <= 0
                                                        ? kColorBlack
                                                        : kColorRed,
                                              ),
                                              OutstandingRow(
                                                title: 'Days : ',
                                                value:
                                                    outstanding.days.toString(),
                                                textColor: outstanding.remark
                                                        .toLowerCase()
                                                        .contains('pdc')
                                                    ? kColorGreen
                                                    : outstanding.days <= 0
                                                        ? kColorBlack
                                                        : kColorRed,
                                              ),
                                            ],
                                          ),
                                          OutstandingRow(
                                            title: 'PONO : ',
                                            value: outstanding.pono,
                                            textColor: outstanding.remark
                                                    .toLowerCase()
                                                    .contains('pdc')
                                                ? kColorGreen
                                                : outstanding.days <= 0
                                                    ? kColorBlack
                                                    : kColorRed,
                                          ),
                                          if (outstanding.remark.isNotEmpty)
                                            OutstandingRow(
                                              title: 'Remark : ',
                                              value: outstanding.remark,
                                              textColor: outstanding.remark
                                                      .toLowerCase()
                                                      .contains('pdc')
                                                  ? kColorGreen
                                                  : outstanding.days <= 0
                                                      ? kColorBlack
                                                      : kColorRed,
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
        Obx(
          () => AppLoadingOverlay(
            isLoading: _controller.isLoading.value,
          ),
        ),
      ],
    );
  }
}

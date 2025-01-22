import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mohta_app/constants/color_constants.dart';
import 'package:mohta_app/features/outstandings/controllers/outstandings_controller.dart';
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
    await _controller.getParty();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                              items: _controller.partyNames,
                              hintText: 'Party',
                              onChanged: (value) {
                                _controller.onPartySelected(value!);
                              },
                              selectedItem:
                                  _controller.selectedParty.value.isNotEmpty
                                      ? _controller.selectedParty.value
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
                                  dateController:
                                      _controller.recievableStartDateController,
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
                                style:
                                    TextStyles.kMediumSofiaSansSemiCondensed(),
                              ),
                              value: _controller.onlyCd.value,
                              onChanged: (bool? value) {
                                if (value != null) {
                                  _controller.onlyCd.value = value;
                                }
                              },
                              activeColor: kColorPrimary,
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),
                          Obx(
                            () => CheckboxListTile(
                              title: Text(
                                'Due Date wise',
                                style:
                                    TextStyles.kMediumSofiaSansSemiCondensed(),
                              ),
                              value: _controller.dueDateWise.value,
                              onChanged: (bool? value) {
                                if (value != null) {
                                  _controller.dueDateWise.value = value;
                                }
                              },
                              activeColor: kColorPrimary,
                              controlAffinity: ListTileControlAffinity.leading,
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
                      Obx(
                        () => Expanded(
                          child: ListView.builder(
                            itemCount: _controller.outstandings
                                .where((outstanding) =>
                                    outstanding.invNo.toLowerCase() !=
                                        'total' &&
                                    outstanding.invNo.toLowerCase() !=
                                        'grand total' &&
                                    outstanding.invNo.toLowerCase() !=
                                        'outstanding')
                                .length,
                            itemBuilder: (context, index) {
                              final filteredOutstandings = _controller
                                  .outstandings
                                  .where((outstanding) =>
                                      outstanding.invNo.toLowerCase() !=
                                          'total' &&
                                      outstanding.invNo.toLowerCase() !=
                                          'grand total' &&
                                      outstanding.invNo.toLowerCase() !=
                                          'outstanding')
                                  .toList();
                              final outstanding = filteredOutstandings[index];
                              return AppCard(
                                onTap: () {},
                                child: Padding(
                                  padding: AppPaddings.p10,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        outstanding.invNo,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
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

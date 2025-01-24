import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mohta_app/constants/color_constants.dart';
import 'package:mohta_app/features/authentication/login/models/company_dm.dart';
import 'package:mohta_app/features/authentication/select_company/controllers/select_company_controller.dart';
import 'package:mohta_app/features/utils/screen_utils/app_paddings.dart';
import 'package:mohta_app/features/utils/screen_utils/app_spacings.dart';
import 'package:mohta_app/styles/font_sizes.dart';
import 'package:mohta_app/styles/text_styles.dart';
import 'package:mohta_app/widgets/app_button.dart';
import 'package:mohta_app/widgets/app_dropdown.dart';
import 'package:mohta_app/widgets/app_loading_overlay.dart';

class SelectCompanyScreen extends StatefulWidget {
  const SelectCompanyScreen({
    super.key,
    required this.companies,
    required this.mobileNumber,
  });

  final RxList<CompanyDm> companies;
  final String mobileNumber;

  @override
  State<SelectCompanyScreen> createState() => _SelectCompanyScreenState();
}

class _SelectCompanyScreenState extends State<SelectCompanyScreen> {
  final SelectCompanyController _controller = Get.put(
    SelectCompanyController(),
  );

  @override
  void initState() {
    super.initState();
    if (widget.companies.length == 1) {
      _controller.selectedCoName.value = widget.companies.first.coName;
      _controller.selectedCid.value = widget.companies.first.cid;

      _controller.getYears();
    }
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
            resizeToAvoidBottomInset: true,
            backgroundColor: kColorWhite,
            body: Center(
              child: SingleChildScrollView(
                padding: AppPaddings.ph30,
                child: Form(
                  key: _controller.selectCompanyFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Company',
                        style: TextStyles.kRegularSofiaSansSemiCondensed(
                          fontSize: FontSizes.k40FontSize,
                        ),
                      ),
                      AppSpaces.v30,
                      Obx(
                        () => AppDropdown(
                          items: widget.companies
                              .map(
                                (com) => com.coName,
                              )
                              .toList(),
                          hintText: 'Select Company',
                          onChanged: (value) {
                            _controller.selectedCoName.value = value!;
                            _controller.selectedCid.value = widget.companies
                                .firstWhere(
                                  (company) => company.coName == value,
                                )
                                .cid;

                            if (widget.companies.length > 1) {
                              _controller.getYears();
                            }
                          },
                          selectedItem:
                              _controller.selectedCoName.value.isNotEmpty
                                  ? _controller.selectedCoName.value
                                  : null,
                          validatorText: 'Please select a company',
                        ),
                      ),
                      AppSpaces.v16,
                      Obx(
                        () => AppDropdown(
                          items: _controller.finYears,
                          hintText: 'Fin Year',
                          onChanged: (value) =>
                              _controller.onYearSelected(value!),
                          selectedItem:
                              _controller.selectedFinYear.value.isNotEmpty
                                  ? _controller.selectedFinYear.value
                                  : null,
                          validatorText: 'Please select a financial year',
                        ),
                      ),
                      AppSpaces.v30,
                      AppButton(
                        title: 'Continue',
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (_controller.selectCompanyFormKey.currentState!
                              .validate()) {
                            _controller.getToken(
                              mobileNumber: widget.mobileNumber,
                              cid: _controller.selectedCid.value!,
                              yearId: _controller.selectedYearId.value,
                            );
                          }
                        },
                      ),
                      AppSpaces.v20,
                    ],
                  ),
                ),
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

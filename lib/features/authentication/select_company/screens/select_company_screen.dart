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

class SelectCompanyScreen extends StatelessWidget {
  SelectCompanyScreen({
    super.key,
    required this.companies,
    required this.mobileNumber,
  });

  final RxList<CompanyDm> companies;
  final String mobileNumber;

  final SelectCompanyController _controller = Get.put(
    SelectCompanyController(),
  );

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
                        style: TextStyles.kSemiBoldSofiaSansSemiCondensed(
                          fontSize: FontSizes.k36FontSize,
                        ),
                      ),
                      AppSpaces.v40,
                      AppDropdown(
                        items: companies
                            .map(
                              (com) => com.coName,
                            )
                            .toList(),
                        hintText: 'Select Company',
                        onChanged: (value) {
                          _controller.selectedCoName.value = value!;
                          _controller.selectedCid.value = companies
                              .firstWhere(
                                (company) => company.coName == value,
                              )
                              .cid;
                        },
                        selectedItem:
                            _controller.selectedCoName.value.isNotEmpty
                                ? _controller.selectedCoName.value
                                : null,
                      ),
                      AppSpaces.v40,
                      AppButton(
                        title: 'Continue',
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (_controller.selectCompanyFormKey.currentState!
                              .validate()) {}
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

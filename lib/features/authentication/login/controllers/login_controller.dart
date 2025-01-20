import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mohta_app/features/authentication/login/models/company_dm.dart';
import 'package:mohta_app/features/authentication/login/repositories/login_repo.dart';
import 'package:mohta_app/features/authentication/select_company/screens/select_company_screen.dart';
import 'package:mohta_app/features/item_help/screens/item_help_screen.dart';
import 'package:mohta_app/features/utils/dialogs/app_dialogs.dart';
import 'package:mohta_app/features/utils/helpers/device_helper.dart';
import 'package:mohta_app/features/utils/helpers/secure_storage_helper.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;

  var mobileNumberController = TextEditingController();
  var passwordController = TextEditingController();

  var hasAttemptedLogin = false.obs;
  final loginFormKey = GlobalKey<FormState>();

  var obscuredText = true.obs;
  void togglePasswordVisibility() {
    obscuredText.value = !obscuredText.value;
  }

  var companies = <CompanyDm>[].obs;

  @override
  void onInit() {
    super.onInit();
    setupValidationListeners();
  }

  void setupValidationListeners() {
    mobileNumberController.addListener(validateForm);
    passwordController.addListener(validateForm);
  }

  void validateForm() {
    if (hasAttemptedLogin.value) {
      loginFormKey.currentState?.validate();
    }
  }

  Future<void> loginUser() async {
    isLoading.value = true;
    String? deviceId = await DeviceHelper().getDeviceId();
    if (deviceId == null) {
      showErrorSnackbar(
        'Login Failed',
        'Unable to fetch device ID.',
      );
      isLoading.value = false;
      return;
    }

    try {
      final fetchedCompanies = await LoginRepo.loginUser(
        mobileNo: mobileNumberController.text,
        password: passwordController.text,
        fcmToken: '',
        deviceId: deviceId,
      );
      companies.assignAll(fetchedCompanies);

      if (companies.isNotEmpty && companies.length == 1) {
        getToken();
      } else if (companies.length > 1) {
        Get.to(
          () => SelectCompanyScreen(
            companies: companies,
            mobileNumber: mobileNumberController.text,
          ),
        );
      } else {
        showErrorSnackbar(
          'Login Failed',
          'No companies found for the user.',
        );
      }
    } catch (e) {
      if (e is Map<String, dynamic>) {
        showErrorSnackbar(
          'Error',
          e['message'],
        );
      } else {
        showErrorSnackbar(
          'Error',
          e.toString(),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getToken() async {
    isLoading.value = true;

    try {
      var response = await LoginRepo.getToken(
        mobileNumber: mobileNumberController.text,
        cid: companies.first.cid,
      );

      await SecureStorageHelper.write(
        'token',
        response['token'],
      );
      await SecureStorageHelper.write(
        'firstName',
        response['fullName'],
      );
      await SecureStorageHelper.write(
        'userType',
        response['userType'].toString(),
      );
      await SecureStorageHelper.write(
        'userId',
        response['userId'].toString(),
      );
      await SecureStorageHelper.write(
        'ledgerStart',
        response['ledgerStart'] ?? '',
      );
      await SecureStorageHelper.write(
        'ledgerEnd',
        response['ledgerEnd'] ?? '',
      );

      Get.offAll(
        () => ItemHelpScreen(),
      );
    } catch (e) {
      if (e is Map<String, dynamic>) {
        showErrorSnackbar(
          'Error',
          e['message'],
        );
      } else {
        showErrorSnackbar(
          'Error',
          e.toString(),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mohta_app/features/authentication/select_company/repositories/select_company_repo.dart';
import 'package:mohta_app/features/item_help/screens/item_help_screen.dart';
import 'package:mohta_app/features/utils/dialogs/app_dialogs.dart';
import 'package:mohta_app/features/utils/helpers/secure_storage_helper.dart';

class SelectCompanyController extends GetxController {
  var isLoading = false.obs;

  final selectCompanyFormKey = GlobalKey<FormState>();
  var selectedCid = Rxn<int>();
  var selectedCoName = ''.obs;

  Future<void> getToken({
    required String mobileNumber,
    required int cid,
  }) async {
    isLoading.value = true;

    try {
      var response = await SelectCompanyRepo.getToken(
        mobileNumber: mobileNumber,
        cid: cid,
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

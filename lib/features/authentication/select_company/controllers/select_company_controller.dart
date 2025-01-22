import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mohta_app/features/authentication/select_company/models/year_dm.dart';
import 'package:mohta_app/features/authentication/select_company/repositories/select_company_repo.dart';
import 'package:mohta_app/features/home/screens/home_screen.dart';
import 'package:mohta_app/features/utils/dialogs/app_dialogs.dart';
import 'package:mohta_app/features/utils/helpers/secure_storage_helper.dart';

class SelectCompanyController extends GetxController {
  var isLoading = false.obs;

  final selectCompanyFormKey = GlobalKey<FormState>();
  var selectedCid = Rxn<int>();
  var selectedCoName = ''.obs;

  var years = <YearDm>[].obs;
  var finYears = <String>[].obs;
  var selectedFinYear = ''.obs;
  var selectedYearId = 0.obs;

  Future<void> getYears() async {
    try {
      isLoading.value = true;

      final fetchedYears = await SelectCompanyRepo.getYears(
        coCode: selectedCid.value!,
      );

      years.assignAll(fetchedYears);
      finYears.assignAll(
        fetchedYears
            .map(
              (year) => year.finYear,
            )
            .toList(),
      );
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onYearSelected(String finYear) {
    selectedFinYear.value = finYear;

    var yearObj = years.firstWhere(
      (year) => year.finYear == finYear,
    );

    selectedYearId.value = yearObj.yearId;
  }

  Future<void> getToken({
    required String mobileNumber,
    required int cid,
    required int yearId,
  }) async {
    isLoading.value = true;

    try {
      var response = await SelectCompanyRepo.getToken(
        mobileNumber: mobileNumber,
        cid: cid,
        yearId: yearId,
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
        () => HomeScreen(
          companyName: selectedCoName.value,
        ),
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

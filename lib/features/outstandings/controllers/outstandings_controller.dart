import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mohta_app/features/outstandings/models/customer_dm.dart';
import 'package:mohta_app/features/outstandings/models/outstanding_dm.dart';
import 'package:mohta_app/features/outstandings/repositories/outstandings_repo.dart';
import 'package:mohta_app/features/outstandings/screens/outstandings_pdf_screen.dart';
import 'package:mohta_app/features/utils/dialogs/app_dialogs.dart';

class OutstandingsController extends GetxController {
  var isLoading = false.obs;

  var isFilterScreenVisible = true.obs;
  void toggleVisibility() {
    isFilterScreenVisible.value = !isFilterScreenVisible.value;
  }

  final filterFormKey = GlobalKey<FormState>();

  var customers = <CustomerDm>[].obs;
  var customerNames = <String>[].obs;
  var selectedCustomer = ''.obs;
  var selectedCustomerCode = ''.obs;

  var billStartDateController = TextEditingController();
  var billEndDateController = TextEditingController();
  var recievableStartDateController = TextEditingController();
  var recievableEndDateController = TextEditingController();
  var daysController = TextEditingController();
  var onlyCd = false.obs;
  var dueDateWise = false.obs;

  var outstandings = <OutstandingDm>[].obs;
  var filteredOutstandings = <OutstandingDm>[].obs;
  var searchController = TextEditingController();

  Future<void> getCustomers() async {
    try {
      isLoading.value = true;

      final fetchedCustomers = await OutstandingsRepo.getCustomers();

      customers.assignAll(fetchedCustomers);
      customerNames.assignAll(
        fetchedCustomers
            .map(
              (cust) => cust.pName,
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

  void onCustomerSelected(String customerName) {
    selectedCustomer.value = customerName;

    var customerObj = customers.firstWhere(
      (cust) => cust.pName == customerName,
    );

    selectedCustomerCode.value = customerObj.pCode;
  }

  Future<void> getOutstandings() async {
    isLoading.value = true;

    try {
      final fetchedOutstandings = await OutstandingsRepo.getOutstandings(
        pCode: selectedCustomerCode.value,
        billStartDate: DateFormat('yyyy-MM-dd').format(
          DateFormat('dd-MM-yyyy').parse(billStartDateController.text),
        ),
        billEndDate: DateFormat('yyyy-MM-dd').format(
          DateFormat('dd-MM-yyyy').parse(billEndDateController.text),
        ),
        recStartDate: DateFormat('yyyy-MM-dd').format(
          DateFormat('dd-MM-yyyy').parse(recievableStartDateController.text),
        ),
        recEndDate: DateFormat('yyyy-MM-dd').format(
          DateFormat('dd-MM-yyyy').parse(recievableEndDateController.text),
        ),
        days: daysController.text.isNotEmpty ? daysController.text : '0',
        onlyCd: onlyCd.value,
        dueDateWise: dueDateWise.value,
      );

      outstandings.assignAll(fetchedOutstandings);
      filteredOutstandings.assignAll(fetchedOutstandings);
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void filterOutstandings(String query) {
    filteredOutstandings.assignAll(
      outstandings.where(
        (outstanding) {
          return outstanding.invNo.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
              outstanding.type.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
              outstanding.pono.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
              outstanding.remark.toLowerCase().contains(
                    query.toLowerCase(),
                  );
        },
      ).toList(),
    );
  }

  Future<void> downloadOutstandings() async {
    try {
      isLoading.value = true;
      final pdfBytes = await OutstandingsRepo.downloadOutstandings(
        pCode: selectedCustomerCode.value,
        billStartDate: DateFormat('yyyy-MM-dd').format(
          DateFormat('dd-MM-yyyy').parse(billStartDateController.text),
        ),
        billEndDate: DateFormat('yyyy-MM-dd').format(
          DateFormat('dd-MM-yyyy').parse(billEndDateController.text),
        ),
        recStartDate: DateFormat('yyyy-MM-dd').format(
          DateFormat('dd-MM-yyyy').parse(recievableStartDateController.text),
        ),
        recEndDate: DateFormat('yyyy-MM-dd').format(
          DateFormat('dd-MM-yyyy').parse(recievableEndDateController.text),
        ),
        days: daysController.text.isNotEmpty ? daysController.text : '0',
        onlyCd: onlyCd.value,
        dueDateWise: dueDateWise.value,
      );

      if (pdfBytes != null && pdfBytes.isNotEmpty) {
        Get.to(
          () => OutstandingsPdfScreen(
            pdfBytes: pdfBytes,
            title: selectedCustomer.value,
          ),
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
}

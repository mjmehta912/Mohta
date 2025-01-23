import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mohta_app/features/ledger/models/ledger_dm.dart';
import 'package:mohta_app/features/ledger/repositories/ledger_repo.dart';
import 'package:mohta_app/features/outstandings/models/customer_dm.dart';
import 'package:mohta_app/features/utils/dialogs/app_dialogs.dart';

class LedgerController extends GetxController {
  var isLoading = false.obs;

  var customers = <CustomerDm>[].obs;
  var customerNames = <String>[].obs;
  var selectedCustomer = ''.obs;
  var selectedCustomerCode = ''.obs;
  var fromDateController = TextEditingController();
  var toDateController = TextEditingController();
  var showBillDtl = false.obs;
  var showItemDtl = false.obs;
  var showSign = true.obs;

  var ledgerData = <LedgerDm>[].obs;

  Future<void> getCustomers() async {
    try {
      isLoading.value = true;

      final fetchedCustomers = await LedgerRepo.getCustomers();

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

    getLedger();
  }

  Future<void> getLedger() async {
    try {
      isLoading.value = true;

      final fetchedLedger = await LedgerRepo.getLedger(
        fromDate: DateFormat('yyyy-MM-dd').format(
          DateFormat('dd-MM-yyyy').parse(fromDateController.text),
        ),
        toDate: DateFormat('yyyy-MM-dd').format(
          DateFormat('dd-MM-yyyy').parse(toDateController.text),
        ),
        pCode: selectedCustomerCode.value,
        billDtl: showBillDtl.value,
        itemDtl: showItemDtl.value,
        sign: showSign.value,
      );

      ledgerData.assignAll(fetchedLedger);
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

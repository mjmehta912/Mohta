import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mohta_app/features/outstandings/models/customer_dm.dart';
import 'package:mohta_app/features/outstandings/models/outstanding_dm.dart';
import 'package:mohta_app/features/outstandings/models/salesman_dm.dart';
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

  var salesmen = <SalesmanDm>[].obs;
  var salesmanNames = <String>[].obs;
  var selectedSalesman = ''.obs;
  var selectedSalesmanCode = ''.obs;

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
  var totalBalance = 0.0.obs;

  Future<void> getSalesman() async {
    try {
      isLoading.value = true;

      final fetchedSalesmen = await OutstandingsRepo.getSalesmen();

      salesmen.assignAll(fetchedSalesmen);
      salesmanNames.assignAll(
        fetchedSalesmen
            .map(
              (se) => se.seName,
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

  void onSalesmanSelected(String seName) {
    selectedSalesman.value = seName;

    var salesmanObj = salesmen.firstWhere(
      (se) => se.seName == seName,
    );

    selectedSalesmanCode.value = salesmanObj.seCode;
  }

  Future<void> getCustomers() async {
    try {
      isLoading.value = true;

      selectedCustomer.value = '';
      selectedCustomerCode.value = '';

      final fetchedCustomers = await OutstandingsRepo.getCustomers(
        seCode: selectedSalesmanCode.value,
        fromDate: DateFormat('yyyy-MM-dd').format(
          DateFormat('dd-MM-yyyy').parse(billStartDateController.text),
        ),
        toDate: DateFormat('yyyy-MM-dd').format(
          DateFormat('dd-MM-yyyy').parse(billEndDateController.text),
        ),
        colFromDate: DateFormat('yyyy-MM-dd').format(
          DateFormat('dd-MM-yyyy').parse(recievableStartDateController.text),
        ),
        colTodate: DateFormat('yyyy-MM-dd').format(
          DateFormat('dd-MM-yyyy').parse(recievableEndDateController.text),
        ),
        dueDatewise: dueDateWise.value,
        cdBillwise: onlyCd.value,
        days:
            daysController.text.isNotEmpty ? int.parse(daysController.text) : 0,
      );

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

    getOutstandings();
  }

  void onPreviousCustomer() {
    final currentIndex = customerNames.indexOf(selectedCustomer.value);
    if (currentIndex > 0) {
      selectedCustomer.value = customerNames[currentIndex - 1];
      selectedCustomerCode.value = customers[currentIndex - 1].pCode;
      getOutstandings();
    }
  }

  void onNextCustomer() {
    final currentIndex = customerNames.indexOf(selectedCustomer.value);
    if (currentIndex < customerNames.length - 1) {
      selectedCustomer.value = customerNames[currentIndex + 1];
      selectedCustomerCode.value = customers[currentIndex + 1].pCode;
      getOutstandings();
    }
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

      totalBalance.value = outstandings
              .where((e) => e.type == 'SAL')
              .fold(0.0, (sum, e) => sum + e.balance) -
          outstandings
              .where((e) => e.type == 'REC')
              .fold(0.0, (sum, e) => sum + e.balance);
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mohta_app/features/item_help/models/party_dm.dart';
import 'package:mohta_app/features/outstandings/models/outstanding_dm.dart';
import 'package:mohta_app/features/outstandings/repositories/outstandings_repo.dart';
import 'package:mohta_app/features/utils/dialogs/app_dialogs.dart';

class OutstandingsController extends GetxController {
  var isLoading = false.obs;

  var isFilterScreenVisible = true.obs;
  void toggleVisibility() {
    isFilterScreenVisible.value = !isFilterScreenVisible.value;
  }

  final filterFormKey = GlobalKey<FormState>();

  var parties = <PartyDm>[].obs;
  var partyNames = <String>[].obs;
  var selectedParty = ''.obs;
  var selectedPartyCode = ''.obs;

  var billStartDateController = TextEditingController();
  var billEndDateController = TextEditingController();
  var recievableStartDateController = TextEditingController();
  var recievableEndDateController = TextEditingController();
  var daysController = TextEditingController();
  var onlyCd = false.obs;
  var dueDateWise = false.obs;

  var outstandings = <OutstandingDm>[].obs;

  Future<void> getParty() async {
    try {
      isLoading.value = true;

      final fetchedParties = await OutstandingsRepo.getParty();

      parties.assignAll(fetchedParties);
      partyNames.assignAll(
        fetchedParties
            .map(
              (party) => party.pName,
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

  void onPartySelected(String partyName) {
    selectedParty.value = partyName;

    var partyObj = parties.firstWhere(
      (party) => party.pName == partyName,
    );

    selectedPartyCode.value = partyObj.pCode;
  }

  Future<void> getOutstandings() async {
    isLoading.value = true;

    try {
      final fetchedOutstandings = await OutstandingsRepo.getOutstandings(
        pCode: selectedPartyCode.value,
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
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}

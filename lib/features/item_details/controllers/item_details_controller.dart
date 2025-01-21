import 'package:get/get.dart';

import 'package:mohta_app/features/item_details/models/item_details_dm.dart';
import 'package:mohta_app/features/item_details/repositories/item_details_repo.dart';
import 'package:mohta_app/features/utils/dialogs/app_dialogs.dart';

class ItemDetailsController extends GetxController {
  var isLoading = false.obs;
  var priceList = <PriceDm>[].obs;
  var companyStockList = <CompanyStockDm>[].obs;
  var totalStockList = <TotalStockDm>[].obs;

  Future<void> getItemDetail({
    required String prCode,
    required String iCode,
  }) async {
    try {
      isLoading.value = true;
      final fetchedItemDetail = await ItemDetailsRepo.getItemDetail(
        prCode: prCode,
        iCode: iCode,
      );
      priceList.assignAll(fetchedItemDetail.priceDmData);
      companyStockList.assignAll(fetchedItemDetail.companyStockData);
      totalStockList.assignAll(fetchedItemDetail.totalStockData);
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

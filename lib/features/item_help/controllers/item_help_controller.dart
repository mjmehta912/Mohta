import 'package:get/get.dart';
import 'package:mohta_app/features/item_help/models/desc_dm.dart';
import 'package:mohta_app/features/item_help/models/make_dm.dart';
import 'package:mohta_app/features/item_help/models/party_dm.dart';
import 'package:mohta_app/features/item_help/models/primary_group_dm.dart';
import 'package:mohta_app/features/item_help/models/product_dm.dart';
import 'package:mohta_app/features/item_help/models/secondary_group_dm.dart';
import 'package:mohta_app/features/item_help/repositories/item_help_repo.dart';
import 'package:mohta_app/features/items/screens/items_screen.dart';
import 'package:mohta_app/features/utils/dialogs/app_dialogs.dart';

class ItemHelpController extends GetxController {
  var isLoading = false.obs;

  var parties = <PartyDm>[].obs;
  var selectedParty = ''.obs;
  var selectedPartyCode = ''.obs;

  var products = <ProductDm>[].obs;
  var descData = <DescDm>[].obs;
  var selectedProduct = ''.obs;
  var selectedProductCode = ''.obs;
  var nonEmptyDescs = <String, String>{}.obs;
  var selectedValues = <String, DescDm?>{}.obs;
  void updateSelectedValue(
    String desc,
    DescDm selectedDesc,
  ) {
    selectedValues[desc] = selectedDesc;
  }

  var makes = <MakeDm>[].obs;
  var selectedMake = ''.obs;
  var selectedMakeCode = ''.obs;

  var primaryGroups = <PrimaryGroupDm>[].obs;
  var selectedPrimaryGroup = ''.obs;
  var selectedPrimaryGroupCode = ''.obs;

  var secondaryGroups = <SecondaryGroupDm>[].obs;
  var selectedSecondaryGroup = ''.obs;
  var selectedSecondaryGroupCode = ''.obs;

  var items = <Map<String, dynamic>>[].obs;

  Future<void> getParty() async {
    try {
      isLoading.value = true;

      final fetchedParties = await ItemHelpRepo.getParty();

      parties.assignAll(fetchedParties);
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getProduct() async {
    try {
      isLoading.value = true;

      final fetchedProducts = await ItemHelpRepo.getProduct();

      products.assignAll(fetchedProducts);
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getGeneralDropdown({
    required String desc,
  }) async {
    try {
      isLoading.value = true;

      final fetchedGeneralDropdown = await ItemHelpRepo.getGeneralDropdown(
        prCode: selectedProductCode.value,
        bCode: selectedMakeCode.value.isNotEmpty ? selectedMakeCode.value : '',
        desc: desc,
      );

      descData.assignAll(fetchedGeneralDropdown);
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getMake() async {
    try {
      isLoading.value = true;

      final fetchedMakes = await ItemHelpRepo.getMake(
        prCode: selectedProductCode.value,
      );

      makes.assignAll(fetchedMakes);
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getPrimaryGroups() async {
    try {
      isLoading.value = true;

      final fetchedPrimaryGroups = await ItemHelpRepo.getPrimaryGroup(
        prCode: selectedProductCode.value,
      );

      primaryGroups.assignAll(fetchedPrimaryGroups);
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getSecondaryGroups() async {
    try {
      isLoading.value = true;

      final fetchedSecondaryGroups = await ItemHelpRepo.getSecondaryGroup(
        prCode: selectedProductCode.value,
      );

      secondaryGroups.assignAll(fetchedSecondaryGroups);
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getItems() async {
    try {
      isLoading.value = true;

      final fetchedItems = await ItemHelpRepo.getItems(
        prCode: selectedProductCode.value.isNotEmpty
            ? selectedProductCode.value
            : '',
        bCode: selectedMakeCode.value.isNotEmpty ? selectedMakeCode.value : '',
        mCode: selectedPrimaryGroupCode.value.isNotEmpty
            ? selectedPrimaryGroupCode.value
            : '',
        igCode: selectedSecondaryGroupCode.value.isNotEmpty
            ? selectedSecondaryGroupCode.value
            : '',
        catRef: '',
        selectedValues: selectedValues,
      );

      items.assignAll(fetchedItems);

      if (items.isNotEmpty) {
        Get.to(
          () => ItemsScreen(
            items: items,
          ),
        );
      } else {
        showErrorSnackbar('Oops!', 'No items found');
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

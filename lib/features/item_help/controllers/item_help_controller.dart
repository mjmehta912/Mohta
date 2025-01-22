import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mohta_app/features/authentication/login/screens/login_screen.dart';
import 'package:mohta_app/features/item_help/models/desc_dm.dart';
import 'package:mohta_app/features/item_help/models/make_dm.dart';
import 'package:mohta_app/features/item_help/models/party_dm.dart';
import 'package:mohta_app/features/item_help/models/primary_group_dm.dart';
import 'package:mohta_app/features/item_help/models/product_dm.dart';
import 'package:mohta_app/features/item_help/models/secondary_group_dm.dart';
import 'package:mohta_app/features/item_help/repositories/item_help_repo.dart';
import 'package:mohta_app/features/items/screens/items_screen.dart';
import 'package:mohta_app/features/utils/dialogs/app_dialogs.dart';
import 'package:mohta_app/features/utils/helpers/secure_storage_helper.dart';

class ItemHelpController extends GetxController {
  var isLoading = false.obs;
  var isItemsLoading = false.obs;

  var parties = <PartyDm>[].obs;
  var filteredParties = <PartyDm>[].obs;
  var selectedParty = ''.obs;
  var selectedPartyCode = ''.obs;
  var searchPartyController = TextEditingController();

  var products = <ProductDm>[].obs;
  var filteredProducts = <ProductDm>[].obs;
  var descData = <DescDm>[].obs;
  var filteredDescData = <DescDm>[].obs;
  var selectedProduct = ''.obs;
  var selectedProductCode = ''.obs;
  var searchProductController = TextEditingController();
  var nonEmptyDescs = <String, String>{}.obs;
  var selectedValues = <String, DescDm?>{}.obs;
  void updateSelectedValue(
    String desc,
    DescDm selectedDesc,
  ) {
    selectedValues[desc] = selectedDesc;
  }

  var searchDescController = TextEditingController();

  var makes = <MakeDm>[].obs;
  var filteredMakes = <MakeDm>[].obs;
  var selectedMake = ''.obs;
  var selectedMakeCode = ''.obs;
  var searchMakeController = TextEditingController();

  var primaryGroups = <PrimaryGroupDm>[].obs;
  var filteredPrimaryGroups = <PrimaryGroupDm>[].obs;
  var selectedPrimaryGroup = ''.obs;
  var selectedPrimaryGroupCode = ''.obs;
  var searchPrimaryGroupController = TextEditingController();

  var secondaryGroups = <SecondaryGroupDm>[].obs;
  var filteredSecondaryGroups = <SecondaryGroupDm>[].obs;
  var selectedSecondaryGroup = ''.obs;
  var selectedSecondaryGroupCode = ''.obs;
  var searchSecondaryGroupController = TextEditingController();

  var items = <Map<String, dynamic>>[].obs;

  Future<void> getParty() async {
    try {
      isLoading.value = true;

      final fetchedParties = await ItemHelpRepo.getParty();

      parties.assignAll(fetchedParties);
      filteredParties.assignAll(fetchedParties);
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void filterParties(String query) {
    filteredParties.assignAll(
      parties.where(
        (party) {
          return party.pName.toLowerCase().contains(
                query.toLowerCase(),
              );
        },
      ).toList(),
    );
  }

  Future<void> getProduct() async {
    try {
      isLoading.value = true;

      final fetchedProducts = await ItemHelpRepo.getProduct();

      products.assignAll(fetchedProducts);
      filteredProducts.assignAll(fetchedProducts);
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void filterProducts(String query) {
    filteredProducts.assignAll(
      products.where(
        (product) {
          return product.prName.toLowerCase().contains(
                query.toLowerCase(),
              );
        },
      ).toList(),
    );
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
      filteredDescData.assignAll(fetchedGeneralDropdown);
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void filterDescData(String query) {
    filteredDescData.assignAll(
      descData.where(
        (desc) {
          return desc.name.toLowerCase().contains(
                query.toLowerCase(),
              );
        },
      ).toList(),
    );
  }

  Future<void> getMake() async {
    try {
      isLoading.value = true;

      final fetchedMakes = await ItemHelpRepo.getMake(
        prCode: selectedProductCode.value,
      );

      makes.assignAll(fetchedMakes);
      filteredMakes.assignAll(fetchedMakes);
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void filterMakes(String query) {
    filteredMakes.assignAll(
      makes.where(
        (make) {
          return make.bName.toLowerCase().contains(
                query.toLowerCase(),
              );
        },
      ).toList(),
    );
  }

  Future<void> getPrimaryGroups() async {
    try {
      isLoading.value = true;

      final fetchedPrimaryGroups = await ItemHelpRepo.getPrimaryGroup(
        prCode: selectedProductCode.value,
      );

      primaryGroups.assignAll(fetchedPrimaryGroups);
      filteredPrimaryGroups.assignAll(fetchedPrimaryGroups);
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void filterPrimaryGroups(String query) {
    filteredPrimaryGroups.assignAll(
      primaryGroups.where(
        (pg) {
          return pg.mName.toLowerCase().contains(
                query.toLowerCase(),
              );
        },
      ).toList(),
    );
  }

  Future<void> getSecondaryGroups() async {
    try {
      isLoading.value = true;

      final fetchedSecondaryGroups = await ItemHelpRepo.getSecondaryGroup(
        prCode: selectedProductCode.value,
        mCode: selectedPrimaryGroupCode.value.isNotEmpty
            ? selectedPrimaryGroupCode.value
            : '',
      );

      secondaryGroups.assignAll(fetchedSecondaryGroups);
      filteredSecondaryGroups.assignAll(fetchedSecondaryGroups);
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void filterSecondaryGroups(String query) {
    filteredSecondaryGroups.assignAll(
      secondaryGroups.where(
        (sg) {
          return sg.igName.toLowerCase().contains(
                query.toLowerCase(),
              );
        },
      ).toList(),
    );
  }

  Future<void> getItems() async {
    try {
      isItemsLoading.value = true;

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
            prCode: selectedProductCode.value,
            pCode: selectedPartyCode.value,
          ),
        );
      } else {
        showErrorSnackbar(
          'Oops!',
          'No items found',
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
      isItemsLoading.value = false;
    }
  }

  Future<void> logoutUser() async {
    isLoading.value = true;
    try {
      await SecureStorageHelper.clearAll();

      Get.offAll(
        () => LoginScreen(),
      );

      showSuccessSnackbar(
        'Logged Out',
        'You have been successfully logged out.',
      );
    } catch (e) {
      showErrorSnackbar(
        'Logout Failed',
        'Something went wrong. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }
}

import 'package:get/get.dart';
import 'package:mohta_app/features/item_help/models/desc_dm.dart';
import 'package:mohta_app/features/item_help/models/make_dm.dart';
import 'package:mohta_app/features/item_help/models/party_dm.dart';
import 'package:mohta_app/features/item_help/models/primary_group_dm.dart';
import 'package:mohta_app/features/item_help/models/product_dm.dart';
import 'package:mohta_app/features/item_help/models/secondary_group_dm.dart';
import 'package:mohta_app/features/utils/helpers/secure_storage_helper.dart';
import 'package:mohta_app/services/api_service.dart';

class ItemHelpRepo {
  static Future<List<PartyDm>> getParty() async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/ItemHelp/party',
        token: token,
      );
      if (response == null) {
        return [];
      }

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => PartyDm.fromJson(item),
            )
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<ProductDm>> getProduct() async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/ItemHelp/product',
        token: token,
      );
      if (response == null) {
        return [];
      }

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => ProductDm.fromJson(item),
            )
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<MakeDm>> getMake({
    required String prCode,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/ItemHelp/make',
        queryParams: {
          'PRCODE': prCode,
        },
        token: token,
      );
      if (response == null) {
        return [];
      }

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => MakeDm.fromJson(item),
            )
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<PrimaryGroupDm>> getPrimaryGroup({
    required String prCode,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/ItemHelp/primary',
        queryParams: {
          'PRCODE': prCode,
        },
        token: token,
      );
      if (response == null) {
        return [];
      }

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => PrimaryGroupDm.fromJson(item),
            )
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<SecondaryGroupDm>> getSecondaryGroup({
    required String prCode,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/ItemHelp/secondary',
        queryParams: {
          'PRCODE': prCode,
        },
        token: token,
      );
      if (response == null) {
        return [];
      }

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => SecondaryGroupDm.fromJson(item),
            )
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<DescDm>> getGeneralDropdown({
    required String prCode,
    required String bCode,
    required String desc,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/ItemHelp/dropdownValue',
        queryParams: {
          'PRCODE': prCode,
          'BCODE': bCode,
          'DescValue': desc,
        },
        token: token,
      );
      if (response == null) {
        return [];
      }

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => DescDm.fromJson(item),
            )
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getItems({
    required String prCode,
    required String bCode,
    required String mCode,
    required String igCode,
    required String catRef,
    required RxMap<String, DescDm?> selectedValues,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );
    try {
      Map<String, dynamic> requestBody = {
        "PRCODE": prCode,
        "BCODE": bCode,
        "MCODE": mCode,
        "IGCODE": igCode,
        "DESC1": selectedValues['DESC1']?.name ?? "",
        "DESC2": selectedValues['DESC2']?.name ?? "",
        "DESC3": selectedValues['DESC3']?.name ?? "",
        "DESC4": selectedValues['DESC4']?.name ?? "",
        "DESC5": selectedValues['DESC5']?.name ?? "",
        "DESC6": selectedValues['DESC6']?.name ?? "",
        "DESC7": selectedValues['DESC7']?.name ?? "",
        "DESC8": selectedValues['DESC8']?.name ?? "",
        "DESC9": selectedValues['DESC9']?.name ?? "",
        "DESC10": selectedValues['DESC10']?.name ?? "",
        "DESC11": selectedValues['DESC11']?.name ?? "",
        "DESC12": selectedValues['DESC12']?.name ?? "",
        "CATREF": catRef
      };

      print(requestBody);

      final response = await ApiService.postRequest(
        endpoint: '/ItemHelp/item',
        requestBody: requestBody,
        token: token,
      );

      if (response['data'] != null) {
        return List<Map<String, dynamic>>.from(
          response['data'],
        );
      }

      return [];
    } catch (e) {
      if (e is Map<String, dynamic>) {
        rethrow;
      }
      throw {
        'status': 500,
        'message': e.toString(),
      };
    }
  }
}

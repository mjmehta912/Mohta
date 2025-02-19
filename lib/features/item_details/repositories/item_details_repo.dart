import 'package:mohta_app/features/item_details/models/godown_stock_dm.dart';
import 'package:mohta_app/features/item_details/models/item_details_dm.dart';
import 'package:mohta_app/features/item_details/models/item_stock_dm.dart';
import 'package:mohta_app/features/utils/helpers/secure_storage_helper.dart';
import 'package:mohta_app/services/api_service.dart';

class ItemDetailsRepo {
  static Future<ItemDetailDm> getItemDetail({
    required String prCode,
    required String iCode,
    required String pCode,
  }) async {
    String? token = await SecureStorageHelper.read('token');
    try {
      Map<String, dynamic> requestBody = {
        "PRCODE": prCode,
        "ICODE": iCode,
        "PCODE": pCode
      };
      final response = await ApiService.postRequest(
        endpoint: '/ItemHelp/itemDtl',
        requestBody: requestBody,
        token: token,
      );
      List<PriceDm> priceDmData = [];
      List<CompanyStockDm> companyStockData = [];

      if (response['data'] != null) {
        priceDmData = List<PriceDm>.from(
          response['data'].map((item) => PriceDm.fromJson(item)),
        );
      }
      if (response['data1'] != null) {
        companyStockData = List<CompanyStockDm>.from(
          response['data1'].map((item) => CompanyStockDm.fromJson(item)),
        );
      }

      return ItemDetailDm(
        priceDmData: priceDmData,
        companyStockData: companyStockData,
      );
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

  static Future<List<GodownStockDm>> getGodownStock({
    required String iCode,
    required String coCode,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/ItemHelp/godownStock',
        token: token,
        queryParams: {
          "ICODE": iCode,
          "COCODE": coCode,
        },
      );
      if (response == null) {
        return [];
      }

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => GodownStockDm.fromJson(item),
            )
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<ItemStockDm>> getItemStock({
    required String iCode,
    required String coCode,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/ItemHelp/itemStk',
        token: token,
        queryParams: {
          "ICODE": iCode,
          "COCODE": coCode,
        },
      );
      if (response == null) {
        return [];
      }

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => ItemStockDm.fromJson(item),
            )
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }
}

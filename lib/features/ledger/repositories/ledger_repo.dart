import 'package:mohta_app/features/ledger/models/ledger_dm.dart';
import 'package:mohta_app/features/outstandings/models/customer_dm.dart';
import 'package:mohta_app/features/utils/helpers/secure_storage_helper.dart';
import 'package:mohta_app/services/api_service.dart';

class LedgerRepo {
  static Future<List<CustomerDm>> getCustomers() async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/Master/customer',
        token: token,
      );
      if (response == null) {
        return [];
      }

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => CustomerDm.fromJson(item),
            )
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<LedgerDm>> getLedger({
    required String fromDate,
    required String toDate,
    required String pCode,
    required bool billDtl,
    required bool itemDtl,
    required bool sign,
  }) async {
    try {
      String? token = await SecureStorageHelper.read(
        'token',
      );

      Map<String, dynamic> requestBody = {
        "PCODE": pCode,
        "FromDate": fromDate,
        "ToDate": toDate,
        "BillDtl": billDtl,
        "ItemDtl": itemDtl,
        "Sign": sign,
      };

      print(requestBody);

      final response = await ApiService.postRequest(
        endpoint: '/Ledger/data',
        requestBody: requestBody,
        token: token,
      );

      if (response == null) {
        return [];
      }

      if (response is List) {
        return response
            .map(
              (item) => LedgerDm.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }
}

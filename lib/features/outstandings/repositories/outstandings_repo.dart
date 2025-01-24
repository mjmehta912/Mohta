import 'dart:typed_data';

import 'package:mohta_app/features/outstandings/models/customer_dm.dart';
import 'package:mohta_app/features/outstandings/models/outstanding_dm.dart';
import 'package:mohta_app/features/utils/helpers/secure_storage_helper.dart';
import 'package:mohta_app/services/api_service.dart';

class OutstandingsRepo {
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

  static Future<List<OutstandingDm>> getOutstandings({
    required String pCode,
    required String billStartDate,
    required String billEndDate,
    required String recStartDate,
    required String recEndDate,
    required String days,
    required bool onlyCd,
    required bool dueDateWise,
  }) async {
    try {
      String? token = await SecureStorageHelper.read(
        'token',
      );

      Map<String, dynamic> requestBody = {
        "PCODE": pCode,
        "UPCODE": null,
        "BILLSDATE": billStartDate,
        "BILLEDATE": billEndDate,
        "RECSDATE": recStartDate,
        "RECEDATE": recEndDate,
        "DATEFLTR": dueDateWise,
        "CDFLTR": onlyCd,
        "DAYS": days,
      };

      final response = await ApiService.postRequest(
        endpoint: '/AccReceivable/data',
        requestBody: requestBody,
        token: token,
      );

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => OutstandingDm.fromJson(item),
            )
            .toList();
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

  static Future<Uint8List?> downloadOutstandings({
    required String pCode,
    required String billStartDate,
    required String billEndDate,
    required String recStartDate,
    required String recEndDate,
    required String days,
    required bool onlyCd,
    required bool dueDateWise,
  }) async {
    try {
      String? token = await SecureStorageHelper.read('token');

      Map<String, dynamic> requestBody = {
        "PCODE": pCode,
        "UPCODE": null,
        "BILLSDATE": billStartDate,
        "BILLEDATE": billEndDate,
        "RECSDATE": recStartDate,
        "RECEDATE": recEndDate,
        "DATEFLTR": dueDateWise,
        "CDFLTR": onlyCd,
        "DAYS": days,
      };

      final response = await ApiService.postRequest(
        endpoint: '/AccReceivable/pdf',
        requestBody: requestBody,
        token: token,
      );

      if (response is Uint8List) {
        return response;
      } else {
        throw 'Failed to generate PDF. Unexpected response format.';
      }
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

import 'dart:typed_data';

import 'package:mohta_app/features/outstandings/models/customer_dm.dart';
import 'package:mohta_app/features/outstandings/models/outstanding_dm.dart';
import 'package:mohta_app/features/outstandings/models/salesman_dm.dart';
import 'package:mohta_app/features/utils/helpers/secure_storage_helper.dart';
import 'package:mohta_app/services/api_service.dart';

class OutstandingsRepo {
  static Future<List<CustomerDm>> getCustomers({
    required String seCode,
    required String fromDate,
    required String toDate,
    required String colFromDate,
    required String colTodate,
    required bool dueDatewise,
    required bool cdBillwise,
    required int days,
  }) async {
    try {
      String? token = await SecureStorageHelper.read(
        'token',
      );

      Map<String, dynamic> requestBody = {
        "SECode": seCode,
        "FromDate": fromDate,
        "ToDate": toDate,
        "ColFromDate": colFromDate,
        "ColToDate": colTodate,
        "Duedatewise": dueDatewise,
        "CDBillwise": cdBillwise,
        "Days": days
      };

      final response = await ApiService.postRequest(
        endpoint: '/AccReceivable/party',
        requestBody: requestBody,
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
      if (e is Map<String, dynamic>) {
        rethrow;
      }
      throw {
        'status': 500,
        'message': e.toString(),
      };
    }
  }

  static Future<List<SalesmanDm>> getSalesmen() async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/Master/salesmen',
        token: token,
      );
      if (response == null) {
        return [];
      }

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => SalesmanDm.fromJson(item),
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

      print(requestBody);

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

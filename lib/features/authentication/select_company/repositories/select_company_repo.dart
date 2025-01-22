import 'package:mohta_app/features/authentication/select_company/models/year_dm.dart';
import 'package:mohta_app/services/api_service.dart';

class SelectCompanyRepo {
  static Future<List<YearDm>> getYears({
    required int coCode,
  }) async {
    try {
      final response = await ApiService.getRequest(
        endpoint: '/Master/year',
        queryParams: {
          'COCODE': coCode.toString(),
        },
      );
      if (response == null) {
        return [];
      }

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => YearDm.fromJson(item),
            )
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> getToken({
    required String mobileNumber,
    required int cid,
    required int yearId,
  }) async {
    final Map<String, dynamic> requestBody = {
      'mobileno': mobileNumber,
      'cid': cid,
      'yearId': yearId,
    };

    try {
      var response = await ApiService.postRequest(
        endpoint: '/Auth/token',
        requestBody: requestBody,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

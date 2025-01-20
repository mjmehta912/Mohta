import 'package:mohta_app/services/api_service.dart';

class SelectCompanyRepo {
  static Future<dynamic> getToken({
    required String mobileNumber,
    required int cid,
  }) async {
    final Map<String, dynamic> requestBody = {
      'mobileno': mobileNumber,
      'cid': cid,
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

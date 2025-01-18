import 'package:mohta_app/services/api_service.dart';
import 'package:mohta_app/features/authentication/login/models/company_dm.dart';

class LoginRepo {
  static Future<List<CompanyDm>> loginUser({
    required String mobileNo,
    required String password,
    required String fcmToken,
    required String deviceId,
  }) async {
    final Map<String, dynamic> requestBody = {
      'mobileNo': mobileNo,
      'password': password,
      'FCMToken': fcmToken,
      'DeviceID': deviceId,
    };

    try {
      var response = await ApiService.postRequest(
        endpoint: '/Auth/login',
        requestBody: requestBody,
      );

      // Convert company data into List<CompanyDm>
      if (response != null && response['company'] != null) {
        return (response['company'] as List<dynamic>)
            .map((companyJson) => CompanyDm.fromJson(companyJson))
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }
}

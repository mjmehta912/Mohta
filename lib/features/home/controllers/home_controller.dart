import 'package:get/get.dart';
import 'package:mohta_app/features/authentication/login/screens/login_screen.dart';
import 'package:mohta_app/features/utils/dialogs/app_dialogs.dart';
import 'package:mohta_app/features/utils/helpers/secure_storage_helper.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;

  var companyName = ''.obs;

  @override
  void onInit() async {
    super.onInit();

    final storedCompanyName = await SecureStorageHelper.read('company');
    companyName.value = storedCompanyName ?? 'Mohta';
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

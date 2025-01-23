import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mohta_app/constants/color_constants.dart';
import 'package:mohta_app/constants/image_constants.dart';
import 'package:mohta_app/features/authentication/login/screens/login_screen.dart';
import 'package:mohta_app/features/home/screens/home_screen.dart';
import 'package:mohta_app/features/utils/extensions/app_size_extensions.dart';
import 'package:mohta_app/features/utils/helpers/secure_storage_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(
        seconds: 3,
      ),
      () async {
        String? token = await SecureStorageHelper.read(
          'token',
        );

        Future.delayed(
          const Duration(
            seconds: 1,
          ),
          () {
            if (token != null && token.isNotEmpty) {
              Get.offAll(
                () => HomeScreen(),
              );
            } else {
              Get.offAll(
                () => LoginScreen(),
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorWhite,
      body: Center(
        child: Image.asset(
          kImageSplash,
          height: 0.2.screenHeight,
          width: 0.4.screenWidth,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

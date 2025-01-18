import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mohta_app/constants/color_constants.dart';
import 'package:mohta_app/features/authentication/login/controllers/login_controller.dart';
import 'package:mohta_app/features/utils/screen_utils/app_paddings.dart';
import 'package:mohta_app/features/utils/screen_utils/app_spacings.dart';
import 'package:mohta_app/styles/font_sizes.dart';
import 'package:mohta_app/styles/text_styles.dart';
import 'package:mohta_app/widgets/app_button.dart';
import 'package:mohta_app/widgets/app_text_form_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({
    super.key,
  });

  final LoginController _controller = Get.put(
    LoginController(),
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: kColorWhite,
        body: Center(
          child: SingleChildScrollView(
            padding: AppPaddings.ph30,
            child: Form(
              key: _controller.loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Let \'s sign you in',
                    style: TextStyles.kSemiBoldSofiaSansSemiCondensed(
                      fontSize: FontSizes.k36FontSize,
                    ),
                  ),
                  AppSpaces.v40,
                  AppTextFormField(
                    controller: _controller.usernameController,
                    hintText: 'Username',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a username';
                      }

                      return null;
                    },
                  ),
                  AppSpaces.v20,
                  Obx(
                    () => AppTextFormField(
                      controller: _controller.passwordController,
                      hintText: 'Password',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                      isObscure: _controller.obscuredText.value,
                      suffixIcon: IconButton(
                        onPressed: () {
                          _controller.togglePasswordVisibility();
                        },
                        icon: Icon(
                          _controller.obscuredText.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  AppSpaces.v40,
                  AppButton(
                    title: 'Sign In',
                    onPressed: () {
                      _controller.hasAttemptedLogin.value = true;
                      if (_controller.loginFormKey.currentState!.validate()) {}
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

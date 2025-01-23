import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mohta_app/constants/color_constants.dart';
import 'package:mohta_app/features/home/controllers/home_controller.dart';
import 'package:mohta_app/features/item_help/screens/item_help_screen.dart';
import 'package:mohta_app/features/ledger/screens/ledger_screen.dart';
import 'package:mohta_app/features/outstandings/screens/outstandings_screen.dart';
import 'package:mohta_app/features/utils/screen_utils/app_paddings.dart';
import 'package:mohta_app/features/utils/screen_utils/app_spacings.dart';
import 'package:mohta_app/styles/font_sizes.dart';
import 'package:mohta_app/styles/text_styles.dart';
import 'package:mohta_app/widgets/app_button.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({
    super.key,
  });

  final HomeController _controller = Get.put(
    HomeController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorWhite,
      appBar: AppBar(
        centerTitle: false,
        title: Obx(
          () => Text(
            _controller.companyName.value,
            style: TextStyles.kRegularSofiaSansSemiCondensed(
              color: kColorTextPrimary,
              fontSize: FontSizes.k16FontSize,
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  _controller.logoutUser();
                },
                child: Text(
                  'Logout',
                  style: TextStyles.kRegularSofiaSansSemiCondensed(
                    fontSize: FontSizes.k16FontSize,
                    color: kColorTextPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  _controller.logoutUser();
                },
                icon: Icon(
                  Icons.logout,
                  color: kColorTextPrimary,
                  size: 25,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: AppPaddings.p10,
        child: Column(
          children: [
            AppButton(
              buttonHeight: 60,
              title: 'Item Help',
              onPressed: () {
                Get.to(
                  () => ItemHelpScreen(),
                );
              },
            ),
            AppSpaces.v10,
            AppButton(
              buttonHeight: 60,
              title: 'Outstandings',
              onPressed: () {
                Get.to(
                  () => OutstandingsScreen(),
                );
              },
            ),
            AppSpaces.v10,
            AppButton(
              buttonHeight: 60,
              title: 'Ledger',
              onPressed: () {
                Get.to(
                  () => LedgerScreen(),
                );
              },
            ),
            AppSpaces.v10,
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mohta_app/constants/color_constants.dart';
import 'package:mohta_app/features/item_help/screens/item_help_screen.dart';
import 'package:mohta_app/features/outstandings/screens/outstandings_screen.dart';
import 'package:mohta_app/features/utils/screen_utils/app_paddings.dart';
import 'package:mohta_app/features/utils/screen_utils/app_spacings.dart';
import 'package:mohta_app/styles/text_styles.dart';
import 'package:mohta_app/widgets/app_appbar.dart';
import 'package:mohta_app/widgets/app_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.companyName,
  });

  final String companyName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorWhite,
      appBar: AppAppbar(
        title: companyName,
        titleStyle: TextStyles.kRegularSofiaSansSemiCondensed(
          color: kColorTextPrimary,
        ),
      ),
      body: Padding(
        padding: AppPaddings.p10,
        child: Column(
          children: [
            AppButton(
              title: 'Item Help',
              onPressed: () {
                Get.to(
                  () => ItemHelpScreen(),
                );
              },
            ),
            AppSpaces.v10,
            AppButton(
              title: 'Outstandings',
              onPressed: () {
                Get.to(
                  () => OutstandingsScreen(),
                );
              },
            ),
            AppSpaces.v10,
            AppButton(
              title: 'Ledger',
              onPressed: () {},
            ),
            AppSpaces.v10,
          ],
        ),
      ),
    );
  }
}

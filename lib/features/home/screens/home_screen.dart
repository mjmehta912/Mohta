import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mohta_app/constants/color_constants.dart';
import 'package:mohta_app/features/home/controllers/home_controller.dart';
import 'package:mohta_app/features/item_help/screens/item_help_screen.dart';
import 'package:mohta_app/features/ledger/screens/ledger_screen.dart';
import 'package:mohta_app/features/outstandings/screens/outstandings_screen.dart';
import 'package:mohta_app/features/utils/screen_utils/app_spacings.dart';
import 'package:mohta_app/styles/font_sizes.dart';
import 'package:mohta_app/styles/text_styles.dart';

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
        backgroundColor: kColorWhite,
        centerTitle: false,
        title: Obx(
          () {
            final words = _controller.companyName.value.split(' ');
            final firstTwoWords = words.take(2).join(' ');
            return Text(
              firstTwoWords,
              style: TextStyles.kRegularSofiaSansSemiCondensed(
                color: kColorTextPrimary,
                fontSize: FontSizes.k24FontSize,
              ),
            );
          },
        ),
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: _controller.logoutUser,
                child: Text(
                  'Logout',
                  style: TextStyles.kRegularSofiaSansSemiCondensed(
                    fontSize: FontSizes.k16FontSize,
                    color: kColorTextPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: _controller.logoutUser,
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
      body: Column(
        children: [
          Expanded(
            child: GridView(
              padding: const EdgeInsets.all(12.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 1.0,
              ),
              children: [
                _buildFeatureCard(
                  title: 'Item Help',
                  icon: Icons.help_outline,
                  onTap: () => Get.to(
                    () => ItemHelpScreen(),
                  ),
                ),
                _buildFeatureCard(
                  title: 'Outstandings',
                  icon: Icons.receipt_long,
                  onTap: () => Get.to(
                    () => OutstandingsScreen(),
                  ),
                ),
                _buildFeatureCard(
                  title: 'Ledger',
                  icon: Icons.book_outlined,
                  onTap: () => Get.to(
                    () => LedgerScreen(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        color: kColorPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: kColorWhite,
            ),
            AppSpaces.v10,
            Text(
              title,
              style: TextStyles.kBoldSofiaSansSemiCondensed(
                color: kColorWhite,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

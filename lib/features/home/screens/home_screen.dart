import 'package:flutter/material.dart';
import 'package:mohta_app/constants/color_constants.dart';
import 'package:mohta_app/styles/text_styles.dart';
import 'package:mohta_app/widgets/app_appbar.dart';

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
    );
  }
}

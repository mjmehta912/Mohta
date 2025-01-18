import 'package:flutter/material.dart';
import 'package:mohta_app/constants/color_constants.dart';
import 'package:mohta_app/styles/font_sizes.dart';
import 'package:mohta_app/styles/text_styles.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.color,
  });

  final VoidCallback onPressed;
  final String title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyles.kRegularSofiaSansSemiCondensed(
          color: color ?? kColorPrimary,
          fontSize: FontSizes.k16FontSize,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mohta_app/styles/font_sizes.dart';
import 'package:mohta_app/styles/text_styles.dart';

class OutstandingRow extends StatelessWidget {
  const OutstandingRow({
    super.key,
    required this.title,
    required this.value,
    required this.textColor,
  });

  final String title;
  final String value;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyles.kRegularSofiaSansSemiCondensed(
          fontSize: FontSizes.k16FontSize,
          color: textColor,
        ).copyWith(
          height: 1.25,
        ),
        children: [
          TextSpan(
            text: title,
            style: TextStyles.kBoldSofiaSansSemiCondensed(
              fontSize: FontSizes.k16FontSize,
              color: textColor,
            ).copyWith(
              height: 1.25,
            ),
          ),
          TextSpan(
            text: value,
          ),
        ],
      ),
    );
  }
}

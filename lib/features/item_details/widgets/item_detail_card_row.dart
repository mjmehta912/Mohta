import 'package:flutter/material.dart';
import 'package:mohta_app/features/utils/screen_utils/app_spacings.dart';
import 'package:mohta_app/styles/font_sizes.dart';
import 'package:mohta_app/styles/text_styles.dart';

class ItemDetailCardRow extends StatelessWidget {
  const ItemDetailCardRow({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyles.kBoldSofiaSansSemiCondensed(
            fontSize: FontSizes.k16FontSize,
          ).copyWith(
            height: 1.25,
          ),
        ),
        AppSpaces.h10,
        Flexible(
          child: Text(
            value,
            style: TextStyles.kRegularSofiaSansSemiCondensed(
              fontSize: FontSizes.k16FontSize,
            ).copyWith(
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}

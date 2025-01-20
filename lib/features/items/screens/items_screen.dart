import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mohta_app/constants/color_constants.dart';
import 'package:mohta_app/features/utils/screen_utils/app_paddings.dart';
import 'package:mohta_app/styles/font_sizes.dart';
import 'package:mohta_app/styles/text_styles.dart';
import 'package:mohta_app/widgets/app_appbar.dart';
import 'package:mohta_app/widgets/app_card.dart';

class ItemsScreen extends StatelessWidget {
  const ItemsScreen({
    super.key,
    required this.items,
  });

  final List<Map<String, dynamic>> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorWhite,
      appBar: AppAppbar(
        title: 'Items',
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: kColorTextPrimary,
            size: 20,
          ),
        ),
      ),
      body: Padding(
        padding: AppPaddings.p10,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return AppCard(
              onTap: () {},
              child: Padding(
                padding: AppPaddings.p10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: item.entries.map(
                    (entry) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${entry.key}: ',
                            style: TextStyles.kBoldSofiaSansSemiCondensed(
                              fontSize: FontSizes.k16FontSize,
                            ).copyWith(
                              height: 1.25,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              ' ${entry.value}',
                              style: TextStyles.kRegularSofiaSansSemiCondensed(
                                fontSize: FontSizes.k16FontSize,
                              ).copyWith(
                                height: 1.25,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

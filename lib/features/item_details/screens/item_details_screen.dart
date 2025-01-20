import 'package:flutter/material.dart';
import 'package:mohta_app/constants/color_constants.dart';
import 'package:mohta_app/widgets/app_appbar.dart';

class ItemDetailsScreen extends StatelessWidget {
  const ItemDetailsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorWhite,
      appBar: AppAppbar(
        title: 'Item Details',
      ),
    );
  }
}

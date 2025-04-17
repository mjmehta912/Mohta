import 'package:flutter/material.dart';
import 'package:mohta_app/constants/color_constants.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    required this.onTap,
    this.color,
  });

  final Color? color;
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        color: color ?? kColorWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: kColorBlack,
          ),
        ),
        child: child,
      ),
    );
  }
}

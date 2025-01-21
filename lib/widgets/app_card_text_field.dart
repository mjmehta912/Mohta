import 'package:flutter/material.dart';
import 'package:mohta_app/constants/color_constants.dart';

class AppCardTextField extends StatelessWidget {
  const AppCardTextField({
    super.key,
    required this.child,
    required this.onTap,
    required this.isSelected,
  });

  final Widget child;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        color: kColorLightGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
          side: BorderSide(
            color: isSelected ? kColorTextPrimary : kColorLightGrey,
            width: isSelected ? 1 : 0,
          ),
        ),
        child: child,
      ),
    );
  }
}

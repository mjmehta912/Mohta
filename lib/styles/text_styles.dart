import 'package:flutter/material.dart';
import 'package:mohta_app/constants/color_constants.dart';
import 'package:mohta_app/styles/font_sizes.dart';
import 'package:mohta_app/styles/fonts.dart';

class TextStyles {
  static TextStyle kLightSofiaSansSemiCondensed({
    double fontSize = FontSizes.k20FontSize,
    Color color = kColorTextPrimary,
    FontWeight fontWeight = FontWeight.w300,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: Fonts.sofiaSansSemiCondensedLight,
    );
  }

  static TextStyle kRegularSofiaSansSemiCondensed({
    double fontSize = FontSizes.k20FontSize,
    Color color = kColorTextPrimary,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: Fonts.sofiaSansSemiCondensedRegular,
    );
  }

  static TextStyle kMediumSofiaSansSemiCondensed({
    double fontSize = FontSizes.k20FontSize,
    Color color = kColorTextPrimary,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: Fonts.sofiaSansSemiCondensedMedium,
    );
  }

  static TextStyle kSemiBoldSofiaSansSemiCondensed({
    double fontSize = FontSizes.k20FontSize,
    Color color = kColorTextPrimary,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: Fonts.sofiaSansSemiCondensedSemiBold,
    );
  }

  static TextStyle kBoldSofiaSansSemiCondensed({
    double fontSize = FontSizes.k20FontSize,
    Color color = kColorTextPrimary,
    FontWeight fontWeight = FontWeight.w700,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: Fonts.sofiaSansSemiCondensedBold,
    );
  }

  static kRegularFredoka({required fontSize, required Color color}) {}
}

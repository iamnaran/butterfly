import 'dart:math';

import 'package:flutter/material.dart';

class UIHelpers {
  UIHelpers._internal();
  static const double _xxSmallSize = 2.0;
  static const double _xSmallSize = 5.0;
  static const double _smallSize = 10.0;
  static const double _xMediumSize = 12.0;
  static const double _mediumSize = 16.0;
  static const double _largeSize = 25.0;
  static const double _xLargeSize = 32.0;
  static const double _xxLargeSize = 38.0;
  static const double _massiveSize = 50.0;

  static const Widget horizontalSpaceXSmall = SizedBox(width: _xSmallSize);
  static const Widget horizontalSpaceSmall = SizedBox(width: _smallSize);
  static const Widget horizontalSpaceMedium = SizedBox(width: _mediumSize);
  static const Widget horizontalSpaceLarge = SizedBox(width: _largeSize);

  static const Widget verticalSpaceXSmall = SizedBox(height: _xSmallSize);
  static const Widget verticalSpaceSmall = SizedBox(height: _smallSize);
  static const Widget verticalSpaceMedium = SizedBox(height: _mediumSize);
  static const Widget verticalSpaceLarge = SizedBox(height: _largeSize);
  static const Widget verticalSpaceXLarge = SizedBox(height: _xLargeSize);
  static const Widget verticalSpaceXXLarge = SizedBox(height: _xxLargeSize);
  static const Widget verticalSpaceMassive = SizedBox(height: _massiveSize);

  static Widget spacedDivider = const Column(
    children: <Widget>[
      verticalSpaceMedium,
      Divider(color: Colors.blueGrey, height: 5.0),
      verticalSpaceMedium,
    ],
  );

  static Widget verticalSpace(double height) => SizedBox(height: height);

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double screenHeightFraction(BuildContext context,
          {int dividedBy = 1, double offsetBy = 0, double max = 3000}) =>
      min((screenHeight(context) - offsetBy) / dividedBy, max);

  static double screenWidthFraction(BuildContext context,
          {int dividedBy = 1, double offsetBy = 0, double max = 3000}) =>
      min((screenWidth(context) - offsetBy) / dividedBy, max);

  static double halfScreenWidth(BuildContext context) =>
      screenWidthFraction(context, dividedBy: 2);

  static double thirdScreenWidth(BuildContext context) =>
      screenWidthFraction(context, dividedBy: 3);

  static double quarterScreenWidth(BuildContext context) =>
      screenWidthFraction(context, dividedBy: 4);

  static double getResponsiveHorizontalSpaceMedium(BuildContext context) =>
      screenWidthFraction(context, dividedBy: 10);
  static double getResponsiveSmallFontSize(BuildContext context) =>
      getResponsiveFontSize(context, fontSize: 14, max: 15);

  static double getResponsiveMediumFontSize(BuildContext context) =>
      getResponsiveFontSize(context, fontSize: 16, max: 17);

  static double getResponsiveLargeFontSize(BuildContext context) =>
      getResponsiveFontSize(context, fontSize: 21, max: 31);

  static double getResponsiveExtraLargeFontSize(BuildContext context) =>
      getResponsiveFontSize(context, fontSize: 25);

  static double getResponsiveMassiveFontSize(BuildContext context) =>
      getResponsiveFontSize(context, fontSize: 30);

  static double getResponsiveFontSize(BuildContext context,
      {double? fontSize, double? max}) {
    max ??= 100;

    var responsiveSize = min(
        screenWidthFraction(context, dividedBy: 10) * ((fontSize ?? 100) / 100),
        max);

    return responsiveSize;
  }

  static const double cornerRadiusTinySize = _xSmallSize;
  static const double cornerRadiusSmallSize = _smallSize;
  static const double cornerRadiusMediumSize = _mediumSize;
  static const double cornerRadiusLargeSize = _largeSize;
  static const double cornerRadiusMassiveSize = _massiveSize;

  static double space(Spacing space) {
    switch (space) {
      case Spacing.xxsmall:
        return _xxSmallSize;
      case Spacing.xsmall:
        return _xSmallSize;
      case Spacing.small:
        return _smallSize;
      case Spacing.xmedium:
        return _xMediumSize;
      case Spacing.medium:
        return _mediumSize;
      case Spacing.large:
        return _largeSize;
      case Spacing.xLarge:
        return _xLargeSize;
      case Spacing.xxLarge:
        return _xxLargeSize;
      case Spacing.massive:
        return _massiveSize;

      // ignore: unreachable_switch_default
      default:
        return 20;
    }
  }

  static double defaultSafeSpace = _mediumSize;

  /// Add padding in all direction
  ///
  /// Use Spacing enum to define value
  static EdgeInsets paddingAll({Spacing spacing = Spacing.small}) {
    return EdgeInsets.all(
      space(spacing),
    );
  }

  /// Add horizontal  padding.
  /// Use Spacing enum to define value.
  ///
  /// @param hspacing is optional. Default value Spacing.small i.e. 16.sp
  static EdgeInsets paddingHorizontal({Spacing? spacing = Spacing.medium}) {
    return EdgeInsets.symmetric(
      horizontal: (spacing != null) ? space(spacing) : 0.0,
    );
  }

  /// Add horizontal  padding.
  /// Use Spacing enum to define value.
  ///
  /// @param hspacing is optional. Default value Spacing.small i.e. 16.sp
  static EdgeInsets paddingVertical({Spacing? spacing = Spacing.medium}) {
    return EdgeInsets.symmetric(
      vertical: (spacing != null) ? space(spacing) : 0.0,
    );
  }

  /// Add horizontal and vertical padding.
  /// Use Spacing enum to define value.
  ///
  /// @param hspacing and vspacing are optional. Default value is 0.0
  static EdgeInsets paddingSymmetric({Spacing? hspacing, Spacing? vspacing}) {
    return EdgeInsets.symmetric(
      horizontal: (hspacing != null) ? space(hspacing) : 0.0,
      vertical: (vspacing != null) ? space(vspacing) : 0.0,
    );
  }

  /// Add custom padding to top, right, bottom and left
  /// Use Spacing enum to define value.
  ///
  /// @param top, right, bottom and left are optional. Default value is 0.0
  static EdgeInsets paddingOnly({
    Spacing? left,
    Spacing? top,
    Spacing? right,
    Spacing? bottom,
  }) {
    return EdgeInsets.only(
      left: (left != null) ? space(left) : 0.0,
      top: (top != null) ? space(top) : 0.0,
      right: (right != null) ? space(right) : 0.0,
      bottom: (bottom != null) ? space(bottom) : 0.0,
    );
  }
}

enum Spacing {
  xxsmall,
  xsmall,
  small,
  xmedium,
  medium,
  large,
  xLarge,
  xxLarge,
  massive,
}

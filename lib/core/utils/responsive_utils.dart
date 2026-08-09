import 'package:flutter/material.dart';

enum ScreenType { mobile, tablet, desktop }

class ResponsiveUtils {
  static ScreenType getScreenType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1024) return ScreenType.desktop;
    if (width >= 600) return ScreenType.tablet;
    return ScreenType.mobile;
  }

  static bool isMobile(BuildContext context) =>
      getScreenType(context) == ScreenType.mobile;

  static bool isTablet(BuildContext context) =>
      getScreenType(context) == ScreenType.tablet;

  static bool isDesktop(BuildContext context) =>
      getScreenType(context) == ScreenType.desktop;

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double safeAreaTop(BuildContext context) =>
      MediaQuery.of(context).padding.top;

  static double safeAreaBottom(BuildContext context) =>
      MediaQuery.of(context).padding.bottom;

  static double scaleWidth(BuildContext context, double value) {
    final width = screenWidth(context);
    return value * (width / 375);
  }

  static double scaleHeight(BuildContext context, double value) {
    final height = screenHeight(context);
    return value * (height / 812);
  }

  static EdgeInsets screenPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 24);
    }
    return const EdgeInsets.symmetric(horizontal: 48, vertical: 32);
  }

  static double contentMaxWidth(BuildContext context) {
    if (isDesktop(context)) return 1200;
    if (isTablet(context)) return 800;
    return double.infinity;
  }

  static double gridColumnCount(BuildContext context) {
    if (isDesktop(context)) return 4;
    if (isTablet(context)) return 3;
    return 2;
  }
}

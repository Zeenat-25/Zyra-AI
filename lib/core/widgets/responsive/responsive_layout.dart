import 'package:flutter/material.dart';
import '../../utils/responsive_utils.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final screenType = ResponsiveUtils.getScreenType(context);
    switch (screenType) {
      case ScreenType.desktop:
        return desktop ?? tablet ?? mobile;
      case ScreenType.tablet:
        return tablet ?? mobile;
      case ScreenType.mobile:
        return mobile;
    }
  }
}

class AdaptiveScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool showAppBar;

  const AdaptiveScaffold({
    super.key,
    this.title,
    required this.body,
    this.actions,
    this.drawer,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveUtils.isTablet(context);
    final isDesktop = ResponsiveUtils.isDesktop(context);

    if (isDesktop) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: Row(
          children: [
            if (drawer != null)
              SizedBox(
                width: 280,
                child: drawer,
              ),
            Expanded(
              child: Scaffold(
                appBar: showAppBar ? _buildAppBar(context) : null,
                body: body,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: showAppBar ? _buildAppBar(context) : null,
      drawer: drawer,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: title != null ? Text(title!) : null,
      actions: actions,
      centerTitle: true,
    );
  }
}

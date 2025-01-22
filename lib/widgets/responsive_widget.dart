import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final WidgetBuilder mobileBuilder;
  final WidgetBuilder tabletBuilder;
  final double breakpoint;

  const ResponsiveLayout({
    super.key,
    required this.mobileBuilder,
    required this.tabletBuilder,
    this.breakpoint = 600, // Default breakpoint for tablet screens
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= breakpoint) {
      return tabletBuilder(context);
    } else {
      return mobileBuilder(context);
    }
  }
}

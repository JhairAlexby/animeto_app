import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget? tabletBody;

  const ResponsiveLayout({
    super.key,
    required this.mobileBody,
    this.tabletBody,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return mobileBody;
        } else {
          return tabletBody ??
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: (constraints.maxWidth - 600) / 2,
                ),
                child: mobileBody,
              );
        }
      },
    );
  }
}
import 'package:flutter/material.dart';

class ResponsiveGridConfig {
  final int crossAxisCount;
  final double childAspectRatio;
  final bool isLandscape;
  final bool isTablet;
  final double screenWidth;
  final double screenHeight;

  const ResponsiveGridConfig({
    required this.crossAxisCount,
    required this.childAspectRatio,
    required this.isLandscape,
    required this.isTablet,
    required this.screenWidth,
    required this.screenHeight,
  });

  factory ResponsiveGridConfig.of(
    BuildContext context, {
    int tabletLandscapeCount = 5,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final isTablet = screenWidth > 600;

    int crossAxisCount;
    double childAspectRatio;

    if (isTablet && isLandscape) {
      crossAxisCount = tabletLandscapeCount;
      childAspectRatio = 0.8;
    } else if (isTablet && !isLandscape) {
      crossAxisCount = 2;
      childAspectRatio = 0.85;
    } else if (!isTablet && isLandscape) {
      crossAxisCount = 3;
      childAspectRatio = 1.0;
    } else {
      crossAxisCount = 2;
      childAspectRatio = 0.85;
    }

    return ResponsiveGridConfig(
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio,
      isLandscape: isLandscape,
      isTablet: isTablet,
      screenWidth: screenWidth,
      screenHeight: screenHeight,
    );
  }

  double get horizontalPadding =>
      isTablet ? screenWidth * 0.05 : screenWidth * 0.03;

  double get crossAxisSpacing => screenWidth * 0.03;

  double get mainAxisSpacing =>
      isLandscape ? screenHeight * 0.04 : screenHeight * 0.03;

  double get topPadding =>
      isLandscape ? screenHeight * 0.02 : screenHeight * 0.03;

  double get bottomPadding =>
      isLandscape ? screenHeight * 0.01 : screenHeight * 0.02;

  double get gridVerticalPadding =>
      isLandscape ? screenHeight * 0.01 : screenHeight * 0.02;

  double get gridHorizontalPadding =>
      isTablet && isLandscape ? screenWidth * 0.05 : 0;
}

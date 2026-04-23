import 'package:flutter/material.dart';

class BackgroundScaffold extends StatelessWidget {
  final String backgroundImage;
  final PreferredSizeWidget? appBar;
  final Widget child;
  final Color? overlayColor;

  const BackgroundScaffold({
    super.key,
    required this.backgroundImage,
    required this.child,
    this.appBar,
    this.overlayColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      extendBodyBehindAppBar: appBar != null,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: overlayColor != null
            ? Container(
                color: overlayColor,
                child: SafeArea(child: child),
              )
            : SafeArea(child: child),
      ),
    );
  }
}

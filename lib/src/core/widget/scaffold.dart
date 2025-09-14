import 'package:flutter/material.dart';

@immutable
class App$Scaffold extends StatelessWidget {
  const App$Scaffold({
    required this.body,
    this.backgroundColor,
    this.decoration,
    this.extendBody = false,
    this.withSafeArea = true,
    super.key,
  });

  final Widget body;
  final Color? backgroundColor;
  final BoxDecoration? decoration;
  final bool extendBody;
  final bool withSafeArea;

  @override
  Widget build(final BuildContext context) {
    final contentWidget = withSafeArea ? SafeArea(child: body) : body;
    return Scaffold(
      backgroundColor: backgroundColor,
      extendBody: extendBody,
      body: decoration == null ? contentWidget : _withDecoration(decoration!, contentWidget),
    );
  }

  Widget _withDecoration(final BoxDecoration decoration, final Widget child) =>
      DecoratedBox(decoration: decoration, child: child);
}

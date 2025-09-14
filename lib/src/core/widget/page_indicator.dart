import 'package:flutter/material.dart';
import 'package:stylish/src/core/theme/theme.dart';

@immutable
class App$PageIndicatorRow extends StatelessWidget {
  const App$PageIndicatorRow({required this.itemCount, required this.activeIndex, super.key});

  final int itemCount;
  final int activeIndex;

  @override
  Widget build(final BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < itemCount; i++) children.add(App$PageIndicator(isActive: i == activeIndex));

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 10,
      children: children,
    );
  }
}

@immutable
class App$PageIndicator extends StatelessWidget {
  const App$PageIndicator({required this.isActive, super.key});

  final bool isActive;

  @override
  Widget build(final BuildContext context) {
    final appTheme = context.theme.appTheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 8,
      width: isActive ? 40 : 10,
      decoration: BoxDecoration(
        color: isActive ? appTheme.title : appTheme.body,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

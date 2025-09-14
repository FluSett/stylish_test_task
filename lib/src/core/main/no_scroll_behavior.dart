import 'package:flutter/widgets.dart';

@immutable
class NoScrollbarBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(final BuildContext context, final Widget child, final ScrollableDetails details) => child;
}

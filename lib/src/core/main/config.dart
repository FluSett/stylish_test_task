import 'package:flutter/widgets.dart';

enum Environments { production, development }

@immutable
final class App$Config {
  static const environment = String.fromEnvironment('ENV', defaultValue: 'development');
  static bool get isProduction => environment.toLowerCase() == Environments.production.name;
  static bool get isDevelopment => environment.toLowerCase() == Environments.development.name;

  static bool get showOctopusPanel => const bool.fromEnvironment('SHOW_OCTOPUS_PANEL', defaultValue: false);

  static bool get logInfoStateChanges => const bool.fromEnvironment('LOG_INFO_STATE_CHANGES', defaultValue: false);

  static const mobileBreakpoint = 800.0;

  static const defaultScale = 1.0;

  static bool get isMobile => width < mobileBreakpoint;
  static Size get size => Size(width, height);

  static double get width =>
      WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width /
      WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

  static double get height =>
      WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.height /
      WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

  static const animationDuration = Duration(milliseconds: 500);
  static const animatedButtonDuration = Duration(milliseconds: 200);
}

import 'package:meta/meta.dart';

@immutable
final class App$AssetPaths {
  static const _core = 'assets/images/core';
  static const logoWithName = '$_core/logo_with_name.png';

  static const _onboarding = 'assets/images/onboarding';
  static const fashionShop = '$_onboarding/fashion_shop.svg';
  static const salesConsulting = '$_onboarding/sales_consulting.svg';
  static const shoppingBag = '$_onboarding/shopping_bag.svg';

  static const _home = 'assets/images/home';
  static const homeBackground = '$_home/background.webp';

  static const forCaching = <String>{logoWithName, homeBackground};
}

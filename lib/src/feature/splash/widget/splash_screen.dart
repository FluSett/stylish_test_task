import 'package:flutter/material.dart';
import 'package:stylish/src/core/constant/asset_paths.dart';
import 'package:stylish/src/core/widget/scaffold.dart';

@immutable
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(final BuildContext context) => App$Scaffold(
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Center(child: Image.asset(App$AssetPaths.logoWithName)),
    ),
  );
}

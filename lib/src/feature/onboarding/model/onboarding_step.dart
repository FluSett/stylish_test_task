import 'package:meta/meta.dart';

@immutable
final class OnboardingStep {
  const OnboardingStep({required this.assetPath, required this.title, required this.description});

  final String assetPath;
  final String title;
  final String description;
}

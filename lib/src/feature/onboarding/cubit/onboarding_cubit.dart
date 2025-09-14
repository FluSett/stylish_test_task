import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish/src/core/constant/asset_paths.dart';
import 'package:stylish/src/core/util/shared_preferences_util.dart';
import 'package:stylish/src/feature/onboarding/model/onboarding_step.dart';

const _stepsData = <OnboardingStep>[
  OnboardingStep(
    assetPath: App$AssetPaths.fashionShop,
    title: 'Choose Products',
    description:
        'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.',
  ),
  OnboardingStep(
    assetPath: App$AssetPaths.salesConsulting,
    title: 'Make Payment',
    description:
        'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.',
  ),
  OnboardingStep(
    assetPath: App$AssetPaths.shoppingBag,
    title: 'Get Your Order',
    description:
        'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.',
  ),
];

@immutable
final class OnboardingState {
  const OnboardingState({this.stepIndex = 0});

  final int stepIndex;

  List<OnboardingStep> get steps => List<OnboardingStep>.of(_stepsData);

  OnboardingStep get step => _stepsData[stepIndex];

  bool get isLast => stepIndex == _stepsData.length - 1;

  OnboardingState copyWith({final int? stepIndex}) => OnboardingState(stepIndex: stepIndex ?? this.stepIndex);
}

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  void changeStep(final int value) {
    final newStepIndex = value.clamp(0, _stepsData.length - 1);

    emit(state.copyWith(stepIndex: newStepIndex));
  }

  void nextStep() => changeStep(state.stepIndex + 1);

  void previousStep() => changeStep(state.stepIndex - 1);

  Future<void> pass(VoidCallback onDone) async {
    await App$SharedPreferencesUtil.saveShouldShowOnboarding(false);
    onDone();
  }
}

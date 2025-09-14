import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:octopus/octopus.dart';
import 'package:stylish/src/core/router/routes.dart';
import 'package:stylish/src/core/theme/theme.dart';
import 'package:stylish/src/core/widget/page_indicator.dart';
import 'package:stylish/src/core/widget/scaffold.dart';
import 'package:stylish/src/feature/onboarding/cubit/onboarding_cubit.dart';
import 'package:stylish/src/feature/onboarding/model/onboarding_step.dart';

@immutable
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onDone(final BuildContext context) {
    if (!context.mounted) return;
    context.octopus.setState((_) => OctopusState.single(Routes.login.node()));
  }

  @override
  Widget build(final BuildContext context) {
    final theme = context.theme;
    return BlocListener<OnboardingCubit, OnboardingState>(
      listenWhen: (final p, final c) => p.stepIndex != c.stepIndex,
      listener: (final context, final state) =>
          _pageController.animateToPage(state.stepIndex, duration: Durations.medium2, curve: Curves.easeIn),
      child: App$Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(12, 2, 12, 22),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BlocBuilder<OnboardingCubit, OnboardingState>(
                    buildWhen: (final p, final c) => p.stepIndex != c.stepIndex,
                    builder: (final context, final state) => Text.rich(
                      TextSpan(
                        text: '${state.stepIndex + 1}',
                        style: theme.customTextTheme.title.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.appTheme.title,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '/${state.steps.length}',
                            style: theme.customTextTheme.title.copyWith(color: theme.appTheme.body),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.read<OnboardingCubit>().pass(() => _onDone(context)),
                    child: Text('Skip', style: theme.customTextTheme.title.copyWith(color: theme.appTheme.title)),
                  ),
                ],
              ),
              Expanded(
                child: BlocSelector<OnboardingCubit, OnboardingState, List<OnboardingStep>>(
                  selector: (final state) => state.steps,
                  builder: (final context, final steps) => PageView(
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (final value) => context.read<OnboardingCubit>().changeStep(value),
                    children: steps
                        .map(
                          (step) => Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Flexible(
                                flex: 2,
                                child: SvgPicture.asset(step.assetPath, alignment: Alignment.bottomCenter),
                              ),
                              const SizedBox(height: 44),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsetsGeometry.symmetric(horizontal: 6),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    spacing: 10,
                                    children: [
                                      Text(
                                        step.title,
                                        textAlign: TextAlign.center,
                                        style: theme.customTextTheme.pageTitle.copyWith(color: theme.appTheme.title),
                                      ),
                                      Text(
                                        step.description,
                                        textAlign: TextAlign.center,
                                        style: theme.customTextTheme.body.copyWith(
                                          color: theme.appTheme.body,
                                          height: 1.714,
                                          letterSpacing: 0.28,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: context.read<OnboardingCubit>().previousStep,
                    child: Text('Prev', style: theme.customTextTheme.title.copyWith(color: theme.appTheme.body)),
                  ),
                  BlocBuilder<OnboardingCubit, OnboardingState>(
                    buildWhen: (final p, final c) => p.stepIndex != c.stepIndex,
                    builder: (final context, final state) =>
                        App$PageIndicatorRow(itemCount: state.steps.length, activeIndex: state.stepIndex),
                  ),
                  BlocSelector<OnboardingCubit, OnboardingState, bool>(
                    selector: (final state) => state.isLast,
                    builder: (final context, final isLast) => TextButton(
                      onPressed: isLast
                          ? () => context.read<OnboardingCubit>().pass(() => _onDone(context))
                          : context.read<OnboardingCubit>().nextStep,
                      child: Text(
                        isLast ? 'Get Started' : 'Next',
                        style: theme.customTextTheme.title.copyWith(color: theme.primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/octopus.dart';
import 'package:stylish/src/feature/authentication/widget/login/login_screen.dart';
import 'package:stylish/src/feature/authentication/widget/sign_up/sign_up_screen.dart';
import 'package:stylish/src/feature/home/widget/home_screen.dart';
import 'package:stylish/src/feature/onboarding/cubit/onboarding_cubit.dart';
import 'package:stylish/src/feature/onboarding/widget/onboarding_screen.dart';
import 'package:stylish/src/feature/set_up/widget/set_up_screen.dart';
import 'package:stylish/src/feature/splash/widget/splash_screen.dart';

enum Routes with OctopusRoute {
  splash('splash', title: 'Splash'),
  onboarding('onboarding', title: 'Onboarding'),
  login('login', title: 'Login'),
  signUp('sign-up', title: 'Sign Up'),
  setUp('set-up', title: 'Set Up'),
  home('home', title: 'Home');

  const Routes(this.name, {this.title});

  @override
  final String name;

  @override
  final String? title;

  @override
  Widget builder(final BuildContext context, final OctopusState state, final OctopusNode node) => switch (this) {
    Routes.splash => const SplashScreen(),
    Routes.onboarding => BlocProvider<OnboardingCubit>(
      create: (_) => OnboardingCubit(),
      child: const OnboardingScreen(),
    ),
    Routes.login => const LoginScreen(),
    Routes.signUp => const SignUpScreen(),
    Routes.setUp => const SetUpScreen(),
    Routes.home => const HomeScreen(),
  };
}

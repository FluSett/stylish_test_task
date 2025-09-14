import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/octopus.dart';
import 'package:stylish/src/core/bloc/app_bloc.dart';
import 'package:stylish/src/core/router/route_guard.dart';
import 'package:stylish/src/core/router/routes.dart';
import 'package:stylish/src/feature/authentication/bloc/authentication_bloc.dart';
import 'package:stylish/src/feature/not_found/widget/not_found_screen.dart';
import 'package:stylish/src/feature/profile/bloc/profile_bloc.dart';

@immutable
final class RouterUtil {
  static final _errorsObserver = ValueNotifier<List<({Object error, StackTrace stackTrace})>>(
    <({Object error, StackTrace stackTrace})>[],
  );

  static Octopus getRouter(final BuildContext context) {
    final isInitializedListenable = context.read<AppBloc>().isInitializedListenable;
    ValueListenable<bool>? isAuthenticatedListenable;
    ValueListenable<String>? userTextListenable;

    try {
      isAuthenticatedListenable = context.read<AuthenticationBloc>().isAuthenticatedListenable;
    } on Object catch (_, _) {}

    try {
      userTextListenable = context.read<ProfileBloc>().userTextListenable;
    } on Object catch (_, _) {}

    return Octopus(
      routes: Routes.values,
      defaultRoute: Routes.splash,
      transitionDelegate: const DefaultTransitionDelegate<void>(),
      guards: <IOctopusGuard>[
        RouteGuard(
          isInitializedListenable: isInitializedListenable,
          isAuthenticatedListenable: isAuthenticatedListenable,
          userTextListenable: userTextListenable,
          refresh: Listenable.merge([isInitializedListenable, isAuthenticatedListenable, userTextListenable]),
        ),
      ],
      onError: (final error, final stackTrace) => _errorsObserver.value = <({Object error, StackTrace stackTrace})>[
        (error: error, stackTrace: stackTrace),
        ..._errorsObserver.value,
      ],
      notFound: (final _, final _, final _) => const NotFoundScreen(),
    );
  }
}

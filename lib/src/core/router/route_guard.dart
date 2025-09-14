import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:octopus/octopus.dart';
import 'package:stylish/src/core/router/routes.dart';
import 'package:stylish/src/core/util/shared_preferences_util.dart';

class RouteGuard extends OctopusGuard {
  RouteGuard({
    required this.isInitializedListenable,
    this.isAuthenticatedListenable,
    this.userTextListenable,
    super.refresh,
  });

  final ValueListenable<bool> isInitializedListenable;
  final ValueListenable<bool>? isAuthenticatedListenable;
  final ValueListenable<String>? userTextListenable;

  @override
  FutureOr<OctopusState> call(
    final List<OctopusHistoryEntry> history,
    final OctopusState$Mutable state,
    final Map<String, Object?> context,
  ) async {
    if (!isInitializedListenable.value) return OctopusState.single(Routes.splash.node());

    final shouldShowOnboarding = App$SharedPreferencesUtil.loadShouldShowOnboarding() ?? true;
    if (shouldShowOnboarding) return OctopusState.single(Routes.onboarding.node());

    final isAuthenticated = isAuthenticatedListenable?.value ?? false;
    final route = state.children.lastOrNull;
    final noNeedAuthenticationRoutes = <String>{Routes.login.name, Routes.signUp.name};
    final isAllowedWithoutAuthorization = noNeedAuthenticationRoutes.contains(route?.name);
    if (!isAuthenticated) {
      if (isAllowedWithoutAuthorization)
        return state;
      else
        return OctopusState.single(Routes.login.node());
    }

    final userText = userTextListenable?.value ?? '';
    if (userText.isEmpty) return OctopusState.single(Routes.setUp.node());

    if (state.isEmpty) return _fix(state);
    final homeCount = state.findAllByName(Routes.home.name).length;
    if (homeCount != 1) return _fix(state);
    if (state.children.first.name != Routes.home.name) return _fix(state);

    return state;
  }

  OctopusState _fix(final OctopusState$Mutable state) {
    state
      ..clear()
      ..putIfAbsent(Routes.home.name, Routes.home.node);

    final home = state.findByName(Routes.home.name);

    if (home == null) throw UnimplementedError();

    return state;
  }
}

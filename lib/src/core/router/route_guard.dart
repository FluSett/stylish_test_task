import 'dart:async';

import 'package:octopus/octopus.dart';
import 'package:stylish/src/core/bloc/router_cubit.dart';
import 'package:stylish/src/core/router/routes.dart';
import 'package:stylish/src/core/util/shared_preferences_util.dart';

class RouteGuard extends OctopusGuard {
  RouteGuard({required this.getState, super.refresh});

  final RouterState Function() getState;

  @override
  FutureOr<OctopusState> call(
    final List<OctopusHistoryEntry> history,
    final OctopusState$Mutable state,
    final Map<String, Object?> context,
  ) async {
    final routerState = getState();

    if (!routerState.isInitialized || routerState.isUserTextInitializing)
      return OctopusState.single(Routes.splash.node());

    final shouldShowOnboarding = App$SharedPreferencesUtil.loadShouldShowOnboarding() ?? true;
    if (shouldShowOnboarding) return OctopusState.single(Routes.onboarding.node());

    final route = state.children.lastOrNull;
    final noNeedAuthenticationRoutes = <String>{Routes.login.name, Routes.signUp.name};
    final isAllowedWithoutAuthorization = noNeedAuthenticationRoutes.contains(route?.name);
    if (!routerState.isAuthenticated) {
      if (isAllowedWithoutAuthorization)
        return state;
      else
        return OctopusState.single(Routes.login.node());
    }

    if (routerState.isUserTextEmpty) return OctopusState.single(Routes.setUp.node());

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

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:octopus/octopus.dart';
import 'package:stylish/src/core/bloc/router_cubit.dart';
import 'package:stylish/src/core/extension/build_context_extension.dart';
import 'package:stylish/src/core/router/route_guard.dart';
import 'package:stylish/src/core/router/routes.dart';
import 'package:stylish/src/feature/not_found/widget/not_found_screen.dart';

mixin RouterStateMixin<T extends StatefulWidget> on State<T> {
  late final Octopus router;

  final errorsObserver = ValueNotifier<List<({Object error, StackTrace stackTrace})>>(
    <({Object error, StackTrace stackTrace})>[],
  );

  StreamSubscription<RouterState>? _routerBlocSubscription;
  final _routerStateNotifier = ValueNotifier<RouterState>(const RouterState());

  @override
  void initState() {
    super.initState();

    final routerBloc = context.tryReadBloc<RouterCubit>();
    if (routerBloc != null) {
      _routerStateNotifier.value = routerBloc.state;
      _routerBlocSubscription?.cancel();
      _routerBlocSubscription = routerBloc.stream.listen((state) => _routerStateNotifier.value = state);
    }

    router = Octopus(
      routes: Routes.values,
      defaultRoute: Routes.splash,
      transitionDelegate: const DefaultTransitionDelegate<void>(),
      guards: <IOctopusGuard>[RouteGuard(getState: () => _routerStateNotifier.value, refresh: _routerStateNotifier)],
      onError: (final error, final stackTrace) => errorsObserver.value = <({Object error, StackTrace stackTrace})>[
        (error: error, stackTrace: stackTrace),
        ...errorsObserver.value,
      ],
      notFound: (final _, final _, final _) => const NotFoundScreen(),
    );
  }

  @override
  void dispose() {
    _routerStateNotifier.dispose();
    _routerBlocSubscription?.cancel();
    _routerBlocSubscription = null;
    super.dispose();
  }
}

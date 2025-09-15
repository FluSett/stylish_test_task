import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish/src/core/bloc/app_bloc.dart';
import 'package:stylish/src/core/bloc/router_cubit.dart';
import 'package:stylish/src/core/constant/asset_paths.dart';
import 'package:stylish/src/core/main/no_scroll_behavior.dart';
import 'package:stylish/src/core/router/route_state_mixin.dart';
import 'package:stylish/src/core/theme/theme.dart';
import 'package:stylish/src/feature/authentication/bloc/authentication_bloc.dart';
import 'package:stylish/src/feature/authentication/bloc/authentication_status_cubit.dart';
import 'package:stylish/src/feature/profile/bloc/profile_bloc.dart';

@immutable
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_precacheBackgroundImage);
  }

  Future<void> _precacheBackgroundImage() async {
    const imageProvider = AssetImage(App$AssetPaths.homeBackground);
    if (!context.mounted) return;
    await precacheImage(imageProvider, context);
  }

  @override
  Widget build(final BuildContext context) => BlocSelector<AppBloc, AppState, bool>(
    selector: (final state) => state.isInitialized,
    builder: (final context, final isInitialized) => isInitialized
        ? MultiBlocProvider(
            providers: <BlocProvider>[
              BlocProvider<AuthenticationStatusCubit>(
                create: (final context) =>
                    AuthenticationStatusCubit(context.read<AppBloc>().state.authenticationRepository),
              ),
              BlocProvider<AuthenticationBloc>(
                create: (final context) => AuthenticationBloc(context.read<AppBloc>().state.authenticationRepository),
              ),
              BlocProvider<ProfileBloc>(
                create: (final context) => ProfileBloc(context.read<AppBloc>().state.profileRepository),
              ),
            ],
            child: BlocListener<AuthenticationStatusCubit, AuthenticationStatusState>(
              listenWhen: (final p, final c) => p.isAuthenticated != c.isAuthenticated,
              listener: (final context, final state) {
                if (!state.isAuthenticated) return;
                context.read<ProfileBloc>().add(const ProfileLoadTextEvent(isInitializing: true));
              },
              child: const _InitializedMaterialApp(),
            ),
          )
        : const _MaterialApp(),
  );
}

@immutable
class _MaterialApp extends StatefulWidget {
  const _MaterialApp();

  @override
  State<_MaterialApp> createState() => _App$MaterialAppState();
}

class _App$MaterialAppState extends State<_MaterialApp> with RouterStateMixin {
  final _builderKey = GlobalKey();

  @override
  Widget build(final BuildContext context) => MaterialApp.router(
    routerConfig: router.config,
    debugShowCheckedModeBanner: false,
    theme: App$Theme.themeData,
    builder: (final context, final child) => AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: ScrollConfiguration(
        key: _builderKey,
        behavior: NoScrollbarBehavior(),
        child: child ?? const SizedBox.shrink(),
      ),
    ),
  );
}

@immutable
class _InitializedMaterialApp extends StatelessWidget {
  const _InitializedMaterialApp();

  @override
  Widget build(final BuildContext context) => BlocProvider<RouterCubit>(
    create: (final _) => RouterCubit(
      appBloc: context.read<AppBloc>(),
      authenticationStatusCubit: context.read<AuthenticationStatusCubit>(),
      profileBloc: context.read<ProfileBloc>(),
    ),
    child: const _MaterialApp(),
  );
}

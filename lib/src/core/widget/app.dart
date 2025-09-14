import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish/src/core/bloc/app_bloc.dart';
import 'package:stylish/src/core/constant/asset_paths.dart';
import 'package:stylish/src/core/main/no_scroll_behavior.dart';
import 'package:stylish/src/core/router/route_state_mixin.dart';
import 'package:stylish/src/core/theme/theme.dart';
import 'package:stylish/src/feature/authentication/bloc/authentication_bloc.dart';
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

  Future<void> _precacheBackgroundImage() async => App$AssetPaths.forCaching.map((asset) async {
    const imageProvider = AssetImage(App$AssetPaths.homeBackground);
    if (!context.mounted) return;
    await precacheImage(imageProvider, context);
  });

  @override
  Widget build(final BuildContext context) => ValueListenableBuilder<bool>(
    valueListenable: context.read<AppBloc>().isInitializedListenable,
    builder: (final context, final isInitialized, final child) => isInitialized
        ? BlocBuilder<AppBloc, AppState>(
            builder: (final context, final state) => MultiBlocProvider(
              providers: <BlocProvider>[
                BlocProvider<AuthenticationBloc>(
                  create: (final _) => AuthenticationBloc(state.authenticationRepository),
                ),
                BlocProvider<ProfileBloc>(create: (final _) => ProfileBloc(state.profileRepository)),
              ],
              child: App$Material(isInitialized: isInitialized),
            ),
          )
        : const App$Material(),
  );
}

@immutable
class App$Material extends StatefulWidget {
  const App$Material({this.isInitialized = false, super.key});

  final bool isInitialized;

  @override
  State<App$Material> createState() => _App$MaterialState();
}

class _App$MaterialState extends State<App$Material> {
  final _builderKey = GlobalKey();

  @override
  Widget build(final BuildContext context) {
    final content = MaterialApp.router(
      routerConfig: RouterUtil.getRouter(context).config,
      debugShowCheckedModeBanner: false,
      theme: App$Theme.themeData,
      builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
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
    return widget.isInitialized
        ? BlocListener<AuthenticationBloc, AuthenticationState>(
            listenWhen: (final p, final c) => p.isAuthenticated != c.isAuthenticated,
            listener: (final context, final state) {
              if (!state.isAuthenticated) return;
              context.read<ProfileBloc>().add(const ProfileLoadTextEvent());
            },
            child: content,
          )
        : content;
  }
}

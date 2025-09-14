import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish/src/core/constant/asset_paths.dart';
import 'package:stylish/src/core/theme/theme.dart';
import 'package:stylish/src/core/widget/scaffold.dart';
import 'package:stylish/src/feature/authentication/bloc/authentication_bloc.dart';
import 'package:stylish/src/feature/profile/bloc/profile_bloc.dart';

@immutable
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const ProfileLoadEmailEvent());
  }

  @override
  Widget build(final BuildContext context) {
    final theme = context.theme;
    final bodyTextStyle = theme.customTextTheme.body.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.02,
    );
    return App$Scaffold(
      extendBody: true,
      withSafeArea: false,
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage(App$AssetPaths.homeBackground), fit: BoxFit.cover),
      ),
      body: Stack(
        children: [
          const SizedBox.expand(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black, Colors.black],
                  stops: [0.6, 0.9, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(51, 36, 45, 34),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Test completed',
                    textAlign: TextAlign.center,
                    style: theme.customTextTheme.titleLarge.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  BlocSelector<ProfileBloc, ProfileState, String>(
                    selector: (final state) => state.email,
                    builder: (final context, final email) =>
                        Text('You are signed in as:\n$email', textAlign: TextAlign.center, style: bodyTextStyle),
                  ),
                  const SizedBox(height: 12),
                  ValueListenableBuilder<String>(
                    valueListenable: context.read<ProfileBloc>().userTextListenable,
                    builder: (final context, final userText, final _) =>
                        Text('Your text is::\n$userText', textAlign: TextAlign.center, style: bodyTextStyle),
                  ),
                  const Spacer(),
                  BlocSelector<AuthenticationBloc, AuthenticationState, bool>(
                    selector: (state) => state.requestStatus.isIdle || state.requestStatus.isError,
                    builder: (context, isReady) => ElevatedButton(
                      key: ValueKey('LogoutButton-$isReady'),
                      onPressed: isReady
                          ? () => context.read<AuthenticationBloc>().add(const AuthenticationLogoutEvent())
                          : null,
                      child: const Text('Log out', maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

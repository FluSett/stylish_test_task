import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:stylish/src/core/bloc/app_bloc.dart';
import 'package:stylish/src/feature/authentication/bloc/authentication_status_cubit.dart';
import 'package:stylish/src/feature/profile/bloc/profile_bloc.dart';

@immutable
final class RouterState {
  const RouterState({
    this.isInitialized = false,
    this.isAuthenticated = false,
    this.isUserTextEmpty = true,
    this.isUserTextInitializing = false,
  });

  final bool isInitialized;
  final bool isAuthenticated;
  final bool isUserTextEmpty;
  final bool isUserTextInitializing;

  RouterState copyWith({
    final bool? isInitialized,
    final bool? isAuthenticated,
    final bool? isUserTextEmpty,
    final bool? isUserTextInitializing,
  }) => RouterState(
    isInitialized: isInitialized ?? this.isInitialized,
    isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    isUserTextEmpty: isUserTextEmpty ?? this.isUserTextEmpty,
    isUserTextInitializing: isUserTextInitializing ?? this.isUserTextInitializing,
  );
}

class RouterCubit extends Cubit<RouterState> {
  RouterCubit({required this.appBloc, required this.authenticationStatusCubit, required this.profileBloc})
    : super(
        RouterState(
          isInitialized: appBloc.state.isInitialized,
          isAuthenticated: authenticationStatusCubit.state.isAuthenticated,
          isUserTextEmpty: profileBloc.state.userText.isEmpty,
          isUserTextInitializing: profileBloc.state.userTextStatus.isProcessing,
        ),
      ) {
    _appSubscription = _listenToAppState();
    _authenticationStatusSubscription = _listenToAuthenticationStatus();
    _profileSubscription = _listenToProfile();
  }

  final AppBloc appBloc;
  final AuthenticationStatusCubit authenticationStatusCubit;
  final ProfileBloc profileBloc;

  late final StreamSubscription<AppState> _appSubscription;
  late final StreamSubscription<AuthenticationStatusState> _authenticationStatusSubscription;
  late final StreamSubscription<ProfileState> _profileSubscription;

  @override
  Future<void> close() {
    _appSubscription.cancel();
    _authenticationStatusSubscription.cancel();
    _profileSubscription.cancel();
    return super.close();
  }

  StreamSubscription<AppState> _listenToAppState() =>
      appBloc.stream.listen((appState) => emit(state.copyWith(isInitialized: appState.isInitialized)));

  StreamSubscription<AuthenticationStatusState> _listenToAuthenticationStatus() => authenticationStatusCubit.stream
      .listen((authState) => emit(state.copyWith(isAuthenticated: authState.isAuthenticated)));

  StreamSubscription<ProfileState> _listenToProfile() => profileBloc.stream.listen((profileState) {
    final isUserTextInitializing = profileState.userTextStatus.isProcessing;
    emit(
      state.copyWith(isUserTextEmpty: profileState.userText.isEmpty, isUserTextInitializing: isUserTextInitializing),
    );
  });
}

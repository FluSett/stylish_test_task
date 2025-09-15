import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish/src/core/main/request_statuses.dart';
import 'package:stylish/src/core/util/logger.dart';
import 'package:stylish/src/feature/data/authentication_repository.dart';

@immutable
sealed class AuthenticationEvent {
  const AuthenticationEvent();
}

final class AuthenticationLoginEvent extends AuthenticationEvent {
  const AuthenticationLoginEvent({required this.email, required this.password, this.onError});

  final String email;
  final String password;
  final void Function(String message)? onError;

  @override
  bool operator ==(final Object other) =>
      identical(this, other) &&
      other is AuthenticationLoginEvent &&
      other.runtimeType == runtimeType &&
      other.email == email &&
      other.password == password &&
      other.onError == onError;

  @override
  int get hashCode => Object.hash(email, password, onError);
}

final class AuthenticationSignUpEvent extends AuthenticationEvent {
  const AuthenticationSignUpEvent({required this.email, required this.password, this.onError});

  final String email;
  final String password;
  final void Function(String message)? onError;

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      (other is AuthenticationSignUpEvent &&
          other.runtimeType == runtimeType &&
          other.email == email &&
          other.password == password &&
          other.onError == onError);

  @override
  int get hashCode => Object.hash(email, password, onError);
}

final class AuthenticationLogoutEvent extends AuthenticationEvent {
  const AuthenticationLogoutEvent();
}

@immutable
final class AuthenticationState {
  const AuthenticationState({this.requestStatus = RequestStatuses.idle});

  final RequestStatuses requestStatus;

  AuthenticationState copyWith({final RequestStatuses? requestStatus}) =>
      AuthenticationState(requestStatus: requestStatus ?? this.requestStatus);
}

final class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(this._authenticationRepository) : super(const AuthenticationState()) {
    on<AuthenticationLoginEvent>(_login);
    on<AuthenticationSignUpEvent>(_signUp);
    on<AuthenticationLogoutEvent>(_logout);
  }

  final AuthenticationRepository _authenticationRepository;

  Future<void> _login(final AuthenticationLoginEvent event, final Emitter<AuthenticationState> emit) async {
    try {
      emit(state.copyWith(requestStatus: RequestStatuses.processing));
      await _authenticationRepository.login(email: event.email, password: event.password);
      emit(state.copyWith(requestStatus: RequestStatuses.idle));
    } on Object catch (error, stackTrace) {
      logger.severe('Failed to login via Firebase', error, stackTrace);
      emit(state.copyWith(requestStatus: RequestStatuses.error));
      event.onError?.call(error.toString());
      rethrow;
    }
  }

  Future<void> _signUp(final AuthenticationSignUpEvent event, final Emitter<AuthenticationState> emit) async {
    try {
      emit(state.copyWith(requestStatus: RequestStatuses.processing));
      await _authenticationRepository.signUp(email: event.email, password: event.password);
      emit(state.copyWith(requestStatus: RequestStatuses.idle));
    } on Object catch (error, stackTrace) {
      logger.severe('Failed to login via Firebase', error, stackTrace);
      emit(state.copyWith(requestStatus: RequestStatuses.error));
      event.onError?.call(error.toString());
    }
  }

  Future<void> _logout(final AuthenticationLogoutEvent event, final Emitter<AuthenticationState> emit) async {
    try {
      emit(state.copyWith(requestStatus: RequestStatuses.processing));
      await _authenticationRepository.logout();
      emit(state.copyWith(requestStatus: RequestStatuses.idle));
    } on Object catch (error, stackTrace) {
      logger.severe('Failed to logout', error, stackTrace);
      emit(state.copyWith(requestStatus: RequestStatuses.error));
    }
  }
}

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:stylish/src/feature/data/authentication_repository.dart';

@immutable
final class AuthenticationStatusState {
  const AuthenticationStatusState({this.isAuthenticated = false});

  final bool isAuthenticated;
}

class AuthenticationStatusCubit extends Cubit<AuthenticationStatusState> {
  AuthenticationStatusCubit(this._authenticationRepository) : super(const AuthenticationStatusState()) {
    _authenticationSubscription = _authenticationRepository.isAuthenticatedChanges().listen(
      (final value) => emit(AuthenticationStatusState(isAuthenticated: value)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<bool> _authenticationSubscription;

  @override
  Future<void> close() {
    _authenticationSubscription.cancel();
    return super.close();
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish/src/core/main/request_statuses.dart';
import 'package:stylish/src/core/util/logger.dart';
import 'package:stylish/src/feature/profile/data/profile_repository.dart';

@immutable
sealed class ProfileEvent {
  const ProfileEvent();
}

final class ProfileLoadEmailEvent extends ProfileEvent {
  const ProfileLoadEmailEvent();
}

final class ProfileLoadTextEvent extends ProfileEvent {
  const ProfileLoadTextEvent({this.isInitializing = false});

  final bool isInitializing;

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      (other is ProfileLoadTextEvent && other.runtimeType == runtimeType && other.isInitializing == isInitializing);

  @override
  int get hashCode => isInitializing.hashCode;
}

final class ProfileSaveTextEvent extends ProfileEvent {
  const ProfileSaveTextEvent({required this.value, this.onError});

  final String value;
  final void Function(String message)? onError;

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      (other is ProfileSaveTextEvent &&
          other.runtimeType == runtimeType &&
          other.value == value &&
          other.onError == onError);

  @override
  int get hashCode => Object.hash(value, onError);
}

@immutable
final class ProfileState {
  const ProfileState({
    this.userTextStatus = RequestStatuses.idle,
    this.userText = '',
    this.isUserTextInitializing = false,
    this.email = '',
    this.emailStatus = RequestStatuses.idle,
  });

  final RequestStatuses userTextStatus;
  final String userText;
  final bool isUserTextInitializing;
  final RequestStatuses emailStatus;
  final String email;

  ProfileState copyWith({
    final RequestStatuses? userTextStatus,
    final String? userText,
    final bool? isUserTextInitializing,
    final RequestStatuses? emailStatus,
    final String? email,
  }) => ProfileState(
    userTextStatus: userTextStatus ?? this.userTextStatus,
    userText: userText ?? this.userText,
    isUserTextInitializing: isUserTextInitializing ?? this.isUserTextInitializing,
    emailStatus: emailStatus ?? this.emailStatus,
    email: email ?? this.email,
  );
}

final class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._profileRepository) : super(const ProfileState()) {
    on<ProfileLoadEmailEvent>(_loadEmail);
    on<ProfileLoadTextEvent>(_loadText);
    on<ProfileSaveTextEvent>(_saveText);
  }

  final ProfileRepository _profileRepository;

  Future<void> _loadText(final ProfileLoadTextEvent event, final Emitter<ProfileState> emit) async {
    try {
      emit(state.copyWith(userTextStatus: RequestStatuses.processing, isUserTextInitializing: event.isInitializing));
      final userText = await _profileRepository.loadText();
      emit(state.copyWith(userTextStatus: RequestStatuses.idle, userText: userText));
    } on Object catch (error, stackTrace) {
      logger.severe('Failed to load text', error, stackTrace);
      emit(state.copyWith(userTextStatus: RequestStatuses.error));
    } finally {
      emit(state.copyWith(isUserTextInitializing: false));
    }
  }

  Future<void> _saveText(final ProfileSaveTextEvent event, final Emitter<ProfileState> emit) async {
    try {
      emit(state.copyWith(userTextStatus: RequestStatuses.processing));
      await _profileRepository.saveText(event.value);
      emit(state.copyWith(userTextStatus: RequestStatuses.idle, userText: event.value));
    } on Object catch (error, stackTrace) {
      logger.severe('Failed to save text', error, stackTrace);
      emit(state.copyWith(userTextStatus: RequestStatuses.error));
      event.onError?.call(error.toString());
    }
  }

  Future<void> _loadEmail(final ProfileLoadEmailEvent event, final Emitter<ProfileState> emit) async {
    try {
      emit(state.copyWith(emailStatus: RequestStatuses.processing));
      final email = await _profileRepository.loadEmail();
      emit(state.copyWith(email: email, emailStatus: RequestStatuses.idle));
    } on Object catch (error, stackTrace) {
      logger.severe('Failed to load email', error, stackTrace);
      emit(state.copyWith(emailStatus: RequestStatuses.error));
    }
  }
}

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
  const ProfileLoadTextEvent();
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
    this.email = '',
    this.textStatus = RequestStatuses.idle,
    this.emailStatus = RequestStatuses.idle,
  });

  final RequestStatuses textStatus;
  final RequestStatuses emailStatus;
  final String email;

  ProfileState copyWith({final String? email, final RequestStatuses? textStatus, final RequestStatuses? emailStatus}) =>
      ProfileState(
        email: email ?? this.email,
        textStatus: textStatus ?? this.textStatus,
        emailStatus: emailStatus ?? this.emailStatus,
      );
}

final class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._profileRepository) : super(const ProfileState()) {
    on<ProfileLoadEmailEvent>(_loadEmail);
    on<ProfileLoadTextEvent>(_loadText);
    on<ProfileSaveTextEvent>(_saveText);
  }

  final ProfileRepository _profileRepository;

  final _userTextNotifier = ValueNotifier<String>('');
  ValueListenable<String> get userTextListenable => _userTextNotifier;

  Future<void> _loadEmail(final ProfileLoadEmailEvent event, final Emitter<ProfileState> emit) async {
    try {
      emit(state.copyWith(emailStatus: RequestStatuses.processing));
      final email = await _profileRepository.loadEmail();
      emit(state.copyWith(email: email, emailStatus: RequestStatuses.idle));
    } on Object catch (error, stackTrace) {
      logger.severe('Failed to load email', error, stackTrace);
      emit(state.copyWith(emailStatus: RequestStatuses.error));
      rethrow;
    }
  }

  Future<void> _loadText(final ProfileLoadTextEvent event, final Emitter<ProfileState> emit) async {
    try {
      emit(state.copyWith(textStatus: RequestStatuses.processing));
      final text = await _profileRepository.loadText();
      _userTextNotifier.value = text;
      emit(state.copyWith(textStatus: RequestStatuses.idle));
    } on Object catch (error, stackTrace) {
      logger.severe('Failed to load text', error, stackTrace);
      emit(state.copyWith(textStatus: RequestStatuses.error));
      rethrow;
    }
  }

  Future<void> _saveText(final ProfileSaveTextEvent event, final Emitter<ProfileState> emit) async {
    try {
      emit(state.copyWith(textStatus: RequestStatuses.processing));
      await _profileRepository.saveText(event.value);
      _userTextNotifier.value = event.value;
      emit(state.copyWith(textStatus: RequestStatuses.idle));
    } on Object catch (error, stackTrace) {
      logger.severe('Failed to save text', error, stackTrace);
      emit(state.copyWith(textStatus: RequestStatuses.error));
      event.onError?.call(error.toString());
      rethrow;
    }
  }
}

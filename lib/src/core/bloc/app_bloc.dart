import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish/firebase_options.dart';
import 'package:stylish/src/core/main/bloc_observer.dart';
import 'package:stylish/src/core/util/logger.dart';
import 'package:stylish/src/core/util/shared_preferences_util.dart';
import 'package:stylish/src/feature/data/authentication_repository.dart';
import 'package:stylish/src/feature/profile/data/profile_repository.dart';

@immutable
sealed class AppEvent {
  const AppEvent();
}

final class AppInitializeEvent extends AppEvent {
  const AppInitializeEvent();
}

@immutable
final class AppState {
  const AppState({
    this.isInitialized = false,
    this.initializationStep = 0,
    final AuthenticationRepository? authenticationRepository,
    final ProfileRepository? profileRepository,
  }) : authenticationRepositoryOrNull = authenticationRepository,
       profileRepositoryOrNull = profileRepository;

  final bool isInitialized;
  final int initializationStep;
  final AuthenticationRepository? authenticationRepositoryOrNull;
  final ProfileRepository? profileRepositoryOrNull;

  AuthenticationRepository get authenticationRepository => authenticationRepositoryOrNull == null
      ? throw ArgumentError('No AuthenticationRepository')
      : authenticationRepositoryOrNull!;

  ProfileRepository get profileRepository =>
      profileRepositoryOrNull == null ? throw ArgumentError('No ProfileRepository') : profileRepositoryOrNull!;

  AppState copyWith({
    final bool? isInitialized,
    final int? initializationStep,
    final AuthenticationRepository? authenticationRepository,
    final ProfileRepository? profileRepository,
  }) => AppState(
    isInitialized: isInitialized ?? this.isInitialized,
    initializationStep: initializationStep ?? this.initializationStep,
    authenticationRepository: authenticationRepository ?? authenticationRepositoryOrNull,
    profileRepository: profileRepository ?? profileRepositoryOrNull,
  );
}

final class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppState()) {
    on<AppInitializeEvent>(_onInitializeApp);
  }

  Future<void> _onInitializeApp(final AppInitializeEvent event, final Emitter<AppState> emit) async {
    try {
      emit(state.copyWith(isInitialized: false));
      final stopwatch = Stopwatch()..start();

      await _initializeDependencies(emit);

      logger.info('Initialization time: ${stopwatch.elapsed}');

      stopwatch.stop();
      emit(state.copyWith(isInitialized: true));
    } on Object catch (error, stackTrace) {
      logger.severe('Failed to initialize app (${state.initializationStep})', error, stackTrace);
    }
  }

  Future<void> _catchExceptions() async {
    try {
      PlatformDispatcher.instance.onError = (error, stackTrace) {
        logger.shout('ROOT ERROR\r\n${Error.safeToString(error)}', error, stackTrace);
        return true;
      };

      final sourceFlutterError = FlutterError.onError;
      FlutterError.onError = (final details) {
        logger.shout('FLUTTER ERROR\r\n$details', details.exception, details.stack ?? StackTrace.current);
        sourceFlutterError?.call(details);
      };
    } on Object catch (error, stackTrace) {
      logger.shout('FlutterError on Object', error, stackTrace);
    }
  }

  Future<void> _initializeDependencies(final Emitter<AppState> emit) async {
    final initializationSteps = <String, FutureOr<void> Function()>{
      'Initialization': () async {
        LoggerUtil.init();
        Bloc.observer = App$BlocObserver();
        await _catchExceptions();
        await App$SharedPreferencesUtil.init();
        await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
        final authenticationRepository = FirebaseAuthenticationRepository();
        final profileRepository = FirebaseProfileRepository();

        emit(state.copyWith(authenticationRepository: authenticationRepository, profileRepository: profileRepository));
      },
    };

    final totalSteps = initializationSteps.length;
    var currentStep = 0;
    for (final step in initializationSteps.entries) {
      currentStep++;
      final percent = (currentStep * 100 ~/ totalSteps).clamp(0, 100);
      logger.info('Initialization | $currentStep/$totalSteps ($percent%) | (${step.key})');
      await step.value();
    }
  }
}

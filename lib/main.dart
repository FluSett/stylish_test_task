import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:stylish/src/core/bloc/app_bloc.dart';
import 'package:stylish/src/core/util/logger.dart';
import 'package:stylish/src/core/widget/app.dart';

Future<void> main() async => runZonedGuarded(() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Future.delayed(const Duration(seconds: 3), FlutterNativeSplash.remove);

  runApp(BlocProvider<AppBloc>(create: (final _) => AppBloc()..add(const AppInitializeEvent()), child: const App()));
}, (error, stackTrace) => logger.shout('TOP ZONE GUARDED', error, stackTrace));

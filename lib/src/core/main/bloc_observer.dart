import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish/src/core/util/logger.dart';

class App$BlocObserver extends BlocObserver {
  @override
  void onChange(final BlocBase<dynamic> bloc, final Change<dynamic> change) {
    super.onChange(bloc, change);
    logger.info('${bloc.runtimeType} $change');
  }

  @override
  void onError(final BlocBase<dynamic> bloc, final Object error, final StackTrace stackTrace) {
    logger.severe('${bloc.runtimeType} $error $stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}

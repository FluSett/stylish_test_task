import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension BuildContextExtension on BuildContext {
  T? tryReadBloc<T extends BlocBase<Object>>() {
    try {
      return read<T>();
    } on Object {
      return null;
    }
  }
}

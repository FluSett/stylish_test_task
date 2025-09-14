import 'package:flutter/material.dart';
import 'package:stylish/src/core/theme/theme.dart';

@immutable
final class WidgetUtil {
  static void showErrorSnackbar(final BuildContext context, final String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: context.theme.customTextTheme.body.copyWith(color: context.theme.colorScheme.onPrimary),
      ),
      backgroundColor: context.theme.colorScheme.error,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}

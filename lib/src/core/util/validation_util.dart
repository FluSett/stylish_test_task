import 'package:meta/meta.dart';

@immutable
final class ValidationUtil {
  static String? email(final String value) {
    if (value.isEmpty) return 'Email cannot be empty.';

    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) return 'Please enter a valid email address.';

    return null;
  }

  static String? password(final String value) {
    if (value.isEmpty) return 'Password cannot be empty.';

    if (value.length < 6) return 'Password must be at least 6 characters long.';

    return null;
  }
}

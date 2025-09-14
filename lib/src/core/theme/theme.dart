import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

part 'text_theme.dart';

@immutable
final class App$Theme {
  static const _backgroundColor = Color(0xFFFFFFFF);
  static const _primaryColor = Color(0xFFF83758);
  static const _disabledPrimaryColor = Color(0xFFF39FA2);
  static const _onPrimaryColor = Color(0xFFFFFFFF);
  static const _disabledOnPrimaryColor = Color(0xFFFDFDFD);
  static const _textFieldColor = Color(0xFFF3F3F3);
  static const _textFieldIconColor = Color(0xFF626262);
  static const _textFieldBorderColor = Color(0xFFA8A8A9);
  static const _hintColor = Color(0xFF676767);
  static final _borderRadius = BorderRadius.circular(10);

  static const _textFieldHintStyle = TextStyle(color: _hintColor, fontSize: 12, fontWeight: FontWeight.w500);
  static final themeData = ThemeData(
    brightness: Brightness.light,
    textTheme: GoogleFonts.montserratTextTheme(),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {TargetPlatform.android: FadeUpwardsPageTransitionsBuilder()},
    ),
    scaffoldBackgroundColor: _backgroundColor,
    primaryColor: _primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryColor,
      primary: _primaryColor,
      error: _primaryColor,
      onPrimary: _onPrimaryColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: _textFieldHintStyle,
      filled: true,
      fillColor: _textFieldColor,
      prefixIconColor: _textFieldIconColor,
      suffixIconColor: _textFieldIconColor,
      border: OutlineInputBorder(
        borderRadius: _borderRadius,
        borderSide: const BorderSide(color: _textFieldBorderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: _borderRadius,
        borderSide: const BorderSide(color: _textFieldBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: _borderRadius,
        borderSide: const BorderSide(color: _textFieldBorderColor, width: 2),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>((final states) {
          if (states.contains(WidgetState.disabled)) return _disabledPrimaryColor;
          return _primaryColor;
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((final states) {
          if (states.contains(WidgetState.disabled)) return _disabledOnPrimaryColor;
          return _onPrimaryColor;
        }),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
        shape: WidgetStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
        textStyle: WidgetStateProperty.all<TextStyle>(const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        elevation: WidgetStateProperty.resolveWith<double>((final states) {
          if (states.contains(WidgetState.disabled)) return 0;
          return 5;
        }),
      ),
    ),
    extensions: const <ThemeExtension>[_defaultTextTheme, _defaultAppTheme],
  );
}

const _defaultAppTheme = AppTheme(title: Color(0xFF000000), body: Color(0xFFA8A8A9));

@immutable
class AppTheme extends ThemeExtension<AppTheme> {
  const AppTheme({required this.title, required this.body});

  final Color title;
  final Color body;

  @override
  AppTheme copyWith({final Color? title, final Color? body}) =>
      AppTheme(title: title ?? this.title, body: body ?? this.body);

  @override
  AppTheme lerp(final ThemeExtension<AppTheme>? other, final double t) => other is! AppTheme
      ? this
      : AppTheme(title: Color.lerp(title, other.title, t)!, body: Color.lerp(body, other.body, t)!);
}

extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
}

extension ThemeDataExtension on ThemeData {
  AppTheme get appTheme => extension<AppTheme>() ?? _defaultAppTheme;

  App$TextTheme get customTextTheme => extension<App$TextTheme>() ?? _defaultTextTheme;
}

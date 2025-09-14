part of 'theme.dart';

const _defaultTextTheme = App$TextTheme(
  title: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
  titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
  body: TextStyle(fontSize: 14),
  pageTitle: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
  display: TextStyle(fontWeight: FontWeight.bold, fontSize: 36, height: 1.19),
);

@immutable
class App$TextTheme extends ThemeExtension<App$TextTheme> {
  const App$TextTheme({
    required this.title,
    required this.titleLarge,
    required this.body,
    required this.pageTitle,
    required this.display,
  });

  final TextStyle title;
  final TextStyle titleLarge;
  final TextStyle body;
  final TextStyle pageTitle;
  final TextStyle display;

  @override
  App$TextTheme copyWith({
    final TextStyle? title,
    final TextStyle? titleLarge,
    final TextStyle? body,
    final TextStyle? pageTitle,
    final TextStyle? display,
  }) => App$TextTheme(
    title: title ?? this.title,
    titleLarge: titleLarge ?? this.titleLarge,
    body: body ?? this.body,
    pageTitle: pageTitle ?? this.pageTitle,
    display: display ?? this.display,
  );

  @override
  App$TextTheme lerp(final ThemeExtension<App$TextTheme>? other, final double t) => other is! App$TextTheme
      ? this
      : App$TextTheme(
          title: TextStyle.lerp(title, other.title, t)!,
          titleLarge: TextStyle.lerp(titleLarge, other.titleLarge, t)!,
          body: TextStyle.lerp(body, other.body, t)!,
          pageTitle: TextStyle.lerp(pageTitle, other.pageTitle, t)!,
          display: TextStyle.lerp(display, other.display, t)!,
        );
}

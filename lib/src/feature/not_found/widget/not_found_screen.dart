import 'package:flutter/material.dart';
import 'package:stylish/src/core/widget/scaffold.dart';

@immutable
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(final BuildContext context) =>
      const App$Scaffold(backgroundColor: Colors.red, body: Center(child: Text('NOT FOUND')));
}

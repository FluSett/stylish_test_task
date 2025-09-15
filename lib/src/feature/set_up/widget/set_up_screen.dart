import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish/src/core/constant/custom_icons.dart';
import 'package:stylish/src/core/theme/theme.dart';
import 'package:stylish/src/core/util/widget_util.dart';
import 'package:stylish/src/core/widget/scaffold.dart';
import 'package:stylish/src/feature/profile/bloc/profile_bloc.dart';

@immutable
class SetUpScreen extends StatefulWidget {
  const SetUpScreen({super.key});

  @override
  State<SetUpScreen> createState() => _SetUpScreenState();
}

class _SetUpScreenState extends State<SetUpScreen> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final theme = context.theme;
    return App$Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 20, 26, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FractionallySizedBox(
              widthFactor: 0.6,
              alignment: AlignmentGeometry.topLeft,
              child: Text(
                'Set up account',
                textAlign: TextAlign.start,
                style: theme.customTextTheme.display.copyWith(color: theme.appTheme.title),
              ),
            ),
            const SizedBox(height: 36),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Enter any text',
                prefixIcon: Icon(CustomIcons.user, size: 16),
              ),
            ),
            const SizedBox(height: 31),
            BlocSelector<ProfileBloc, ProfileState, bool>(
              selector: (state) => !state.userTextStatus.isProcessing,
              builder: (context, isReady) => ElevatedButton(
                key: ValueKey('FinishButton-$isReady'),
                onPressed: isReady ? () => _finish(context) : null,
                child: const Text('Finish', maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _finish(final BuildContext context) async {
    final text = _textController.text.trim();
    if (text.length < 4) return WidgetUtil.showErrorSnackbar(context, 'The text can\'t be less than 4 characters');

    context.read<ProfileBloc>().add(
      ProfileSaveTextEvent(
        value: text,
        onError: (final message) {
          if (!context.mounted) return;
          WidgetUtil.showErrorSnackbar(context, message);
        },
      ),
    );
  }
}

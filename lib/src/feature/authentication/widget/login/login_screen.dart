import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/octopus.dart';
import 'package:stylish/src/core/constant/custom_icons.dart';
import 'package:stylish/src/core/router/routes.dart';
import 'package:stylish/src/core/theme/theme.dart';
import 'package:stylish/src/core/util/validation_util.dart';
import 'package:stylish/src/core/util/widget_util.dart';
import 'package:stylish/src/core/widget/scaffold.dart';
import 'package:stylish/src/feature/authentication/bloc/authentication_bloc.dart';

@immutable
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _obscureNotifier = ValueNotifier<bool>(true);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _obscureNotifier.dispose();
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
                'Welcome Back!',
                textAlign: TextAlign.start,
                style: theme.customTextTheme.display.copyWith(color: theme.appTheme.title),
              ),
            ),
            const SizedBox(height: 36),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(hintText: 'Email', prefixIcon: Icon(CustomIcons.user, size: 16)),
            ),
            const SizedBox(height: 31),
            ValueListenableBuilder<bool>(
              valueListenable: _obscureNotifier,
              builder: (context, obscure, child) => TextField(
                controller: _passwordController,
                obscureText: obscure,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: const Icon(CustomIcons.lock, size: 16),
                  suffixIcon: IconButton(
                    onPressed: () => _obscureNotifier.value = !obscure,
                    icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, size: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 31),
            BlocSelector<AuthenticationBloc, AuthenticationState, bool>(
              selector: (state) => state.requestStatus.isIdle || state.requestStatus.isError,
              builder: (context, isReady) => ElevatedButton(
                key: ValueKey('LoginButton-$isReady'),
                onPressed: isReady ? () => _login(context) : null,
                child: const Text('Login', maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text.rich(
                TextSpan(
                  text: 'Create An Account ',
                  style: theme.customTextTheme.body,
                  children: [
                    TextSpan(
                      text: 'Sign Up',
                      recognizer: TapGestureRecognizer()..onTap = () => context.octopus.push(Routes.signUp),
                      style: theme.customTextTheme.body.copyWith(
                        color: theme.primaryColor,
                        decoration: TextDecoration.underline,
                        decorationColor: theme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login(final BuildContext context) async {
    final email = _emailController.text.trim();
    final emailError = ValidationUtil.email(email);
    if (emailError != null) return WidgetUtil.showErrorSnackbar(context, emailError);

    final password = _passwordController.text.trim();
    final passwordError = ValidationUtil.password(password);
    if (passwordError != null) return WidgetUtil.showErrorSnackbar(context, passwordError);

    context.read<AuthenticationBloc>().add(
      AuthenticationLoginEvent(
        email: email,
        password: password,
        onError: (final message) {
          if (!context.mounted) return;
          WidgetUtil.showErrorSnackbar(context, message);
        },
      ),
    );
  }
}

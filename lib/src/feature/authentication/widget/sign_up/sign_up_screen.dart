import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:octopus/octopus.dart';
import 'package:stylish/src/core/constant/custom_icons.dart';
import 'package:stylish/src/core/router/routes.dart';
import 'package:stylish/src/core/theme/theme.dart';
import 'package:stylish/src/core/util/validation_util.dart';
import 'package:stylish/src/core/util/widget_util.dart';
import 'package:stylish/src/core/widget/scaffold.dart';
import 'package:stylish/src/feature/authentication/bloc/authentication_bloc.dart';

@immutable
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _obscureNotifier = ValueNotifier<bool>(true);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                'Create an account',
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
            ValueListenableBuilder<bool>(
              valueListenable: _obscureNotifier,
              builder: (context, obscure, child) => TextField(
                controller: _confirmPasswordController,
                obscureText: obscure,
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
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
                key: ValueKey('SignUpButton-$isReady'),
                onPressed: isReady ? () => _signUp(context) : null,
                child: const Text('Create Account', maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text.rich(
                TextSpan(
                  text: 'I Already Have an Account ',
                  style: GoogleFonts.poppins(textStyle: theme.customTextTheme.body),
                  children: [
                    TextSpan(
                      text: 'Login',
                      recognizer: TapGestureRecognizer()..onTap = () => context.octopus.push(Routes.login),
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

  Future<void> _signUp(final BuildContext context) async {
    final email = _emailController.text.trim();
    final emailError = ValidationUtil.email(email);
    if (emailError != null) return WidgetUtil.showErrorSnackbar(context, emailError);

    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    if (password != confirmPassword) return WidgetUtil.showErrorSnackbar(context, 'The passwords are not the same');
    final passwordError = ValidationUtil.password(password);
    if (passwordError != null) return WidgetUtil.showErrorSnackbar(context, passwordError);

    context.read<AuthenticationBloc>().add(
      AuthenticationSignUpEvent(
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

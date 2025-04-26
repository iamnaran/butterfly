import 'package:butterfly/navigation/routes.dart';
import 'package:butterfly/theme/widgets/text/app_text.dart';
import 'package:butterfly/ui/auth/bloc/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:butterfly/theme/widgets/fields/app_password_field.dart';
import 'package:butterfly/theme/widgets/buttons/app_primary_button.dart';
import 'package:butterfly/theme/widgets/fields/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  void _requestLogin() {
    _emailCtrl.text = 'emilys';
    _passwordCtrl.text = 'emilyspass';
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      context
          .read<LoginBloc>()
          .add(LoginRequested(username: email, password: password));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill any username and password")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              child: BlocConsumer<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is LoginFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  } else if (state is LoginSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Login Successful")),
                    );
                    GoRouter.of(context).goNamed(Routes.exploreRouteName);
                  }
                },
                builder: (context, state) {
                  final bool isLoading = state is LoginLoading;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppText(
                        text: 'Welcome Back 👋',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      AppTextField(
                        label: 'Email',
                        icon: Icons.email,
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter email'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      PasswordTextField(
                        controller: _passwordCtrl,
                        validator: (value) => value == null || value.length < 6
                            ? 'Minimum 6 chars'
                            : null,
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        label: 'Login',
                        isLoading: isLoading,
                        onPressed: () {
                          _requestLogin();
                        },
                      ),
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: () {},
                        child: const Text("Forgot password?"),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

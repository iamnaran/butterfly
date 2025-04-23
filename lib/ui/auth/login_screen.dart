import 'package:butterfly/core/di/service_locater.dart';
import 'package:butterfly/ui/auth/bloc/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:butterfly/ui/widgets/app_password_field.dart';
import 'package:butterfly/ui/widgets/app_primary_button.dart';
import 'package:butterfly/ui/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginBloc>(), // Inject LoginBloc via getIt
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                child: BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is LoginFailure) {
                      // Show error message
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.error)));
                    } else if (state is LoginSuccess) {
                      // Navigate to home or show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Login Successful")));
                    }
                  },
                  builder: (context, state) {
                    final bool isLoading = state is LoginLoading;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Welcome Back 👋',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
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
                          validator: (value) =>
                              value == null || value.length < 6
                                  ? 'Minimum 6 chars'
                                  : null,
                        ),
                        const SizedBox(height: 24),
                        PrimaryButton(
                          label: 'Login',
                          isLoading:
                              isLoading, // Show loading spinner if state is LoginLoading
                          onPressed: () {
                            final email = 'emilys';
                            final password = 'emilyspass';
                            context.read<LoginBloc>().add(LoginRequested(
                                username: email, password: password));
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
      ),
    );
  }
}

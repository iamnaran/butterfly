import 'package:butterfly/navigation/routes.dart';
import 'package:butterfly/ui/auth/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:butterfly/theme/widgets/text/app_text.dart';
import 'package:butterfly/theme/widgets/fields/app_text_field.dart';
import 'package:butterfly/theme/widgets/fields/app_password_field.dart';
import 'package:butterfly/theme/widgets/buttons/app_primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _requestLogin() {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();

    context.read<LoginBloc>().add(
          LoginRequested(username: email, password: password),
    );
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _loginListener(BuildContext context, LoginState state) {
    if (state is LoginFailure) {
      _showSnack(context, state.error);
    } else if (state is LoginSuccess) {
      _showSnack(context, "Login Successful");
      GoRouter.of(context).goNamed(Routes.exploreRouteName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: _loginListener,
          builder: (context, state) {
            final isLoading = state is LoginLoading;
            return _buildLoginForm(context, isLoading);
          },
        ),
      ),
    );
  }


  Widget _buildLoginForm(BuildContext context, bool isLoading) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTitle(context),
              const SizedBox(height: 32),
              _buildEmailField(),
              const SizedBox(height: 16),
              _buildPasswordField(),
              const SizedBox(height: 24),
              _buildLoginButton(isLoading),
              const SizedBox(height: 24),
              _buildForgotPasswordButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return AppText(
      text: 'Welcome Back 👋',
      style: Theme.of(context).textTheme.headlineSmall,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildEmailField() {
    return AppTextField(
      label: 'Email',
      icon: Icons.email,
      controller: _emailCtrl,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => value == null || value.isEmpty ? 'Enter email' : null,
    );
  }

  Widget _buildPasswordField() {
    return PasswordTextField(
      controller: _passwordCtrl,
      validator: (value) =>
          value == null || value.length < 6 ? 'Minimum 6 chars' : null,
    );
  }

  Widget _buildLoginButton(bool isLoading) {
    return PrimaryButton(
      label: 'Login',
      isLoading: isLoading,
      onPressed: _requestLogin,
    );
  }

  Widget _buildForgotPasswordButton() {
    return TextButton(
      onPressed: () {
        // TODO: Implement forgot password
      },
      child: const Text("Forgot password?"),
    );
  }
}

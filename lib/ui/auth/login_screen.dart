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

  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isLoading = false;
  
  void _login() async {
      if (!_formKey.currentState!.validate()) return;

      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2)); // simulate API call

      debugPrint("Login with email: ${_emailCtrl.text}");

      // After login success or fail
      setState(() => _isLoading = false);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
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
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter email' : null,
                  ),
                  const SizedBox(height: 16),
                  PasswordTextField(
                    controller: _passwordCtrl,
                    validator: (value) =>
                        value == null || value.length < 6 ? 'Minimum 6 chars' : null,
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: 'Login',
                    isLoading: _isLoading,
                    onPressed: _login,
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {},
                    child: const Text("Forgot password?"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
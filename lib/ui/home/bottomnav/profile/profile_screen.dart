import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.green.shade100, // Apply background color here
      child: Center(
        child: Text(
          'Profile Widget Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
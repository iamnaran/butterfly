import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.blue.shade100, // Apply background color here
      child: Center(
        child: Text(
          'Explore Widget Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
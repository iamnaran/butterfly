import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.orange.shade100, // Apply background color here
      child: Center(
        child: Text(
          'Search Widget Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

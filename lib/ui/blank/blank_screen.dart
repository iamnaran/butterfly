import 'package:flutter/material.dart';

class BlankScreen extends StatefulWidget {
  const BlankScreen({super.key});

  @override
  State<BlankScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<BlankScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
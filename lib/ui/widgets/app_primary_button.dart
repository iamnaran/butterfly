import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

 @override
Widget build(BuildContext context) {
  return ElevatedButton(
    onPressed: isLoading ? null : onPressed,

    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue, 
      foregroundColor: Colors.white,
      disabledBackgroundColor: Colors.grey.shade300, 
      disabledForegroundColor: Colors.grey,        
    ),

    child: isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          )
        : Text(label),
  );
}
}
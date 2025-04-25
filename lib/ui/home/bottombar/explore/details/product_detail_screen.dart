import 'package:butterfly/theme/widgets/text/app_text.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const AppText(text:'Product Detail')),
      body: Center(
        child: Text('Product ID: $productId'),
      ),
    );
  }
}
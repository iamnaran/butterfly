import 'package:butterfly/theme/widgets/text/app_text.dart';
import 'package:butterfly/ui/home/bottombar/explore/details/bloc/product_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    context
        .read<ProductDetailBloc>()
        .add(FetchProductDetail(productId: widget.productId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const AppText(text: 'Product Detail')),
      body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildProductDetails(context, state),
          );
        },
      ),
    );
  }

  Widget _buildProductTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AppText(
        text: title,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildProductDescription(BuildContext context, String description) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AppText(
        text: description,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildProductPrice(BuildContext context, double price) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AppText(
        text: '\$${price.toStringAsFixed(2)}',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildProductDetails(BuildContext context, ProductDetailState state) {
    if (state is ProductDetailLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is ProductDetailLoaded) {
      final product = state.product;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductTitle(context, product.title),
          _buildProductDescription(context, product.description),
          _buildProductPrice(context, product.price),
        ],
      );
    } else {
      return const Center(child: Text('Unknown state'));
    }
  }
}

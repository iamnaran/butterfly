import 'package:butterfly/data/local/database/entity/explore/product_entity.dart';
import 'package:butterfly/navigation/routes.dart';
import 'package:butterfly/theme/widgets/text/app_text.dart';
import 'package:butterfly/ui/home/bottombar/explore/bloc/explore_bloc.dart';
import 'package:butterfly/ui/home/bottombar/explore/components/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  void _navigateToProductDetail(BuildContext context, String productId) {
    context.pushNamed(
      Routes.productDetailRouteName,
      pathParameters: {'productId': productId},
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<ExploreBloc>().add(const FetchProductList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(text: 'Explore'),
      ),
      body: BlocBuilder<ExploreBloc, ExploreState>(
        builder: (context, state) {
          if (state is ProductListLoading) {
            return _buildLoading(state.previousProducts);
          } else if (state is ProductListLoaded) {
            return _buildProductList(state.products);
          } else if (state is ProductListError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }

  Widget _buildLoading(List<ProductEntity>? previousProducts) {
    if (previousProducts != null) {
      return Stack(
        children: [
          _buildProductList(previousProducts),
          const Center(child: CircularProgressIndicator()),
        ],
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildProductList(List<ProductEntity> products) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductListItem(
          key: ValueKey(product.id),
          product: product,
          onProductTap: (productId) =>
              _navigateToProductDetail(context, productId),
        );
      },
      cacheExtent: 1000.0,
    );
  }
}

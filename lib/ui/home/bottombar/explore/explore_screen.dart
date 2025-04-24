import 'package:butterfly/core/database/entity/explore/product_entity.dart';
import 'package:butterfly/ui/home/bottombar/explore/bloc/explore_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {

  @override
  void initState() {
    super.initState();
    context.read<ExploreBloc>().add(const FetchProductList());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExploreBloc, ExploreState>(
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
    );
  }


  Widget _buildLoading(List<ProductEntity>? previousProducts) {
    if (previousProducts != null) {
      return Stack(
        children: [
          _buildProductList(previousProducts),
          const Opacity(
            opacity: 0.7,
            child: ModalBarrier(dismissible: false, color: Colors.grey),
          ),
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
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.1 * 255).toInt()),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
                child: CachedNetworkImage(
                  imageUrl: 'https://fastly.picsum.photos/id/919/536/354.jpg?hmac=NQVTG38LLhSmuQu5ztuZ846sqRtDy4nzwI-1C457j-o',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => const SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Center(child: Icon(Icons.error)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (product.category != null && product.category!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          product.category!,
                          style: const TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                      ),
                    const SizedBox(height: 8.0),
                    Text(
                      product.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Price: \$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16, color: Colors.green),
                    ),
                    if (product.description != null && product.description!.isNotEmpty)
                      Text(
                        product.description!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}

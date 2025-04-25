import 'package:butterfly/core/database/entity/explore/product_entity.dart';
import 'package:butterfly/theme/widgets/text/app_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductListItem extends StatelessWidget {
  final ProductEntity product;

  final void Function(String productId)? onProductTap;

  const ProductListItem({super.key, required this.product, this.onProductTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onProductTap?.call(product.id.toString());
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Theme.of(context).colorScheme.secondaryContainer,
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
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12.0)),
              child: CachedNetworkImage(
                imageUrl:
                    'https://fastly.picsum.photos/id/919/536/354.jpg?hmac=NQVTG38LLhSmuQu5ztuZ846sqRtDy4nzwI-1C457j-o',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                // Optimization: Consider a simpler placeholder for faster initial paint
                placeholder: (context, url) => const SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Center(child: CircularProgressIndicator()),
                ),
                // Optimization: Ensure error widget is lightweight
                errorWidget: (context, url, error) => const SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Center(child: Icon(Icons.error)),
                ),
                // Optimization: If known, set maxHeight and maxWidth
                // maxHeight: 200,
                // maxWidth: MediaQuery.of(context).size.width,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.category.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: AppText(
                        text: product.category,
                        style: Theme.of(context).textTheme.bodySmall,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  const SizedBox(height: 8.0),
                  AppText(
                    text: product.title,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8.0),
                  if (product.description.isNotEmpty)
                    AppText(
                      text: product.description,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

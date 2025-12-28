import 'package:butterfly/data/local/database/entity/post/post_entity.dart';
import 'package:butterfly/theme/widgets/text/app_text.dart';
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: post.title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            AppText(
              text: post.body,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),

            /// Tags
            // if (post.tags.isNotEmpty)
            //   Wrap(
            //     spacing: 6,
            //     runSpacing: 4,
            //     children: post.tags
            //         .map((tag) => Chip(
            //               label: Text(tag, style: Theme.of(context).textTheme.labelSmall),
            //               visualDensity: VisualDensity.compact,
            //               padding: const EdgeInsets.symmetric(horizontal: 6),
            //             ))
            //         .toList(),
            //   ),

            const SizedBox(height: 12),

            /// Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.visibility, size: 18),
                const SizedBox(width: 4),
                Text(post.views.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

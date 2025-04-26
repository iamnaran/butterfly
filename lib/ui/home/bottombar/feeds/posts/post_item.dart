import 'package:butterfly/core/database/entity/post/post_entity.dart';
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
      color: Theme.of(context).colorScheme.surface,
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  spacing: 6,
                  children: post.tags.map((tag) => Chip(label: Text(tag))).toList(),
                ),
                Row(
                  children: [
                    Icon(Icons.thumb_up, size: 18, color: Colors.green),
                    const SizedBox(width: 4),
                    const SizedBox(width: 12),
                    Icon(Icons.visibility, size: 18),
                    const SizedBox(width: 4),
                    Text(post.views.toString()),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
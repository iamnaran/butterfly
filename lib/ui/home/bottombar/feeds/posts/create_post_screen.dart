import 'package:butterfly/data/local/database/entity/post/post_entity.dart';
import 'package:butterfly/utils/app_utils.dart';
import 'package:flutter/material.dart';

class CreatePostScreen extends StatefulWidget {

  final Function(PostEntity postEntity) onCreatePost;

  const CreatePostScreen({super.key, required this.onCreatePost});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {


  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _createPost() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isNotEmpty && content.isNotEmpty) {
      final post = PostEntity(
        id: AppUtils.getRandomInt(),
        title: title,
        body: content,
        tags: ['bloc','flutter','auto updated local'],
        views: 0,
        userId: 1,
      );
      widget.onCreatePost(post);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Create Post',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Post Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _contentController,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Post Content',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _createPost,
            child: const Text('Create Post'),
          ),
        ],
      ),
    );
  }
}

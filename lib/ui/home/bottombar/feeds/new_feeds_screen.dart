import 'package:butterfly/core/database/entity/post/post_entity.dart';
import 'package:butterfly/theme/widgets/text/app_text.dart';
import 'package:butterfly/ui/home/bottombar/feeds/bloc/post_bloc.dart';
import 'package:butterfly/ui/home/bottombar/feeds/posts/create_post_screen.dart';
import 'package:butterfly/ui/home/bottombar/feeds/posts/post_item.dart';
import 'package:butterfly/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewFeedsScreen extends StatefulWidget {
  const NewFeedsScreen({super.key});

  @override
  State<NewFeedsScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<NewFeedsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(FetchPosts());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ignore: unused_element
  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  void _handleCreatePost(PostEntity post) {
    context.read<PostBloc>().add(
          CreatePost(
            post: post,
            onPostCreated: (_) {
              AppLogger.showError("Created post via callback: $post");
              Navigator.of(context).pop();
            },
          ),
        );
  }

  void _showCreatePostBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return CreatePostScreen(
            onCreatePost: _handleCreatePost); // Pass the callback
      },
    ).then((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const AppText(text: 'Posts')),
      body: BlocListener<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostCreating) {
            // Show a "Creating your post..." message with post values for creating
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Creating your post:")),
            );
          } else if (state is PostCreated) {
            // Show a success message when the post is created
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Your post has been created!")),
            );
            
          } else if (state is PostCreatingError) {
            // Show error message if any
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<PostBloc, PostState>(
          buildWhen: (previous, current) {
            return current is PostLoading ||
                current is PostLoaded ||
                current is PostInitial ||
                current is PostError;
          },
          builder: (context, state) {
            if (state is PostLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PostLoaded) {
              final posts = state.posts;

              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return PostCard(post: post);
                },
              );
            } else if (state is PostInitial) {
              return const Center(
                child: AppText(text: "Loading.. Please wait"),
              );
            } else if (state is PostError) {
              return Center(
                child: AppText(
                  text: 'Error: ${state.message}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            } else {
              return const SizedBox(
                child: AppText(text: "Error"),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePostBottomSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Posts')),
//       body: BlocBuilder<PostBloc, PostState>(
//         builder: (context, state) {
//           if (state is PostLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is PostLoaded) {
//             final posts = state.posts;
//             return ListView.builder(
//               padding: const EdgeInsets.all(8),
//               itemCount: posts.length,
//               itemBuilder: (context, index) {
//                 final post = posts[index];
//                 return PostCard(post: post);
//               },
//             );
//           } else if (state is PostError) {
//             return Center(child: Text('Error: ${state.message}'));
//           } else {
//             return const SizedBox(); // initial empty state
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showCreatePostBottomSheet(context),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

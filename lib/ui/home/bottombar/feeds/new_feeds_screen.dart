import 'package:butterfly/core/database/entity/post/post_entity.dart';
import 'package:butterfly/ui/home/bottombar/feeds/bloc/post_bloc.dart';
import 'package:butterfly/ui/home/bottombar/feeds/posts/post_item.dart';
import 'package:butterfly/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewFeedsScreen extends StatefulWidget {
  const NewFeedsScreen({super.key});

  @override
  State<NewFeedsScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<NewFeedsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(FetchPosts());
  }

  // void _showCreatePostBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (context) {
  //       return CreatePostScreen();
  //     },
  //   ).then((_) {

  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
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
                current is PostError;
           },
          builder: (context, state) {
            if (state is PostLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PostLoaded) {
              final posts = state.posts;
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return PostCard(
                    key: ValueKey(post.id),
                    post: post);
                },
              );
            } else if (state is PostCreating) {
              // Optionally show some UI for creating
              return const Center(child: CircularProgressIndicator());
            } else {
              return const SizedBox(); // Empty state if no data
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newPost = PostEntity(
            id: AppUtils.getRandomInt(),
            title: 'New Post',
            body: 'This is a new post body.',
            tags: ['flutter', 'bloc'],
            reactions: ReactionHiveModel(likes: 0, dislikes: 0),
            views: 0,
            userId: 1,
          );
          context.read<PostBloc>().add(CreatePost(
                post: newPost,
                onPostCreated: (PostEntity createdPost) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            "Post '${createdPost.title}' created successfully!")),
                  );
                },
              ));
        },
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

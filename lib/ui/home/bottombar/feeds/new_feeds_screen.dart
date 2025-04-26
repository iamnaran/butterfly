import 'package:butterfly/ui/home/bottombar/feeds/bloc/post_bloc.dart';
import 'package:butterfly/ui/home/bottombar/feeds/posts/post_item.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: BlocBuilder<PostBloc, PostState>(
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
                return PostCard(post: post);
              },
            );
          } else if (state is PostError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const SizedBox(); // initial empty state
          }
        },
      ),
    );
  }
}

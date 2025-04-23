import 'package:butterfly/navigation/routes.dart';
import 'package:butterfly/ui/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

 @override
Widget build(BuildContext context) {
  return BlocListener<HomeBloc, HomeState>(
    listenWhen: (previous, current) => current is LogoutSuccess,
    listener: (context, state) {
      context.go(Routes.login); 
    },
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<HomeBloc>().add(LogoutUser());
            },
          ),
        ],
      ),
      body: const Center(
        child: Text("Welcome to Home!"),
      ),
    ),
  );
}
}
import 'package:butterfly/core/database/entity/user/user_entity.dart';
import 'package:butterfly/ui/home/bottombar/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCard extends StatelessWidget {
  final UserEntity user;

  const ProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.image),
            ),
            const SizedBox(height: 16.0),
            Text(
              '${user.firstName} ${user.lastName}',
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            Text(user.email, style: const TextStyle(fontSize: 16.0)),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Dispatch the logout event when the button is pressed
                context.read<ProfileBloc>().add(LogoutEvent());
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
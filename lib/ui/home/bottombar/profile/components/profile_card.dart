import 'package:butterfly/core/database/entity/user/user_entity.dart';
import 'package:butterfly/theme/widgets/text/app_text.dart';
import 'package:butterfly/ui/home/bottombar/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCard extends StatelessWidget {
  final UserEntity user;

  const ProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 0.0,
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(user.image),
                ),
                const SizedBox(height: 16.0),
                AppText(
                  text: '${user.firstName} ${user.lastName}',
                  style: Theme.of(context).textTheme.bodyMedium,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 8.0),
                AppText(
                    text: user.email,
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    // Dispatch the logout event when the button is pressed
                    context.read<ProfileBloc>().add(LogoutEvent());
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 12.0,
                    ),
                  ),
                  child: AppText(text: 'Logout'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

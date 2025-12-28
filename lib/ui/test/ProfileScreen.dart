// create stateless widget ProfileScreen
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String name;
  final String email;

  const ProfileWidget({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {

    // return empty container
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
         
        ],
      ),
    );
  }


  Widget buildProfileHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage('assets/images/profile.png'),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(email, style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ],
    );

  }


}

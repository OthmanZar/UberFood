import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const routeName = "/profileScreen";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'Name: John Doe',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 16.0),
          Text(
            'Email: john.doe@example.com',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 32.0),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement logout functionality
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}

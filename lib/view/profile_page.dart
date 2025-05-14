import 'package:flutter/material.dart';
import 'widgets/custom_app_bar.dart';
import '../controller/session_controller.dart';
import 'dart:math' as Math;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final SessionController _sessionController = SessionController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'Profile', notShowAvatar: true),
        body: Center(
          child: FutureBuilder<String>(
            future: _sessionController.getUsername(),
            builder: (context, snapshot) {
              final username = snapshot.data ?? 'User';
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue.shade800,
                    child: Text(
                      username
                          .substring(0, Math.min(2, username.length))
                          .toUpperCase(),
                      style: TextStyle(
                        fontSize: 36,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Welcome, $username!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () => _sessionController.logout(context),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                    ),
                    child: Text('Logout'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

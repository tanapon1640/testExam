import 'package:flutter/material.dart';
import 'package:projectofsgn/view/main_page.dart';
import 'view/login_page.dart';
import 'controller/session_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sessionController = SessionController();
  final isLoggedIn = await sessionController.isSessionActive();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: isLoggedIn ? MainPage() : LoginPage(),
    );
  }
}

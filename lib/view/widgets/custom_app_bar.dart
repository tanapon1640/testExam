import 'package:flutter/material.dart';
import '../../controller/session_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? additionalActions;
  final bool notShowAvatar;
  const CustomAppBar({
    super.key,
    required this.title,
    this.additionalActions,
    this.notShowAvatar = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue.shade800,
      iconTheme: IconThemeData(color: Colors.white),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
      toolbarHeight: 80,
      actions: [
        ...(additionalActions ?? []),
        if (!notShowAvatar)
          FutureBuilder<String>(
            future: SessionController().getUserInitials(),
            builder: (context, snapshot) {
              final initials = snapshot.data ?? 'US';
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blue.shade500,
                  child: Text(
                    initials,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

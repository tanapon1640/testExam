import 'package:flutter/material.dart';
import 'home_page.dart';
import 'status_page.dart';
import 'profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [HomePage(), StatusPage(), ProfilePage()];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1, color: Colors.grey.shade300),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.grey.shade100,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey.shade600,
          selectedLabelStyle: TextStyle(color: Colors.blue, fontSize: 14),
          unselectedLabelStyle: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
          selectedFontSize: 14,
          unselectedFontSize: 14,
          items: [
            _buildNavItem(label: 'Home', index: 0),
            _buildNavItem(label: 'Status', index: 1),
            _buildNavItem(label: 'Profile', index: 2),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required String label,
    required int index,
  }) {
    bool isSelected = _selectedIndex == index;

    return BottomNavigationBarItem(
      icon: Column(
        children: [
          isSelected
              ? Container(
                margin: EdgeInsets.only(top: 3, bottom: 8),
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              )
              : Container(
                margin: EdgeInsets.only(top: 3, bottom: 8),
                height: 10,
                width: 10,
              ),
        ],
      ),
      label: label,
    );
  }
}

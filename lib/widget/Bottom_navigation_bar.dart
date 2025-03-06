import 'package:flutter/material.dart';
import 'package:graduate/view/Classification_page.dart';
import 'package:graduate/view/History_page.dart';
import 'package:graduate/view/Home_page.dart';
import 'package:graduate/view/Setting_page.dart';
import 'package:graduate/widget/app_color.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0; // Chỉ mục tab đang chọn

  // Danh sách các màn hình/tab
  final List<Widget> _screens = [
    HomePage(),
    ClassificationPage(),
    HistoryPage(),
    SettingPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Hiển thị màn hình tương ứng
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Classification'),
          BottomNavigationBarItem(icon: Icon(Icons.access_time_outlined), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.settings),label: 'Setting')
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
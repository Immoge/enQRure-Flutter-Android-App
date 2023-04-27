import 'package:flutter/material.dart';
import 'package:brand_qr_scanner/views/registerproductscreen.dart';
import 'package:brand_qr_scanner/views/profilescreen.dart';
import '../models/user.dart';
import 'homescreen.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Profile";

  @override
  void initState() {
    super.initState();
    tabchildren = [
      HomeScreen(),
      RegisterProductScreen(),
      ProfileScreen(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.house_rounded,
              ),
              label: "Main"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.qr_code_scanner,
              ),
              label: "Scan"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: "Profile"),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        maintitle = "Main";
      }
      if (_currentIndex == 1) {
        maintitle = "Scan";
      }
      if (_currentIndex == 2) {
        maintitle = "Profile";
      }
    });
  }
}

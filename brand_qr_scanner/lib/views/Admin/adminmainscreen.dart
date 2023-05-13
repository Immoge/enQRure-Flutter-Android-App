import 'package:enQRsure/views/Admin/adminaddaccountscreen.dart';
import 'package:enQRsure/views/Admin/adminprofilescreen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:enQRsure/views/registerproductscreen.dart';
import 'package:enQRsure/views/profilescreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../loginscreen.dart';
import '../../models/user.dart';
import 'adminhomescreen.dart';

class AdminMainScreen extends StatefulWidget {
  final User user;
  const AdminMainScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Profile";

  @override
  void initState() {
    super.initState();
    tabchildren = [
      const AdminHomeScreen(),
       AdminAddAccountScreen(user: widget.user),
       AdminProfileScreen(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabchildren[_currentIndex],
      bottomNavigationBar: 
        CurvedNavigationBar(
          backgroundColor: Colors.white,
          color: Color(0xFFFF9EC9),
          animationDuration: Duration(milliseconds: 300),
          onTap: onTabTapped,
          index: _currentIndex,
          items: const [
            Icon(
              Icons.house_rounded,
              color: Colors.white,
              size: 35,
            ),
            Icon(
              Icons.add,
              color: Colors.white,
              size:35,
            ),
            Icon(
              Icons.person,
              color: Colors.white,
              size:35,
            ),
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
        maintitle = "Add Account";
      }
      if (_currentIndex == 2) {
        maintitle = "Profile";
      }
    });
  }
}
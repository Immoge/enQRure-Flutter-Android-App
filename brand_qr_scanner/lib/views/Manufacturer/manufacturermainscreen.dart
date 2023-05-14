import 'package:enQRsure/views/Admin/adminaddaccountscreen.dart';
import 'package:enQRsure/views/Manufacturer/manufacturerhomescreen.dart';
import 'package:enQRsure/views/Manufacturer/manufacturerregisterproductscreen.dart';
import 'package:enQRsure/views/Manufacturer/manufacturerreportscreen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:enQRsure/views/Buyer/buyerregisterproductscreen.dart';
import 'package:enQRsure/views/profilescreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../loginscreen.dart';
import 'package:enQRsure/models/user.dart';
import 'manufacturerprofilescreen.dart';

class ManufacturerMainScreen extends StatefulWidget {
  final User user;
  const ManufacturerMainScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ManufacturerMainScreen> createState() => _ManufacturerMainScreenState();
}

class _ManufacturerMainScreenState extends State<ManufacturerMainScreen> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Profile";

  @override
  void initState() {
    super.initState();
    tabchildren = [
      ManufacturerHomeScreen(user: widget.user),
       ManufacturerRegisterProductScreen(user: widget.user),
       ManufacturerReportScreen(user: widget.user),
      ManufacturerProfileScreen(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabchildren[_currentIndex],
      bottomNavigationBar: 
        CurvedNavigationBar(
          backgroundColor: Colors.white,
          color: Color(0xFF90E6C3),
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
              Icons.qr_code_scanner_rounded,
              color: Colors.white,
              size:35,
            ),
             Icon(
              Icons.insert_drive_file_outlined,
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
        maintitle = "Register Product";
      }
       if (_currentIndex == 2) {
        maintitle = "Report";
      }
      if (_currentIndex == 3) {
        maintitle = "Profile";
      }
    });
  }
}
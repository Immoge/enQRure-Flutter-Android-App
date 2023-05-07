
import 'package:brand_qr_scanner/views/Manufacturer/manufacturerregisterproductscreen.dart';
import 'package:brand_qr_scanner/views/Retailer/retailerreportscreen.dart';
import 'package:brand_qr_scanner/views/Retailer/retailerprofilescreen.dart';
import 'package:brand_qr_scanner/views/Retailer/retailerregisterproductscreen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart';

class RetailerMainScreen extends StatefulWidget {
  final User user;
  const RetailerMainScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<RetailerMainScreen> createState() => _RetailerMainScreenState();
}

class _RetailerMainScreenState extends State<RetailerMainScreen> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Profile";

  @override
  void initState() {
    super.initState();
    tabchildren = [
      const RetailerReportScreen(),
      const RetailerRegisterProductScreen(),
      RetailerProfileScreen(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabchildren[_currentIndex],
      bottomNavigationBar: 
        CurvedNavigationBar(
          backgroundColor: Colors.white,
          color: Color(0xFFFFB747),
          animationDuration: Duration(milliseconds: 300),
          onTap: onTabTapped,
          index: _currentIndex,
          items: const [
            Icon(
              Icons.insert_drive_file_outlined,
              color: Colors.white,
              size: 35,
            ),
            Icon(
              Icons.qr_code_scanner_rounded,
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
        maintitle = "Report";
      }
      if (_currentIndex == 1) {
        maintitle = "Register Product";
      }
      if (_currentIndex == 3) {
        maintitle = "Profile";
      }
    });
  }
}
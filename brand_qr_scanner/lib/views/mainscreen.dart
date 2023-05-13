import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:enQRsure/views/registerproductscreen.dart';
import 'package:enQRsure/views/profilescreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/user.dart';
import 'Buyer/buyerhistoryscreen.dart';
import 'Buyer/buyerprofilescreen.dart';
import 'Buyer/buyerhomescreen.dart';
import 'loginscreen.dart';

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
       BuyerHomeScreen(user: widget.user),
      const RegisterProductScreen(),
      const BuyerHistoryScreen(),
      BuyerProfileScreen(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabchildren[_currentIndex],
      bottomNavigationBar: 
        CurvedNavigationBar(
          backgroundColor: Colors.white,
          color: Color(0xFF54B5FF),
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
              Icons.qr_code_scanner,
              color: Colors.white,
              size:35,
            ),
            Icon(
              Icons.history,
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
    if (widget.user.id == "0" && (index == 2 || index == 3)) {
      Fluttertoast.showToast(msg: "Please login first");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    } else {
      setState(() {
        _currentIndex = index;
        switch (_currentIndex) {
          case 0:
            maintitle = "Home";
            break;
          case 1:
            maintitle = "Register Product";
            break;
          case 2:
            maintitle = "History";
            break;
          case 3:
            maintitle = "Profile";
            break;
        }
      });
    }
  }
}
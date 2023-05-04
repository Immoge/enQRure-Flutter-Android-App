import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RetailerReportScreen extends StatefulWidget {
  const RetailerReportScreen({super.key});

  @override
  State<RetailerReportScreen> createState() => _RetailerReportScreenState();
}

class _RetailerReportScreenState extends State<RetailerReportScreen> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFFFD400),
        title: Text("Retailer",
        textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
                fontSize: 25, 
                fontWeight: FontWeight.w500,)),
            ));
  }
}

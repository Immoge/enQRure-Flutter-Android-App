import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManufacturerReportScreen extends StatefulWidget {
  const ManufacturerReportScreen({super.key});

  @override
  State<ManufacturerReportScreen> createState() => _ManufacturerReportScreenState();
}

class _ManufacturerReportScreenState extends State<ManufacturerReportScreen> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF90E6C3),
        title: Text("Manufacturer Report",
        textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
                fontSize: 25, 
                fontWeight: FontWeight.w500,)),
            ));
  }
}

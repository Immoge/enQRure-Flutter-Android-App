import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManufacturerHomeScreen extends StatefulWidget {
  const ManufacturerHomeScreen({super.key});

  @override
  State<ManufacturerHomeScreen> createState() => _ManufacturerHomeScreenState();
}

class _ManufacturerHomeScreenState extends State<ManufacturerHomeScreen> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF90E6C3),
        title: Text("Manufacturer",
        textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
                fontSize: 25, 
                fontWeight: FontWeight.w500,)),
            ));
  }
}

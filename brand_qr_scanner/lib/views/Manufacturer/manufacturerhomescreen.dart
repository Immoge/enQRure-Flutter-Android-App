import 'package:brand_qr_scanner/models/user.dart';
import 'package:brand_qr_scanner/views/Manufacturer/manufacturergenerateqrscreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManufacturerHomeScreen extends StatefulWidget {
  final User user;
  const ManufacturerHomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ManufacturerHomeScreen> createState() => _ManufacturerHomeScreenState();
}

final PageController _pageController = PageController(initialPage: 0);
int _currentPageIndex = 0;
bool _isFirstButtonSelected = true;

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
              fontWeight: FontWeight.w500,
            )),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey.shade400,
            width: 2.0,
          ),
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>  ManufacturerGenerateQRScreen(user: widget.user)));
          },
          child: Icon(Icons.add),
          backgroundColor: Color(0xFF90E6C3),
          foregroundColor: Colors.white,
          elevation: 5,
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
                child: TextButton(
                    style: ElevatedButton.styleFrom(                     
                      backgroundColor: _isFirstButtonSelected
                          ? Color(0xFF888D88)
                          : Color(0xFFCED0CE),
                      side: BorderSide.none,
                    ),
                    child: Text("Recorded Products",
                        style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    onPressed: () async {
                      _selectFirstButton();
                      _pageController.previousPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                    }),
              ),
              SizedBox(
                height: 40,
                child: TextButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFirstButtonSelected
                          ? Color(0xFFCED0CE)
                          : Color(0xFF888D88),
                      side: BorderSide.none,
                    ),
                    child: Text("Registered Products",
                        style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    onPressed: () async {
                      _selectSecondButton();
                      _pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                    }),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              children: [
                Container(
                  color: Colors.white,
                ),
                Container(color: Colors.pink),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _selectFirstButton() {
    setState(() {
      _isFirstButtonSelected = true;
    });
  }

  void _selectSecondButton() {
    setState(() {
      _isFirstButtonSelected = false;
    });
  }
}

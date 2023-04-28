import 'package:brand_qr_scanner/views/homescreen.dart';
import 'package:brand_qr_scanner/views/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/user.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  late PageController _pageController;
  late double screenHeight, screenWidth;
  int _pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                      itemCount: landingScreenData.length,
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _pageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) => OnboardContent(
                            image: landingScreenData[index].image,
                            title: landingScreenData[index].title,
                            description: landingScreenData[index].description,
                          )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...List.generate(
                        landingScreenData.length,
                        (index) => Padding(
                              padding: EdgeInsets.all(8),
                              child:
                                  DotIndicator(isActive: index == _pageIndex),
                            )),
                  ],
                ),
                Row(
                  children: [
                    const Spacer(),
                    SizedBox(
                        height: 60,
                        width: 65,
                        child: ElevatedButton(
                            onPressed: () {
                              _goHome();
                            },
                            style: ElevatedButton.styleFrom(
                                shape: const CircleBorder()),
                            child: const Icon(
                              Icons.arrow_circle_right_outlined,
                              color: Colors.white,
                              size: 35,
                            ))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goHome() {
    User user = User(
      id: "0",
      email: "unregistered",
      name: "unregistered",
      address: "na",
      phone: "0123456789",
      regdate: "0",
    );
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => MainScreen(
                  user: user,
                )));
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    Key? key,
    this.isActive = false,
  }) : super(key: key);

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isActive ? 10 : 4,
      height: isActive ? 10 : 4,
      decoration:  const BoxDecoration(
          color: Colors.grey,
          borderRadius:  BorderRadius.all(Radius.circular(12))),
    );
  }
}

class Onboard {
  final String image, title, description;

  Onboard(
      {required this.image, required this.title, required this.description});
}

final List<Onboard> landingScreenData = [
  Onboard(
      image: "assets/images/landing page images/Landing Page 1.png",
      title: "Secure & Efficient",
      description: "Verifying the genuineness of the product through a secure & simple process."),
  Onboard(
      image: "assets/images/landing page images/Landing Page 2.png",
      title: "Protect Our Right",
      description: "Here you'll will experience a new authentication process and safeguard our right"),
  Onboard(
      image: "assets/images/landing page images/Landing Page 3.png",
      title: "Elimate Counterfeit",
      description: "Safeguarding against counterfeit products is not just a matter of business, but a responsibility towards consumers and society as a whole."),
];

class OnboardContent extends StatelessWidget {
  const OnboardContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  final String image, title, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Image.asset(
          image,
          height: 250,
        ),
        const Spacer(),
        Text(title,
            textAlign: TextAlign.center,
            style: GoogleFonts.concertOne(
                fontSize: 25, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Text(description,
            textAlign: TextAlign.center,
            style: GoogleFonts.oswald(
              fontSize: 20,
            )),
        const Spacer(),
      ],
    );
  }
}

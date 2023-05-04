import 'package:brand_qr_scanner/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/homescreenelement.dart';

class BuyerHomeScreen extends StatefulWidget {
  const BuyerHomeScreen({Key? key, required User user}) : super(key: key);

  @override
  _BuyerHomeScreenState createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends State<BuyerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Newsletters",
                  style: GoogleFonts.montserrat(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...bigNewsletters
                        .map((homeScreenElement) => Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: HomeScreenCard(
                                  homeScreenElement: homeScreenElement),
                            ))
                        .toList(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Recent",
                  style: GoogleFonts.montserrat(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                ),
              ),
              ...recentNewsLetter.map(
                (homeScreenElement) => Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: SecondaryHomeScreenCard(
                      homeScreenElement: homeScreenElement),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondaryHomeScreenCard extends StatelessWidget {
  const SecondaryHomeScreenCard({
    Key? key,
    required this.homeScreenElement,
  }) : super(key: key);

  final HomeScreenElement homeScreenElement;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: homeScreenElement.bgColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  homeScreenElement.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    
                  ),
                ),
                Text(
                  homeScreenElement.description,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w700,
                )),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
            child: VerticalDivider(
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 2),
          Image.asset(
            homeScreenElement.iconSrc,
            height: 50,
          ),
        ],
      ),
    );
  }
}

class HomeScreenCard extends StatelessWidget {
  const HomeScreenCard({
    Key? key,
    required this.homeScreenElement,
  }) : super(key: key);

  final HomeScreenElement homeScreenElement;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      height: 280,
      width: 260,
      decoration: BoxDecoration(
        color: homeScreenElement.bgColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  homeScreenElement.title,
                  style: GoogleFonts.concertOne(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 8),
                  child: Text(
                    homeScreenElement.description,
                    style: GoogleFonts.oswald(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  homeScreenElement.smalldescription,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const Spacer(),
                Row(
                  children: List.generate(
                    3,
                    (index) => Transform.translate(
                      offset: Offset((-10 * index).toDouble(), 0),
                    ),
                  ),
                )
              ],
            ),
          ),
          Image.asset(homeScreenElement.iconSrc, height: 50)
        ],
      ),
    );
  }
}

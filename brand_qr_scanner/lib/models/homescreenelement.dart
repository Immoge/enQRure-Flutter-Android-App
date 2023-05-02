import 'package:flutter/material.dart';

class HomeScreenElement {
  final String title, description, iconSrc, smalldescription;
  final Color bgColor;

  HomeScreenElement({
    required this.title,
    required this.description,
    required this.smalldescription,
    required this.iconSrc,
    required this.bgColor,
  });
}

List<HomeScreenElement> bigNewsletters = [
  HomeScreenElement(
      title: "Apple",
      description: "Buy iPhone 14 and iPhone 14 Plus in yellow now. Starting from RM 4,199. ",
      smalldescription: "Enganged to: 1487 users",
      iconSrc: "assets/images/home screen icon/apple icon.png",
      bgColor: const Color(0xFFBAC5FF)),
  HomeScreenElement(
    title: "Adidas",
    description: "Celebrate the feeling of being outdoors with hiking apparel featuring unique prints.",
    smalldescription: "Enganged to: 2208 users",
    iconSrc: "assets/images/home screen icon/adidas icon.png",
    bgColor: const Color(0xFFBAD3FF),
  ),
  HomeScreenElement(
    title: "Chanel",
    description: "CHANEL is staging a fantastic encounter between the powers of its super fragrances and the everyday heroines for whom they were created.",
    smalldescription: "Enganged to: 2337 users",
    iconSrc: "assets/images/home screen icon/chanel icon.png",
    bgColor: const Color(0xFFBAC5FF),
  ),
];

// We need it later
List<HomeScreenElement> recentNewsLetter = [
  HomeScreenElement(
      title: "Apple",
      description: "New ways to brighten Mom’s day",
      smalldescription: "",
      iconSrc: "assets/images/home screen icon/apple icon.png",
      bgColor: const Color(0xFFBAC5FF)),
  HomeScreenElement(
    title: "Adidas",
    description: "adidas TERREX x ©National Geographic collab",
    smalldescription: "",
    iconSrc: "assets/images/home screen icon/adidas icon.png",
    bgColor: const Color(0xFFBAD3FF),
  ),
  HomeScreenElement(
    title: "Chanel",
    description: "Spring-Summer 2023 Ready-To-Wear",
    smalldescription: "",
    iconSrc: "assets/images/home screen icon/chanel icon.png",
    bgColor: const Color(0xFFBAC5FF),
  ),
  HomeScreenElement(
    title: "YSL",
    description: "Express your gratitude this Mother's Day",
    smalldescription: "",
    iconSrc: "assets/images/home screen icon/ysl icon.png",
    bgColor: const Color(0xFFBAD3FF),
  ),
];

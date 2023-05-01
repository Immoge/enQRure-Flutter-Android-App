import 'package:flutter/material.dart';

class HomeScreenElement {
  final String title, description, iconSrc;
  final Color bgColor;

  HomeScreenElement({
    required this.title,
    required this.description,
    required this.iconSrc,
    required this.bgColor,
  });
}

List<HomeScreenElement> courses = [
  HomeScreenElement(
    title: "Animations in SwiftUI",
    description: "",
    iconSrc: "assets/icons/code.svg",
    bgColor: const Color(0xFF7553F6)),
  HomeScreenElement(
    title: "Animations in Flutter",
    description: "",
    iconSrc: "assets/icons/code.svg",
    bgColor: const Color(0xFF80A4FF),
  ),
];

// We need it later
List<HomeScreenElement> recentNewsLetter = [
  HomeScreenElement(
    title: "Animations in SwiftUI",
    description: "",
    iconSrc: "assets/icons/code.svg",
    bgColor: const Color(0xFF7553F6)),
 HomeScreenElement(
    title: "Animations in Flutter",
    description: "",
    iconSrc: "assets/icons/code.svg",
    bgColor: const Color(0xFF80A4FF),
  ),
  HomeScreenElement(
    title: "Animations in Flutter",
    description: "",
    iconSrc: "assets/icons/code.svg",
    bgColor: const Color(0xFF80A4FF),
  ),
  HomeScreenElement(
    title: "Animations in Flutter",
    description: "",
    iconSrc: "assets/icons/code.svg",
    bgColor: const Color(0xFF80A4FF),
  ),
];
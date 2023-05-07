import 'dart:convert';

import 'package:brand_qr_scanner/constants.dart';
import 'package:brand_qr_scanner/models/displayeduser.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  List<DisplayedUser> userList = <DisplayedUser>[];
  late double screenHeight, screenWidth, resWidth;
  final df = DateFormat('dd/MM/yyyy');
  var _tapPosition;
  var numofpage, curpage = 1;
  var color;
  String search = "";
  String titleCenter = "Loading...";
  String roleType = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsers(1, search);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFFF9EC9),
        title: Text(
          "Account List",
          textAlign: TextAlign.center,
          style: GoogleFonts.openSans(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: userList.isEmpty
          ? Center(
              child: Text(
                titleCenter,
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Column(children: [
              Container(
                  height: 42,
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        child: Icon(Icons.search, color: Colors.black),
                        onTap: () {
                          search = searchController.text;
                          _loadUsers(1, search);
                        },
                      ),
                      hintText: "Search UserName",
                      hintStyle: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.black),
                      border: InputBorder.none,
                    ),
                  )),
              Expanded(
                child: ListView.builder(
                  itemCount: userList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(
                            CONSTANTS.server +
                                "/qrscanner/assets/profilesimages/" +
                                userList[index].userId.toString() +
                                '.jpg',
                          ),
                        ),
                        title: Text(userList[index].userName.toString(),
                            style: GoogleFonts.montserrat(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w600)),
                        subtitle: Text(userList[index].userEmail.toString(),
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              color: Colors.black,
                            )),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          loadUserDetails(index);
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: numofpage,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if ((curpage - 1) == index) {
                      color = Color(0xFFFF9EC9);
                    } else {
                      color = Colors.black;
                    }
                    return SizedBox(
                      width: 40,
                      child: TextButton(
                          onPressed: () => {_loadUsers(index + 1, "")},
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: color),
                          )),
                    );
                  },
                ),
              ),
            ]),
    );
  }

  void _loadUsers(int pageno, String _search) {
    curpage = pageno;
    numofpage ??= 1;
    http.post(
      Uri.parse(CONSTANTS.server + "/qrscanner/php/loaduser.php"),
      body: {
        'pageno': pageno.toString(),
        'search': _search,
      },
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);
        if (extractdata['users'] != null) {
          userList = <DisplayedUser>[];
          extractdata['users'].forEach((v) {
            userList.add(DisplayedUser.fromJson(v));
          });
        } else {
          titleCenter = "No User Available";
        }
        setState(() {});
      }
    });
  }

  void loadUserDetails(int index) {
    if (userList[index].roleId.toString() == "1") {
      roleType = "Admin";
    } else if (userList[index].roleId.toString() == "2") {
      roleType = "Manufacturer";
    } else if (userList[index].roleId.toString() == "3") {
      roleType = "Retailer";
    } else if (userList[index].roleId.toString() == "4") {
      roleType = "Buyer";
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
            title: const Text(
              "User Details",
              style: TextStyle(),
            ),
            content: SingleChildScrollView(
                child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: CONSTANTS.server +
                      "/qrscanner/assets/profilesimages/" +
                      userList[index].userId.toString() +
                      '.jpg',
                  fit: BoxFit.cover,
                  width: resWidth,
                  height: screenHeight/4,
                  placeholder: (context, url) =>
                      const LinearProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Text(
                  userList[index].userName.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Column( children: [
                  Text("Email Address:",
                   textAlign: TextAlign.left,
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(userList[index].userEmail.toString(),
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.black)),
                  Text("Phone Number: ",
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text("0" + userList[index].userPhone.toString(),
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.black)),
                  Text("Address:",
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(userList[index].userAddress.toString(),
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.black)),
                  Text("Origin:",
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(userList[index].userOrigin.toString(),
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.black)),
                  Text("Role:",
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(roleType,
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.black)),
                  Text("Registration Date:",
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(
                      df.format(DateTime.parse(
                          userList[index].userRegDate.toString())),
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.black)),
                ])
              ],
            )),
            actions: [
              TextButton(
                child: Text(
                  "Close",
                  style: GoogleFonts.montserrat(
                      color: Color(0xFFFF9EC9),
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}

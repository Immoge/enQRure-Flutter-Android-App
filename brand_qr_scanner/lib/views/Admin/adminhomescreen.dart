import 'dart:convert';

import 'package:enQRsure/constants.dart';
import 'package:enQRsure/models/displayeduser.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final _formKey = GlobalKey<FormState>();
  List<DisplayedUser> userList = <DisplayedUser>[];
  late double screenHeight, screenWidth, resWidth;
  final df = DateFormat('dd/MM/yyyy');
  dynamic numofpage, curpage = 1;
  dynamic color;
  String search = "";
  String titleCenter = "Loading...";
  String roleType = "";
  List<String> countryList = [
    'Afghanistan',
    'Albania',
    'Algeria',
    'Andorra',
    'Angola',
    'Argentina',
    'Armenia',
    'Australia',
    'Austria',
    'Azerbaijan',
    'Bahamas',
    'Bahrain',
    'Bangladesh',
    'Barbados',
    'Belarus',
    'Belgium',
    'Belize',
    'Benin',
    'Bhutan',
    'Bolivia',
    'Botswana',
    'Brazil',
    'Brunei',
    'Bulgaria',
    'Burkina Faso',
    'Burundi',
    'Cabo Verde',
    'Cambodia',
    'Cameroon',
    'Canada',
    'Chad',
    'Chile',
    'China',
    'Colombia',
    'Comoros',
    'Costa Rica',
    'Croatia',
    'Cuba',
    'Cyprus',
    'Czechia',
    'Denmark',
    'Djibouti',
    'Dominica',
    'Dominican Republic',
    'Ecuador',
    'Egypt',
    'El Salvador',
    'Equatorial Guinea',
    'Eritrea',
    'Estonia',
    'Eswatini',
    'Ethiopia',
    'Fiji',
    'Finland',
    'France',
    'Gabon',
    'Gambia',
    'Georgia',
    'Germany',
    'Ghana',
    'Greece',
    'Grenada',
    'Guatemala',
    'Guinea',
    'Guinea-Bissau',
    'Guyana',
    'Haiti',
    'Honduras',
    'Hungary',
    'Iceland',
    'India',
    'Indonesia',
    'Iran',
    'Iraq',
    'Ireland',
    'Israel',
    'Italy',
    'Jamaica',
    'Japan',
    'Jordan',
    'Kazakhstan',
    'Kenya',
    'Kiribati',
    'Kosovo',
    'Kuwait',
    'Kyrgyzstan',
    'Laos',
    'Latvia',
    'Lebanon',
    'Lesotho',
    'Liberia',
    'Libya',
    'Liechtenstein',
    'Lithuania',
    'Luxembourg',
    'Madagascar',
    'Malawi',
    'Malaysia',
    'Maldives',
    'Mali',
    'Malta',
    'Marshall Islands',
    'Mauritania',
    'Mauritius',
    'Mexico',
    'Micronesia',
    'Moldova',
    'Monaco',
    'Mongolia',
    'Montenegro',
    'Morocco',
    'Mozambique',
    'Myanmar (Burma)',
    'Namibia',
    'Nauru',
    'Nepal',
    'Netherlands',
    'New Zealand',
    'Nicaragua',
    'Niger',
    'Nigeria',
    'North Korea',
    'Norway',
    'Oman',
    'Pakistan',
    'Palau',
    'Palestine',
    'Panama',
    'Papua New Guinea',
    'Paraguay',
    'Peru',
    'Philippines',
    'Poland',
    'Portugal',
    'Qatar',
    'Romania',
    'Russia',
    'Rwanda',
    'Saint Lucia',
    'Samoa',
    'San Marino',
    'Saudi Arabia',
    'Senegal',
    'Serbia',
    'Seychelles',
    'Sierra Leone',
    'Singapore',
    'Slovakia',
    'Slovenia',
    'Solomon Islands',
    'Somalia',
    'South Africa',
    'South Korea',
    'South Sudan',
    'Spain',
    'Sri Lanka'
  ];
  List<String> roleList = ['Admin', 'Manufacturer', 'Retailer', 'Buyer'];
  String? selectedItem1 = 'Buyer';
  String? selectedItem2 = 'Malaysia';
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController countryController = TextEditingController();
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
        backgroundColor: const Color(0xFFFF9EC9),
        title: Text(
          "Account List",
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
                        child: const Icon(Icons.search, color: Colors.black),
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
                                "/enQRsure/assets/profilesimages/" +
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
                      color = const Color(0xFFFF9EC9);
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

  void _loadUsers(int pageno, String search) {
    curpage = pageno;
    numofpage ??= 1;
    http.post(
      Uri.parse("${CONSTANTS.server}/enQRsure/php/loaduser.php"),
      body: {
        'pageno': pageno.toString(),
        'search': search,
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
            title: Text(
              "User Details",
              style: GoogleFonts.openSans(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            content: SingleChildScrollView(
                child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: CONSTANTS.server +
                      "/enQRsure/assets/profilesimages/" +
                      userList[index].userId.toString() +
                      '.jpg',
                  fit: BoxFit.cover,
                  width: 200,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                const SizedBox(height: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("User Name: ",
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(userList[index].userName.toString(),
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.black)),
                  const SizedBox(height: 10),
                  Text("Email Address:",
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(userList[index].userEmail.toString(),
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.black)),
                  const SizedBox(height: 10),
                  Text("Phone Number: ",
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text("0${userList[index].userPhone}",
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.black)),
                  const SizedBox(height: 10),
                  Text("Address:",
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(userList[index].userAddress.toString(),
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.black)),
                  const SizedBox(height: 10),
                  Text("Origin:",
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(userList[index].userOrigin.toString(),
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.black)),
                  const SizedBox(height: 10),
                  Text("Role:",
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(roleType,
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.black)),
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
                  Container(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: screenWidth,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          _editUserDetails(index);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF77CE80),
                            side: BorderSide.none,
                            shape: const StadiumBorder()),
                        child: const Text("Edit User Account",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: screenWidth,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          _deleteUser(index);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF5595D),
                            side: BorderSide.none,
                            shape: const StadiumBorder()),
                        child: const Text("Delete User Account",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ])
              ],
            )),
            actions: [
              TextButton(
                child: Text(
                  "Close",
                  style: GoogleFonts.montserrat(
                      color: const Color(0xFFFF9EC9),
                      fontSize: 18,
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

  void _deleteUser(int index) {
    http.post(Uri.parse("${CONSTANTS.server}/enQRsure/php/deleteuser.php"),
        body: {"userid": userList[index].userId}).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Deleted Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        _loadUsers(1, "");
        Navigator.of(context).pop();
      } else {
        Fluttertoast.showToast(
            msg: "Delete Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  void _editUserDetails(int index) {
    if (userList[index].roleId.toString() == "1") {
      roleType = "Admin";
    } else if (userList[index].roleId.toString() == "2") {
      roleType = "Manufacturer";
    } else if (userList[index].roleId.toString() == "3") {
      roleType = "Retailer";
    } else if (userList[index].roleId.toString() == "4") {
      roleType = "Buyer";
    }

    nameController.text = userList[index].userName.toString();
    emailController.text = userList[index].userEmail.toString();
    phoneController.text = userList[index].userPhone.toString();
    addressController.text = userList[index].userAddress.toString();
    roleController.text = roleType.toString();
    countryController.text = userList[index].userOrigin.toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: Text(
            "Edit User Details",
            style: GoogleFonts.openSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      imageUrl: CONSTANTS.server +
                          "/enQRsure/assets/profilesimages/" +
                          userList[index].userId.toString() +
                          '.jpg',
                      fit: BoxFit.cover,
                      width: 200,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                    key: _formKey,
                    child: Column(children: [
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 2.0),
                            ),
                            prefixIcon: const Icon(LineAwesomeIcons.user_tie),
                            labelText: "Full Name"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 2.0),
                            ),
                            prefixIcon: const Icon(LineAwesomeIcons.envelope),
                            labelText: "E-mail"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter valid email address";
                          }
                          bool nameValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value);

                          if (!nameValid) {
                            return "Please enter valid email address";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: phoneController,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 2.0),
                            ),
                            prefixIcon:
                                const Icon(LineAwesomeIcons.phone_square),
                            labelText: "Phone No"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter phone number";
                          }
                          if (value.length < 10) {
                            return "Please enter valid phone number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: addressController,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 2.0),
                            ),
                            prefixIcon: const Icon(LineAwesomeIcons.map_marked),
                            labelText: "Home Address"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter home address";
                          }
                          if (value.length < 15) {
                            return "Please enter valid home address";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: countryController,
                        decoration: InputDecoration(
                            labelText: 'Country',
                            prefixIcon: const Icon(Icons.flag_circle),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 2.0),
                            )),
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          final String? selectedCountry =
                              await showDialog<String>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'Select a Country',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                content: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: DropdownButtonFormField<String>(
                                    value: selectedItem2,
                                    icon: const Icon(
                                        Icons.arrow_drop_down_circle),
                                    decoration: InputDecoration(
                                        labelText: "Country",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0))),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedItem2 = newValue!;
                                      });
                                      Navigator.of(context).pop(newValue);
                                    },
                                    items: countryList.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          );
                          if (selectedCountry != null) {
                            countryController.text = selectedCountry;
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select a country";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: roleController,
                        decoration: InputDecoration(
                            labelText: 'Role',
                            prefixIcon: const Icon(LineAwesomeIcons.user_tag),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 2.0),
                            )),
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          final String? selectedRole = await showDialog<String>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'Select a Role',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                content: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: DropdownButtonFormField<String>(
                                    value: selectedItem1,
                                    icon: const Icon(
                                        Icons.arrow_drop_down_circle),
                                    decoration: InputDecoration(
                                        labelText: "Role",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0))),
                                    onChanged: (String? newValue2) {
                                      setState(() {
                                        selectedItem1 = newValue2!;
                                      });
                                      Navigator.of(context).pop(newValue2);
                                    },
                                    items: roleList.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          );
                          if (selectedRole != null) {
                            roleController.text = selectedRole;
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select a role";
                          }
                          return null;
                        },
                      ),
                    ])),
                const SizedBox(height: 20),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _updateProfile(index);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF9EC9),
                          side: BorderSide.none,
                          shape: const StadiumBorder()),
                      child: Text("Update User Profile",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    )),
                const SizedBox(height: 20),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "Close",
                style: GoogleFonts.montserrat(
                  color: const Color(0xFFFF9EC9),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateProfile(int index) async {
    String name = nameController.text;
    String email = emailController.text;
    String phone = phoneController.text;
    String address = addressController.text;
    String role = roleController.text;
    String origin = countryController.text;
    String roleId = "";
    FocusScope.of(context).requestFocus(FocusNode());
    if (role == "Admin") {
      roleId = "1";
    } else if (role == "Manufacturer") {
      roleId = "2";
    } else if (role == "Retailer") {
      roleId = "3";
    } else if (role == "Buyer") {
      roleId = "4";
    }

    http.post(
      Uri.parse("${CONSTANTS.server}/enQRsure/php/updateprofile.php/"),
      body: {
        "userid": userList[index].userId.toString(),
        "useremail": email,
        "username": name,
        "userphone": phone,
        "useraddress": address,
        "roleid": roleId,
        "userorigin": origin,
      },
    ).then((response) async {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
          msg: "Profile Updated Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0,
        );
        Navigator.pop(
          context,
        );
        Navigator.pop(
          context,
        );
        setState(() {});
      } else {
        Fluttertoast.showToast(
          msg: "Profile Updated Unsuccessfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0,
        );
      }
    });
  }
}

import 'dart:convert';
import 'package:enQRsure/views/Manufacturer/manufacturereditprofilescreen.dart';
import 'package:enQRsure/views/mainscreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../constants.dart';
import '../../models/user.dart';
import '../loginscreen.dart';

class ManufacturerProfileScreen extends StatefulWidget {
  final User user;
  const ManufacturerProfileScreen({Key? key, required this.user})
      : super(key: key);

  @override
  State<ManufacturerProfileScreen> createState() =>
      _ManufacturerProfileScreenState();
}

class _ManufacturerProfileScreenState extends State<ManufacturerProfileScreen> {
  late Color? color;
  late double screenHeight, screenWidth, resWidth;
  final TextEditingController _oldpasswordController = TextEditingController();
  final TextEditingController _newpasswordController = TextEditingController();
  var _image;
  var val = 50;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.85;
    }
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(200),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: const Color(0xFF90E6C3),
        elevation: 1,
        title: Text("Profile",
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              fontSize: 25,
              fontWeight: FontWeight.w500,
            )),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(children: [
            SizedBox(
              width: 150,
              height: 150,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                      CONSTANTS.server +
                          '/enQRsure/assets/profilesimages/${widget.user.id}.jpg' +
                          "?v=$val",
                      errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, size: 128);
                  })),
            ),
            const SizedBox(height: 10),
            Text(widget.user.name.toString(),
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                    fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(widget.user.email.toString(),
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(fontSize: 15)),
            const SizedBox(height: 20),
            SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ManufacturerEditProfileScreen(
                              user: widget.user))),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF90E6C3),
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: Text("Edit Profile",
                      style: GoogleFonts.montserrat(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                )),
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 10),
            ProfileMenuWidget(
              title: "Information",
              icon: LineAwesomeIcons.info,
              onPress: () {},
            ),
            ProfileMenuWidget(
              title: "Change Password",
              icon: Icons.key,
              onPress: _changePassDialog,
            ),
            ProfileMenuWidget(
              title: "Switch Accounts",
              icon: Icons.switch_account_outlined,
              onPress: _loginDialog,
            ),
            const SizedBox(height: 20),
            const Divider(),
            ProfileMenuWidget(
              title: "Logout",
              icon: LineAwesomeIcons.alternate_sign_out,
              textColor: Colors.red,
              endIcon: false,
              onPress: _logoutDialog,
            ),
          ])),
    );
  }

  void _loginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text("Login to Another Account?",
              style: GoogleFonts.montserrat(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Yes",
                style: GoogleFonts.montserrat(
                    color: const Color(0xFF90E6C3),
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const LoginScreen()));
              },
            ),
            TextButton(
              child: Text(
                "No",
                style: GoogleFonts.montserrat(
                    color: const Color(0xFF90E6C3),
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
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

  void _logoutDialog() {
    User user = User(
      id: "0",
      email: "guest@immoge.com",
      name: "Guest",
      password: "na",
      address: "na",
      phone: "na",
      roleid: "0",
      origin: "na",
      regdate: "0",
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text("Logout?",
              style: GoogleFonts.montserrat(
                  fontSize: 20, fontWeight: FontWeight.bold)),
          content: const Text("Are your sure"),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Yes",
                style: GoogleFonts.montserrat(
                    color: const Color(0xFF90E6C3),
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            MainScreen(user: user)));
                setState(() {});
              },
            ),
            TextButton(
              child: Text(
                "No",
                style: GoogleFonts.montserrat(
                    color: const Color(0xFF90E6C3),
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
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

  void _changePassDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text("Change Password?",
              style: GoogleFonts.montserrat(
                  fontSize: 20, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                obscureText: true,
                controller: _oldpasswordController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Colors.black, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 2.0),
                  ),
                  prefixIcon: const Icon(LineAwesomeIcons.fingerprint),
                  labelText: "Old Password",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter valid password";
                  }
                  if (value.length < 6) {
                    return "Please enter password more than 6 characters";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5),
              TextFormField(
                obscureText: true,
                controller: _newpasswordController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Colors.black, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 2.0),
                  ),
                  prefixIcon: const Icon(LineAwesomeIcons.fingerprint),
                  labelText: "New Password",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter valid password";
                  }
                  if (value.length < 6) {
                    return "Please enter password more than 6 characters";
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Yes",
                style: GoogleFonts.montserrat(
                    color: const Color(0xFF90E6C3),
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                changePass();
              },
            ),
            TextButton(
              child: Text(
                "No",
                style: GoogleFonts.montserrat(
                    color: const Color(0xFF90E6C3),
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
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

  void changePass() {
    http.post(Uri.parse("${CONSTANTS.server}/enQRsure/php/updatepassword.php"),
        body: {
          "oldpass": _oldpasswordController.text,
          "newpass": _newpasswordController.text,
          "userid": widget.user.id,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Update Password Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        setState(() {});
      } else {
        Fluttertoast.showToast(
            msg: "Incorrect Password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
    _oldpasswordController.clear();
    _newpasswordController.clear();
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: const Color(0xFF90E6C3),
        ),
        child: Icon(icon, color: Colors.black),
      ),
      title: Text(title,
          style: GoogleFonts.montserrat(
              fontSize: 15, fontWeight: FontWeight.bold, color: textColor)),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.green.withOpacity(0.1),
              ),
              child: const Icon(LineAwesomeIcons.angle_right,
                  size: 18, color: Colors.black))
          : null,
    );
  }
}

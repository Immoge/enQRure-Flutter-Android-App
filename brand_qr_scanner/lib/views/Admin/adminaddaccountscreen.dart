import 'dart:convert';
import 'dart:io';

import 'package:brand_qr_scanner/constants.dart';
import 'package:brand_qr_scanner/models/user.dart';
import 'package:brand_qr_scanner/views/Admin/adminhomescreen.dart';
import 'package:brand_qr_scanner/views/Admin/adminmainscreen.dart';
import 'package:brand_qr_scanner/views/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AdminAddAccountScreen extends StatefulWidget {
  final User user;
  const AdminAddAccountScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<AdminAddAccountScreen> createState() => _AdminAddAccountScreenState();
}

class _AdminAddAccountScreenState extends State<AdminAddAccountScreen> {
  @override
  late double screenHeight, screenWidth, ctrWidth;
  String pathAsset = 'assets/images/camera.png';
  var _image;
  bool passVisible = true;
  bool passVisible2 = true;
  List<String> roleList = ['Admin', 'Manufacturer', 'Retailer'];
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
  String? selectedItem = 'Manufacturer';
  String? selectedItem2 = 'Malaysia';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController password1Controller = TextEditingController();
  final TextEditingController password2Controller = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      ctrWidth = screenWidth;
    } else {
      ctrWidth = screenWidth * 0.75;
    }
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFFFF882E),
          title: Text("Admin Add Account",
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 25,
                fontWeight: FontWeight.w500,
              )),
        ),
        body: SingleChildScrollView(
            child: Center(
                child: SizedBox(
          width: ctrWidth,
          child: Form(
            key: _formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  32,
                  40,
                  32,
                  25,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "New Account",
                        style: GoogleFonts.montserrat(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        child: GestureDetector(
                            onTap: () => {_takePictureDialog()},
                            child: SizedBox(
                                height: screenHeight / 4,
                                width: screenWidth,
                                child: _image == null
                                    ? Image.asset(pathAsset)
                                    : Image.file(
                                        _image,
                                      ))),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(Icons.account_circle_outlined),
                              labelText: "Name",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please insert your name";
                            }
                            if (value.length < 5) {
                              return "Please enter valid name that longer than 6 characters";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email_outlined),
                              labelText: "Email",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: TextFormField(
                          controller: phoneController,
                          decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(Icons.local_phone_outlined),
                              labelText: "Phone Number",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: TextFormField(
                          controller: addressController,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.house_outlined),
                              labelText: "Home Address",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: TextFormField(
                          controller: password1Controller,
                          obscureText: passVisible,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_outlined),
                              labelText: "Password",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  passVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    passVisible = !passVisible;
                                  });
                                },
                              )),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: TextFormField(
                          controller: password2Controller,
                          obscureText: passVisible2,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_outlined),
                              labelText: "Retype Password",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  passVisible2
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    passVisible2 = !passVisible2;
                                  });
                                },
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please reenter your password";
                            }
                            if (value != password1Controller.text) {
                              return "Password does not match";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: TextFormField(
                            controller: roleController,
                            decoration: InputDecoration(
                              labelText: 'Role',
                              prefixIcon: const Icon(Icons.person_2),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                            onTap: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              final String? selectedRole =
                                  await showDialog<String>(
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
                                        value: selectedItem,
                                        icon: const Icon(
                                            Icons.arrow_drop_down_circle),
                                        decoration: InputDecoration(
                                            labelText: "Role",
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        5.0))),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedItem = newValue!;
                                          });
                                          Navigator.of(context).pop(newValue);
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
                                return "Please the country";
                              }
                              return null;
                            },
                          )),
                      const SizedBox(height: 10),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: TextFormField(
                            controller: countryController,
                            decoration: InputDecoration(
                              labelText: 'Country',
                              prefixIcon: const Icon(Icons.flag_circle),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
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
                                                    BorderRadius.circular(
                                                        5.0))),
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
                                return "Please the role";
                              }
                              return null;
                            },
                          )),
                      const SizedBox(height: 10),
                      Container(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: screenWidth,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              _insertDialog();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFF882E),
                                side: BorderSide.none,
                                shape: const StadiumBorder()),
                            child: const Text("Add Account",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ]),
              ),
            ]),
          ),
        ))));
  }

  _takePictureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: const Text(
              "Select from",
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                    onPressed: () => {
                          Navigator.of(context).pop(),
                          _galleryPicker(),
                        },
                    icon: const Icon(Icons.browse_gallery),
                    label: const Text("Gallery")),
                TextButton.icon(
                    onPressed: () =>
                        {Navigator.of(context).pop(), _cameraPicker()},
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera")),
              ],
            ));
      },
    );
  }

  _galleryPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

  _cameraPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 600,
      maxWidth: 600,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

  Future<void> _cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
    );
    if (croppedFile != null) {
      File _image = File(croppedFile.path);
      setState(() {});
    }
  }

  void _insertDialog() {
    if (_formKey.currentState!.validate() && _image != null) {
      _formKey.currentState!.save();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text("Register new account",
                style: GoogleFonts.montserrat(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            content: const Text("Are you sure?"),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "No",
                  style: GoogleFonts.montserrat(
                      color: Color(0xFFFF882E),
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  "Confirm",
                  style: GoogleFonts.montserrat(
                      color: Color(0xFFFF882E),
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  _addNewAccount();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _addNewAccount() {
    String _name = nameController.text;
    String _email = emailController.text;
    String _phone = phoneController.text;
    String _address = addressController.text;
    String _password = password1Controller.text;
    String _roleid = "0";
    String _origin = countryController.text;

    if (roleController.text == "Admin") {
      _roleid = "1";
    } else if (roleController.text == "Manufacturer") {
      _roleid = "2";
    } else if (roleController.text == "Retailer") {
      _roleid = "3";
    }
    String base64Image = base64Encode(_image!.readAsBytesSync());
    FocusScope.of(context).requestFocus(FocusNode());

    http.post(Uri.parse(CONSTANTS.server + "/qrscanner/php/registeruser.php/"),
        body: {
          "email": _email,
          "name": _name,
          "password": _password,
          "phone": _phone,
          "address": _address,
          "roleid": _roleid,
          "origin": _origin,
          "image": base64Image,
        }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Add Account Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (content) => AdminMainScreen(user: widget.user)));
      } else {
        Fluttertoast.showToast(
            msg: "Add Account Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        return;
      }
    });
  }
}

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import '../../constants.dart';
import '../../models/user.dart';

class RetailerEditProfileScreen extends StatefulWidget {
  final User user;
  const RetailerEditProfileScreen({Key? key, required this.user})
      : super(key: key);

  @override
  State<RetailerEditProfileScreen> createState() =>
      _RetailerEditProfileScreenState();
}

class _RetailerEditProfileScreenState
    extends State<RetailerEditProfileScreen> {
  late Color? color;
  late double screenHeight, screenWidth, resWidth;
  var _image;
  var val = 50;
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
  String? selectedItem2 = 'Malaysia';
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Random random = Random();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.user.name.toString();
    emailController.text = widget.user.email.toString();
    phoneController.text = widget.user.phone.toString();
    addressController.text = widget.user.address.toString();
    countryController.text = widget.user.origin.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFFFFB747),
          elevation: 1,
          title: Text("Edit Profile",
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              )),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(children: [
              Stack(
                children: [
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
                          }))),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: const Color(0xFFFFB747),
                          ),
                          child: GestureDetector(
                            onTap: () => {_updateImageDialog()},
                            child: const Icon(LineAwesomeIcons.camera,
                                size: 20, color: Colors.black),
                          )))
                ],
              ),
              const SizedBox(height: 50),
              Form(
                  key: _formKey,
                  child: Column(children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: TextFormField(
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
                        )),
                    const SizedBox(height: 10),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: TextFormField(
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
                        )),
                    const SizedBox(height: 10),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: TextFormField(
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
                        )),
                    const SizedBox(height: 10),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: TextFormField(
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
                              prefixIcon:
                                  const Icon(LineAwesomeIcons.map_marked),
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
                        )),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: TextFormField(
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
                        )),
                  ])),
              const SizedBox(height: 20),
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _updateProfile();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFB747),
                        side: BorderSide.none,
                        shape: const StadiumBorder()),
                    child: Text("Edit Profile",
                        style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  )),
              const SizedBox(height: 20),
            ])));
  }

  _updateImageDialog() {
    if (widget.user.email == "guest@immoge.com") {
      Fluttertoast.showToast(
          msg: "Please login",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      return;
    }
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
      maxHeight: 800,
      maxWidth: 800,
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
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      _updateProfileImage(_image);
    }
  }

  void _updateProfileImage(image) {
    String base64Image = base64Encode(image!.readAsBytesSync());
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(msg: 'Uploading...', max: 100);
    http.post(
        Uri.parse("${CONSTANTS.server}/enQRsure/php/updateprofilepicture.php/"),
        body: {
          "userid": widget.user.id,
          "image": base64Image,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        val = random.nextInt(1000);
        setState(() {});
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
      pd.close();
    });
  }

  void _updateProfile() async {
    String name = nameController.text;
    String email = emailController.text;
    String phone = phoneController.text;
    String address = addressController.text;
    String origin = countryController.text;
    FocusScope.of(context).requestFocus(FocusNode());

    http.post(
      Uri.parse("${CONSTANTS.server}/enQRsure/php/updateprofile.php/"),
      body: {
        "userid": widget.user.id.toString(),
        "useremail": email,
        "username": name,
        "userphone": phone,
        "useraddress": address,
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

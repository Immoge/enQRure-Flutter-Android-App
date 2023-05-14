import 'dart:io';
import 'dart:convert';
import 'package:enQRsure/models/product.dart';
import 'package:enQRsure/views/mainscreen.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import '../../models/user.dart';
import '../../constants.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class BuyerCounterfeitProductScreen extends StatefulWidget {
  final User user;
  final Product product;
  const BuyerCounterfeitProductScreen(
      {Key? key, required this.user, required this.product})
      : super(key: key);

  @override
  State<BuyerCounterfeitProductScreen> createState() =>
      _BuyerCounterfeitProductScreenState();
}

class _BuyerCounterfeitProductScreenState
    extends State<BuyerCounterfeitProductScreen> {
  WidgetsToImageController widgetcontroller = WidgetsToImageController();

  late double screenHeight, screenWidth, ctrwidth;
  String pathAsset = 'assets/images/upload image.png';
  var _image3;
  var _image;
  final TextEditingController _cprnameEditingController =
      TextEditingController();
  final TextEditingController _cprdescriptionEditingController =
      TextEditingController();
  final TextEditingController _cprplatformEditingController =
      TextEditingController();
  final TextEditingController _cproriginEditingController =
      TextEditingController();
  final TextEditingController _cprlocationEditingController =
      TextEditingController();
  final TextEditingController _cprsellernameEditingController =
      TextEditingController();
  final TextEditingController _cprpurchsedateEditingController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  String selectedItem1 = 'Online';
  String selectedItem2 = "Malaysia";
  var platform = ['Online', 'Offline'];
  var countryList = [
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

  @override
  void dispose() {
    _cprnameEditingController.dispose();
    _cprdescriptionEditingController.dispose();
    _cprplatformEditingController.dispose();
    _cproriginEditingController.dispose();
    _cprlocationEditingController.dispose();
    _cprsellernameEditingController.dispose();
    _cprpurchsedateEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 800) {
      ctrwidth = screenWidth / 1.5;
    }
    if (screenWidth < 800) {
      ctrwidth = screenWidth / 1.1;
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF54B5FF),
          title: Text("Counterfeit Product Report",
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 25,
                fontWeight: FontWeight.w500,
              )),
        ),
        body: SingleChildScrollView(
            child: Center(
          child: SizedBox(
              width: ctrwidth,
              child: Form(
                  key: _formKey,
                  child: Column(children: [
                    const SizedBox(height: 10),
                    Card(
                      child: GestureDetector(
                          onTap: () => {_takePictureDialog()},
                          child: SizedBox(
                              height: screenHeight / 3,
                              width: screenWidth,
                              child: _image == null
                                  ? Image.asset(pathAsset)
                                  : Image.file(
                                      _image,
                                      fit: BoxFit.cover,
                                    ))),
                    ),
                    const SizedBox(height: 10),
                    Form(
                      key: _formKey2,
                      child: Column(children: [
                        TextFormField(
                          controller: _cprnameEditingController,
                          decoration: InputDecoration(
                              labelText: 'Product Name',
                              prefixIcon: const Icon(Icons.title),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter valid product name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          controller: _cprdescriptionEditingController,
                          minLines: 6,
                          keyboardType: TextInputType.multiline,
                          maxLines: 6,
                          decoration: InputDecoration(
                              labelText: 'Product Description',
                              alignLabelWithHint: true,
                              prefixIcon: const Padding(
                                  padding: EdgeInsets.only(bottom: 80),
                                  child: Icon(Icons.description)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some product description';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                            width: screenWidth,
                            child: TextFormField(
                              controller: _cprplatformEditingController,
                              decoration: InputDecoration(
                                labelText: 'Platform',
                                prefixIcon:
                                    const Icon(LineAwesomeIcons.campground),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                              ),
                              onTap: () async {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                final String? selectedProductPlatform =
                                    await showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Select a plafrom',
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
                                              labelText: "Platform",
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0))),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedItem1 = newValue!;
                                            });
                                            Navigator.of(context).pop(newValue);
                                          },
                                          items: platform.map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 15),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    );
                                  },
                                );
                                if (selectedProductPlatform != null) {
                                  _cprplatformEditingController.text =
                                      selectedProductPlatform;
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please a platform.";
                                }
                                return null;
                              },
                            )),
                        const SizedBox(height: 10),
                        SizedBox(
                            width: screenWidth,
                            child: TextFormField(
                              controller: _cproriginEditingController,
                              decoration: InputDecoration(
                                labelText: 'Origin',
                                prefixIcon: const Icon(LineAwesomeIcons.globe),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                              ),
                              onTap: () async {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                final String? selectedProductOrigin =
                                    await showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Select Product Origin',
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
                                              labelText: "Product Origin",
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
                                          items:
                                              countryList.map((String value) {
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
                                if (selectedProductOrigin != null) {
                                  _cproriginEditingController.text =
                                      selectedProductOrigin;
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please a origin.";
                                }
                                return null;
                              },
                            )),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _cprlocationEditingController,
                          decoration: InputDecoration(
                              labelText: 'Purchase Location',
                              prefixIcon:
                                  const Icon(LineAwesomeIcons.map_marker),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter valid purchase location.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _cprsellernameEditingController,
                          decoration: InputDecoration(
                              labelText: 'Seller Name',
                              prefixIcon: const Icon(
                                  LineAwesomeIcons.person_entering_booth),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter valid seller name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: screenWidth,
                          child: TextFormField(
                            controller: _cprpurchsedateEditingController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(LineAwesomeIcons.calendar),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              labelText: 'Purchase Date',
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                setState(() {
                                  _cprpurchsedateEditingController.text =
                                      formattedDate;
                                });
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter purchase date';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: screenWidth,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF54B5FF),
                                side: BorderSide.none,
                                shape: const StadiumBorder()),
                            child: const Text("Submit Report",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              _submitDialog();
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                      ]),
                    ),
                  ]))),
        )));
  }

  _takePictureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                  label: Text("Gallery",
                      style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue)),
                ),
                TextButton.icon(
                  onPressed: () =>
                      {Navigator.of(context).pop(), _cameraPicker()},
                  icon: const Icon(Icons.camera_alt),
                  label: Text("Camera",
                      style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue)),
                )
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

  _submitDialog() async {
    if (_formKey.currentState!.validate() && _image != null) {
      _formKey.currentState!.save();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            title: Text(
              "Sumbit Counterfeit Report",
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text("Are u sure to submit this?"),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "No",
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFF54B5FF),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  "Confirm",
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFF54B5FF),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  uploadReport();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void uploadReport() {
    String cprname = _cprnameEditingController.text;
    String cprdescription = _cprdescriptionEditingController.text;
    String cprplatform = _cprplatformEditingController.text;
    String cprorgin = _cproriginEditingController.text;
    String cprlocation = _cprlocationEditingController.text;
    String cprsellername = _cprsellernameEditingController.text;
    String cprpurchasedate = _cprpurchsedateEditingController.text;
    String cprencryptedcode = widget.product.productEncryptedCode.toString();
    String cprbuyerid = widget.user.id.toString();
    String base64Image = base64Encode(_image!.readAsBytesSync());
    http.post(
        Uri.parse(
            "${CONSTANTS.server}/enQRsure/php/submitcounterfeitreport.php/"),
        body: {
          "cprname": cprname,
          "cprdescription": cprdescription,
          "cprplatform": cprplatform,
          "cprorgin": cprorgin,
          "cprlocation": cprlocation,
          "cprsellername": cprsellername,
          "cprpurchasedate": cprpurchasedate,
          "cprencryptedcode": cprencryptedcode,
          "cprbuyerid": cprbuyerid,
          "image": base64Image,
        }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Submitted Succcesfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(user: widget.user),
          ),
        );
      } else {
        Fluttertoast.showToast(
            msg: data['status'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }
}

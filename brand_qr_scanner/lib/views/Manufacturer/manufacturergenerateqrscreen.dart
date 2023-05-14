import 'dart:io';
import 'dart:convert';
import 'package:enQRsure/views/Manufacturer/manufacturermainscreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import '../../models/user.dart';
import '../../constants.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class ManufacturerGenerateQRScreen extends StatefulWidget {
  final User user;
  const ManufacturerGenerateQRScreen({Key? key, required this.user})
      : super(key: key);

  @override
  State<ManufacturerGenerateQRScreen> createState() =>
      _ManufacturerGenerateQRScreenState();
}

class _ManufacturerGenerateQRScreenState
    extends State<ManufacturerGenerateQRScreen> {
  WidgetsToImageController widgetcontroller = WidgetsToImageController();

  late double screenHeight, screenWidth, ctrwidth;
  String encryptedCode = "";
  String pathAsset = 'assets/images/upload image.png';
  var _image3;
  var _image;
  final TextEditingController _prnameEditingController =
      TextEditingController();
  final TextEditingController _prdescriptionEditingController =
      TextEditingController();
  final TextEditingController _prtypeEditingController =
      TextEditingController();
  final TextEditingController _prbarcodeEditingController =
      TextEditingController();
  final TextEditingController _prdateEditingController =
      TextEditingController();
  final TextEditingController _prwarrantyEditingController =
      TextEditingController();
  final TextEditingController _proriginEditingController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  String selectedItem1 = 'Electronics';
  String selectedItem2 = "Malaysia";
  var productType = [
    'Electronics',
    'Clothing & Fashion',
    'Home Appliances',
    'Beauty and Personal Care',
    'Automotive & Accessories',
    'Sports & Fitness',
    'Toys & Games',
    'Book & Stationery',
    'Furniture & Home Decor',
    'Health & Wellness',
    'Jewelry & Accessories',
    'Tools & Hardware',
    'Pet Supplies',
    'Bag & Accessories'
  ];
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
    _prnameEditingController.dispose();
    _prdescriptionEditingController.dispose();
    _prtypeEditingController.dispose();
    _prbarcodeEditingController.dispose();
    _prdateEditingController.dispose();
    _prwarrantyEditingController.dispose();
    _proriginEditingController.dispose();
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
          backgroundColor: const Color(0xFF90E6C3),
          title: Text("Add Product",
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
                          controller: _prnameEditingController,
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
                          controller: _prdescriptionEditingController,
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
                              controller: _prtypeEditingController,
                              decoration: InputDecoration(
                                labelText: 'Product Type',
                                prefixIcon: const Icon(LineAwesomeIcons.tags),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                              ),
                              onTap: () async {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                final String? selectedProductType =
                                    await showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Select a Type',
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
                                              labelText: "Product Type",
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
                                          items:
                                              productType.map((String value) {
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
                                if (selectedProductType != null) {
                                  _prtypeEditingController.text =
                                      selectedProductType;
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please a product type.";
                                }
                                return null;
                              },
                            )),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                width: screenWidth * 0.5,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: _prbarcodeEditingController,
                                  maxLength: 12,
                                  decoration: InputDecoration(
                                    labelText: 'Barcode',
                                    suffixIcon: IconButton(
                                      icon:
                                          const Icon(LineAwesomeIcons.barcode),
                                      onPressed: () async {
                                        String barcodeScanRes =
                                            await FlutterBarcodeScanner
                                                .scanBarcode("#ff6666", "Back",
                                                    false, ScanMode.DEFAULT);
                                        setState(() {
                                          _prbarcodeEditingController.text =
                                              barcodeScanRes;
                                        });
                                      },
                                    ),
                                    counterText: "",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a valid Barcode';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                width: screenWidth * 0.5,
                                child: TextFormField(
                                  controller: _prdateEditingController,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(LineAwesomeIcons.calendar),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    labelText: 'Manufacture Date',
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
                                          DateFormat('yyyy-MM-dd')
                                              .format(pickedDate);
                                      setState(() {
                                        _prdateEditingController.text =
                                            formattedDate;
                                      });
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter manufacture date';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _prwarrantyEditingController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false),
                          decoration: InputDecoration(
                              labelText: 'Warranty Period (Months)',
                              prefixIcon: const Icon(LineAwesomeIcons.check_circle),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter valid warranty period';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                            width: screenWidth,
                            child: TextFormField(
                              controller: _proriginEditingController,
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
                                  _proriginEditingController.text =
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
                        SizedBox(
                          width: screenWidth,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF90E6C3),
                                side: BorderSide.none,
                                shape: const StadiumBorder()),
                            child: const Text("Add Product",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              _insertDialog();
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

  _insertDialog() async {
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
              "Add new product",
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text("Add This Product?"),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "No",
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFF90E6C3),
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
                    color: const Color(0xFF90E6C3),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  await _generateEncryptedCode();
                  await _insertProduct();
                  _generateQRDialog(encryptedCode);
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _insertProduct() async {
    String prname = _prnameEditingController.text;
    String prdescription = _prdescriptionEditingController.text;
    String prtype = _prtypeEditingController.text;
    String prbarcode = _prbarcodeEditingController.text;
    String prdate = _prdateEditingController.text;
    String prwarranty = _prwarrantyEditingController.text;
    String prorigin = _proriginEditingController.text;
    String prencryptedcode = encryptedCode;
    String manufacturerid = widget.user.id.toString();
    String base64Image = base64Encode(_image!.readAsBytesSync());
    http.post(Uri.parse("${CONSTANTS.server}/enQRsure/php/addproduct.php/"),
        body: {
          "prname": prname,
          "prdescription": prdescription,
          "prtype": prtype,
          "prbarcode": prbarcode,
          "prdate": prdate,
          "prwarranty": prwarranty,
          "prorigin": prorigin,
          "prencryptedcode": prencryptedcode,
          "manufacturerid": manufacturerid,
          "image": base64Image,
        }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
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

  Future<void> _generateEncryptedCode() async {
    String prname = _prnameEditingController.text;
    String prdescription = _prdescriptionEditingController.text;
    String prtype = _prtypeEditingController.text;
    String prbarcode = _prbarcodeEditingController.text;
    String prdate = _prdateEditingController.text;
    String prorigin = _proriginEditingController.text;
    String securityCode = generateRandomNumber();
    String randomizationCode = prname +
        prdescription +
        prtype +
        prbarcode +
        prdate +
        prorigin +
        securityCode;
    encryptedCode = encryptWithSHA256(randomizationCode);
  }

  void _generateQRDialog(String encryptedCode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: Text(
            "QR code",
            style: GoogleFonts.openSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: SingleChildScrollView(
            child: WidgetsToImage(
              controller: widgetcontroller,
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: QrImage(
                      data: encryptedCode,
                      version: QrVersions.auto,
                      size: 200,
                      gapless: false,
                      embeddedImage:
                          const AssetImage('assets/images/enQRsure logo.png'),
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: const Size(40, 40),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "Download",
                style: GoogleFonts.montserrat(
                  color: const Color(0xFF90E6C3),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                _downloadQRCode();
              },
            ),
            TextButton(
              child: Text(
                "Close",
                style: GoogleFonts.montserrat(
                  color: const Color(0xFF90E6C3),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ManufacturerMainScreen(user: widget.user)));
              },
            ),
          ],
        );
      },
    );
  }

  String generateRandomNumber() {
    Random random = Random();
    int min = 10000000; // Minimum 8-digit number
    int max = 99999999; // Maximum 8-digit number
    int randomNumber = min + random.nextInt(max - min);
    return randomNumber.toString();
  }

  String encryptWithSHA256(String input) {
    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> _downloadQRCode() async {
    var status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      var image2 = await widgetcontroller.capture();
      if (image2 != null) {
        var file =
            await File("/storage/emulated/0/Download/${DateTime.now()}.png")
                .create(recursive: true);
        await file.writeAsBytes(image2);
        Fluttertoast.showToast(
            msg: "Download Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    }
  }
}

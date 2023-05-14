import 'dart:convert';
import 'dart:io';

import 'package:enQRsure/models/product.dart';
import 'package:enQRsure/models/user.dart';
import 'package:enQRsure/views/Manufacturer/manufacturergenerateqrscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../../constants.dart';

class ManufacturerHomeScreen extends StatefulWidget {
  final User user;
  const ManufacturerHomeScreen({Key? key, required this.user})
      : super(key: key);

  @override
  State<ManufacturerHomeScreen> createState() => _ManufacturerHomeScreenState();
}

class _ManufacturerHomeScreenState extends State<ManufacturerHomeScreen> {
  WidgetsToImageController widgetcontroller = WidgetsToImageController();
  var color;
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
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;
  bool _isFirstButtonSelected = true;
  var numofpage, curpage = 1;
  String titleCenter = "Loading...";
  String search = "";
  late double screenHeight, screenWidth, resWidth;
  List<Product> productList = <Product>[];
  List<Product> productList2 = <Product>[];
  final df = DateFormat('dd/MM/yyyy');
  TextEditingController searchController = TextEditingController();
  final TextEditingController prnameEditingController =
      TextEditingController();
  final TextEditingController prdescriptionEditingController =
      TextEditingController();
  final TextEditingController prtypeEditingController =
      TextEditingController();
  final TextEditingController prbarcodeEditingController =
      TextEditingController();
  final TextEditingController prdateEditingController =
      TextEditingController();
  final TextEditingController prwarrantyEditingController =
      TextEditingController();
  final TextEditingController proriginEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRecordedProduct(1, search);
    _loadRegisteredProduct(1, search);
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
        backgroundColor: const Color(0xFF90E6C3),
        title: Text(
          "Manufacturer",
          textAlign: TextAlign.center,
          style: GoogleFonts.openSans(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey.shade400,
            width: 2.0,
          ),
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    ManufacturerGenerateQRScreen(user: widget.user),
              ),
            );
          },
          backgroundColor: const Color(0xFF90E6C3),
          foregroundColor: Colors.white,
          elevation: 5,
          child: const Icon(Icons.add),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
                child: TextButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFirstButtonSelected
                        ? const Color(0xFF888D88)
                        : const Color(0xFFCED0CE),
                    side: BorderSide.none,
                  ),
                  child: Text(
                    "Recorded Products",
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () async {
                    _selectFirstButton();
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
              SizedBox(
                height: 40,
                child: TextButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFirstButtonSelected
                        ? const Color(0xFFCED0CE)
                        : const Color(0xFF888D88),
                    side: BorderSide.none,
                  ),
                  child: Text(
                    "Registered Products",
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () async {
                    _selectSecondButton();
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              children: [
                Container(
                  color: Colors.white,
                  child: productList.isEmpty
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: TextField(
                                controller: searchController,
                                decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                    child: const Icon(Icons.search,
                                        color: Colors.black),
                                    onTap: () {
                                      search = searchController.text;
                                      _loadRecordedProduct(1, search);
                                    },
                                  ),
                                  hintText: "Search Product Name",
                                  hintStyle: GoogleFonts.montserrat(
                                      fontSize: 16, color: Colors.black),
                                  border: InputBorder.none,
                                ),
                              )),
                          Expanded(
                            child: ListView.builder(
                              itemCount: productList.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 28,
                                      backgroundImage: NetworkImage(
                                        CONSTANTS.server +
                                            "/enQRsure/assets/productimages/" +
                                            productList[index]
                                                .productId
                                                .toString() +
                                            '.jpg',
                                      ),
                                    ),
                                    title: Text(
                                        productList[index]
                                            .productName
                                            .toString(),
                                        style: GoogleFonts.montserrat(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600)),
                                    subtitle: Text(
                                        productList[index]
                                            .productType
                                            .toString(),
                                        style: GoogleFonts.montserrat(
                                          fontSize: 14,
                                          color: Colors.black,
                                        )),
                                    trailing: const Icon(Icons.arrow_forward),
                                    onTap: () {
                                      loadProductDetails(index);
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
                                  color = const Color(0xFF90E6C3);
                                } else {
                                  color = Colors.black;
                                }
                                return SizedBox(
                                  width: 40,
                                  child: TextButton(
                                      onPressed: () =>
                                          {_loadRecordedProduct(index + 1, "")},
                                      child: Text(
                                        (index + 1).toString(),
                                        style: TextStyle(color: color),
                                      )),
                                );
                              },
                            ),
                          ),
                        ]),
                ),
                Container(
                  color: Colors.white,
                  child: productList2.isEmpty
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: TextField(
                                controller: searchController,
                                decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                    child: const Icon(Icons.search,
                                        color: Colors.black),
                                    onTap: () {
                                      search = searchController.text;
                                      _loadRegisteredProduct(1, search);
                                    },
                                  ),
                                  hintText: "Search Product Name",
                                  hintStyle: GoogleFonts.montserrat(
                                      fontSize: 16, color: Colors.black),
                                  border: InputBorder.none,
                                ),
                              )),
                          Expanded(
                            child: ListView.builder(
                              itemCount: productList2.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 28,
                                      backgroundImage: NetworkImage(
                                        CONSTANTS.server +
                                            "/enQRsure/assets/productimages/" +
                                            productList2[index]
                                                .productId
                                                .toString() +
                                            '.jpg',
                                      ),
                                    ),
                                    title: Text(
                                        productList2[index]
                                            .productName
                                            .toString(),
                                        style: GoogleFonts.montserrat(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600)),
                                    subtitle: Text(
                                        productList2[index]
                                            .productType
                                            .toString(),
                                        style: GoogleFonts.montserrat(
                                          fontSize: 14,
                                          color: Colors.black,
                                        )),
                                    trailing: const Icon(Icons.arrow_forward),
                                    onTap: () {
                                      loadProductDetails2(index);
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
                                  color = const Color(0xFF90E6C3);
                                } else {
                                  color = Colors.black;
                                }
                                return SizedBox(
                                  width: 40,
                                  child: TextButton(
                                      onPressed: () =>
                                          {_loadRecordedProduct(index + 1, "")},
                                      child: Text(
                                        (index + 1).toString(),
                                        style: TextStyle(color: color),
                                      )),
                                );
                              },
                            ),
                          ),
                        ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _selectFirstButton() {
    setState(() {
      _isFirstButtonSelected = true;
    });
  }

  void _selectSecondButton() {
    setState(() {
      _isFirstButtonSelected = false;
    });
  }

  void _loadRecordedProduct(int pageno, String search) {
    curpage = pageno;
    numofpage ??= 1;
    String userid = widget.user.id.toString();
    http.post(
      Uri.parse("${CONSTANTS.server}/enQRsure/php/loadmanufacturerrecordedproduct.php"),
      body: {
        'pageno': pageno.toString(),
        'search': search,
        'userid': userid,
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
        if (extractdata['products'] != null) {
          productList = <Product>[];
          extractdata['products'].forEach((v) {
            productList.add(Product.fromJson(v));
          });
        } else {
          titleCenter = "No product Available";
        }
        setState(() {});
      }
    });
  }

  void loadProductDetails(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            title: Text(
              "Product Details",
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
                      "/enQRsure/assets/productimages/" +
                      productList[index].productId.toString() +
                      '.jpg',
                  fit: BoxFit.cover,
                  width: 200,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                const SizedBox(height: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Name: ",
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(productList[index].productName.toString(),
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.black)),
                  const SizedBox(height: 10),
                  Text("Description:",
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(productList[index].productDescription.toString(),
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.black)),
                  const SizedBox(height: 10),
                  Text("Type: ",
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(productList[index].productType.toString(),
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.black)),
                  const SizedBox(height: 10),
                  Text("Barcode:",
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(productList[index].productBarcode.toString(),
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.black)),
                  const SizedBox(height: 10),
                  Text("Manufacture Date:",
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(
                      df.format(DateTime.parse(
                          productList[index].productDate.toString())),
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.black)),
                  const SizedBox(height: 10),
                  Text("Warranty:",
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(
                      "${productList[index].productWarranty} Months",
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.black)),
                  const SizedBox(height: 10),
                  Text("Origin:",
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(productList[index].productOrigin.toString(),
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
                          productList[index].productInsertDate.toString())),
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.black)),
                  const SizedBox(height: 10),
                  Align(
                      alignment: Alignment.center,
                      child: WidgetsToImage(
                        controller: widgetcontroller,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 200,
                              width: 200,
                              child: QrImage(
                                data: productList[index]
                                    .productEncryptedCode
                                    .toString(),
                                version: QrVersions.auto,
                                size: 200,
                                gapless: false,
                                embeddedImage: const AssetImage(
                                    'assets/images/enQRsure logo.png'),
                                embeddedImageStyle: QrEmbeddedImageStyle(
                                  size: const Size(40, 40),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 10),
                  Container(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: screenWidth,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          _editProductDetails(index);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF77CE80),
                            side: BorderSide.none,
                            shape: const StadiumBorder()),
                        child: const Text("Edit Product",
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
                          deleteProduct(index);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF5595D),
                            side: BorderSide.none,
                            shape: const StadiumBorder()),
                        child: const Text("Delete Product",
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
                  "Download QR Code",
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

  void _editProductDetails(int index) {
    prnameEditingController.text = productList[index].productName.toString();
    prdescriptionEditingController.text =
        productList[index].productDescription.toString();
    prtypeEditingController.text = productList[index].productType.toString();
    prbarcodeEditingController.text =
        productList[index].productWarranty.toString();
    prdateEditingController.text = productList[index].productDate.toString();
    prwarrantyEditingController.text =
        productList[index].productWarranty.toString();
    proriginEditingController.text =
        productList[index].productOrigin.toString();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: Text(
            "Edit Product Details",
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
                          "/enQRsure/assets/productimages/" +
                          productList[index].productId.toString() +
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
                    child: Column(children: [
                  TextFormField(
                    controller: prnameEditingController,
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
                        prefixIcon: const Icon(Icons.title),
                        labelText: "Product Name"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter product name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: prdescriptionEditingController,
                    minLines: 6,
                    keyboardType: TextInputType.multiline,
                    maxLines: 6,
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
                        prefixIcon: const Icon(Icons.description),
                        labelText: "Product Description"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter product description.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: prtypeEditingController,
                    decoration: InputDecoration(
                        labelText: 'Product Type',
                        prefixIcon: const Icon(LineAwesomeIcons.tags),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 2.0),
                        )),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      final String? selectedProductType =
                          await showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'Select a product type',
                              style: GoogleFonts.montserrat(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            content: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: DropdownButtonFormField<String>(
                                value: selectedItem1,
                                icon: const Icon(Icons.arrow_drop_down_circle),
                                decoration: InputDecoration(
                                    labelText: "Product Type",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                                onChanged: (String? newValue1) {
                                  setState(() {
                                    selectedItem1 = newValue1!;
                                  });
                                  Navigator.of(context).pop(newValue1);
                                },
                                items: productType.map((String value) {
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
                      if (selectedProductType != null) {
                        prtypeEditingController.text = selectedProductType;
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select a product type";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: prbarcodeEditingController,
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
                        suffixIcon: IconButton(
                          icon: const Icon(LineAwesomeIcons.barcode),
                          onPressed: () async {
                            String barcodeScanRes =
                                await FlutterBarcodeScanner.scanBarcode(
                                    "#ff6666", "Back", false, ScanMode.DEFAULT);
                            setState(() {
                              prbarcodeEditingController.text = barcodeScanRes;
                            });
                          },
                        ),
                        labelText: "Barcode"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid Barcode';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: prdateEditingController,
                    decoration: InputDecoration(
                        labelText: 'Manufacturer Date',
                        prefixIcon: const Icon(LineAwesomeIcons.calendar),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 2.0),
                        )),
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
                          prdateEditingController.text = formattedDate;
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
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: prwarrantyEditingController,
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
                        prefixIcon: const Icon(LineAwesomeIcons.check_circle),
                        labelText: "Warranty Period (months)"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter valid warranty period';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: proriginEditingController,
                    decoration: InputDecoration(
                        labelText: 'Product Origin',
                        prefixIcon: const Icon(LineAwesomeIcons.tags),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 2.0),
                        )),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      final String? selectedProductOrigin =
                          await showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'Select a origin',
                              style: GoogleFonts.montserrat(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            content: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: DropdownButtonFormField<String>(
                                value: selectedItem1,
                                icon: const Icon(Icons.arrow_drop_down_circle),
                                decoration: InputDecoration(
                                    labelText: "Product Origin",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                                onChanged: (String? newValue2) {
                                  setState(() {
                                    selectedItem2 = newValue2!;
                                  });
                                  Navigator.of(context).pop(newValue2);
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
                      if (selectedProductOrigin != null) {
                        proriginEditingController.text = selectedProductOrigin;
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select a product origin";
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
                        updateProduct(index);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF90E6C3),
                          side: BorderSide.none,
                          shape: const StadiumBorder()),
                      child: Text("Update Product",
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
                  color: const Color(0xFF90E6C3),
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

  void updateProduct(int index) async {
    String prname = prnameEditingController.text;
    String prdescription = prdescriptionEditingController.text;
    String prtype = prtypeEditingController.text;
    String prbarcode = prbarcodeEditingController.text;
    String prdate = prdateEditingController.text;
    String prwarranty = prwarrantyEditingController.text;
    String prorigin = proriginEditingController.text;
    FocusScope.of(context).requestFocus(FocusNode());

    http.post(
      Uri.parse("${CONSTANTS.server}/enQRsure/php/updateproduct.php/"),
      body: {
        "productid": productList[index].productId.toString(),
        "productname": prname,
        "productdescription": prdescription,
        "producttype": prtype,
        "productbarcode": prbarcode,
        "productdate": prdate,
        "productwarranty": prwarranty,
        "productorigin": prorigin,
      },
    ).then((response) async {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
          msg: "Product Updated Successfully",
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
        _loadRecordedProduct(1, "");
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

  void deleteProduct(int index) {
    http.post(Uri.parse("${CONSTANTS.server}/enQRsure/php/deleteproduct.php"),
        body: {"productid": productList[index].productId}).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Deleted Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        _loadRecordedProduct(1, "");
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

  void _loadRegisteredProduct(int pageno, String search) {
    curpage = pageno;
    numofpage ??= 1;
    String userid = widget.user.id.toString();
    http.post(
      Uri.parse("${CONSTANTS.server}/enQRsure/php/loadmanufacturerregisteredproduct.php"),
      body: {
        'pageno': pageno.toString(),
        'search': search,
        'userid': userid,
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
        if (extractdata['products'] != null) {
          productList2 = <Product>[];
          extractdata['products'].forEach((v) {
            productList2.add(Product.fromJson(v));
          });
        } else {
          titleCenter = "No product Available";
        }
        setState(() {});
      }
    });
  }

  void loadProductDetails2(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            title: Text(
              "Product Details",
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
                      "/enQRsure/assets/productimages/" +
                      productList2[index].productId.toString() +
                      '.jpg',
                  fit: BoxFit.cover,
                  width: 200,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                const SizedBox(height: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Name: ",
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(productList2[index].productName.toString(),
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.black)),
                  const SizedBox(height: 10),
                  Text("Description:",
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(productList2[index].productDescription.toString(),
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.black)),
                  const SizedBox(height: 10),
                  Text("Type: ",
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(productList2[index].productType.toString(),
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.black)),
                  const SizedBox(height: 10),
                  Text("Barcode:",
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(productList2[index].productBarcode.toString(),
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.black)),
                  const SizedBox(height: 10),
                  Text("Manufacture Date:",
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(
                      df.format(DateTime.parse(
                          productList2[index].productDate.toString())),
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.black)),
                  const SizedBox(height: 10),
                  Text("Warranty:",
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(
                      "${productList2[index].productWarranty} Months",
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.black)),
                  const SizedBox(height: 10),
                  Text("Origin:",
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(productList2[index].productOrigin.toString(),
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
                          productList2[index].manufacturerRegDate.toString())),
                      style: GoogleFonts.montserrat(
                          fontSize: 16, color: Colors.black)),
                  const SizedBox(height: 10),
                ])
              ],
            )),
            actions: [
              TextButton(
                child: Text(
                  "Close",
                  style: GoogleFonts.montserrat(
                      color: const Color(0xFF90E6C3),
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
}

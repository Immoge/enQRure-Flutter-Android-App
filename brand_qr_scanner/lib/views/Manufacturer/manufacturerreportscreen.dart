import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:enQRsure/constants.dart';
import 'package:enQRsure/models/counterfeitproduct.dart';
import 'package:enQRsure/models/product.dart';
import 'package:enQRsure/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';

class ManufacturerReportScreen extends StatefulWidget {
  final User user;
  const ManufacturerReportScreen({Key? key, required this.user})
      : super(key: key);

  @override
  State<ManufacturerReportScreen> createState() =>
      _ManufacturerReportScreenState();
}

class _ManufacturerReportScreenState extends State<ManufacturerReportScreen> {
  var color;
  var numofpage, curpage = 1;
  String titleCenter = "Loading...";
  String search = "";
  late double screenHeight, screenWidth, resWidth;
  List<CounterfeitProduct> counterfeitProductList = <CounterfeitProduct>[];
  final df = DateFormat('dd/MM/yyyy');
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCounterfeitReport(1, search);
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
        backgroundColor: Color(0xFF90E6C3),
        title: Text("Counterfeit Report",
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              fontSize: 25,
              fontWeight: FontWeight.w500,
            )),
      ),
      body: counterfeitProductList.isEmpty
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
                          _loadCounterfeitReport(1, search);
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
                  itemCount: counterfeitProductList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(
                            CONSTANTS.server +
                                "/enQRsure/assets/counterfeitproductimages/" +
                                counterfeitProductList[index]
                                    .cproductId
                                    .toString() +
                                '.jpg',
                          ),
                        ),
                        title: Text(
                            counterfeitProductList[index]
                                .cproductName
                                .toString(),
                            style: GoogleFonts.montserrat(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w600)),
                        subtitle: Text(
                            counterfeitProductList[index]
                                .cproductBuyername
                                .toString(),
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              color: Colors.black,
                            )),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          loadCounterfeitProductDetails(index);
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
                      color = Color(0xFF90E6C3);
                    } else {
                      color = Colors.black;
                    }
                    return SizedBox(
                      width: 40,
                      child: TextButton(
                          onPressed: () =>
                              {_loadCounterfeitReport(index + 1, "")},
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

  void _loadCounterfeitReport(int pageno, String _search) {
    curpage = pageno;
    numofpage ??= 1;
    http.post(
      Uri.parse(CONSTANTS.server + "/enQRsure/php/loadcounterfeitproduct.php"),
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
        if (extractdata['counterfeitproducts'] != null) {
          counterfeitProductList = <CounterfeitProduct>[];
          extractdata['counterfeitproducts'].forEach((v) {
            counterfeitProductList.add(CounterfeitProduct.fromJson(v));
          });
        } else {
          titleCenter = "No product Available";
        }
        setState(() {});
      }
    });
  }

  void loadCounterfeitProductDetails(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            title: Text(
              "Report Details",
              style: GoogleFonts.openSans(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            content: SingleChildScrollView(
                child: Column(children: [
              CachedNetworkImage(
                imageUrl: CONSTANTS.server +
                    "/enQRsure/assets/counterfeitproductimages/" +
                    counterfeitProductList[index].cproductId.toString() +
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
                Text(counterfeitProductList[index].cproductName.toString(),
                    style: GoogleFonts.montserrat(
                        fontSize: 16, color: Colors.black)),
                const SizedBox(height: 10),
                Text("Description:",
                    style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                Text(
                    counterfeitProductList[index]
                        .cproductDescription
                        .toString(),
                    style: GoogleFonts.montserrat(
                        fontSize: 16, color: Colors.black)),
                const SizedBox(height: 10),
                Text("Platform: ",
                    style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                Text(counterfeitProductList[index].cproductPlatform.toString(),
                    style: GoogleFonts.montserrat(
                        fontSize: 16, color: Colors.black)),
                const SizedBox(height: 10),
                Text("Origin:",
                    style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                Text(counterfeitProductList[index].cproductOrigin.toString(),
                    style: GoogleFonts.montserrat(
                        fontSize: 16, color: Colors.black)),
                const SizedBox(height: 10),
                Text("Purchase Location:",
                    style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                Text(counterfeitProductList[index].cproductLocation.toString(),
                    style: GoogleFonts.montserrat(
                        fontSize: 16, color: Colors.black)),
                const SizedBox(height: 10),
                Text("Seller:",
                    style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                Text(
                    counterfeitProductList[index].cproductSellername.toString(),
                    style: GoogleFonts.montserrat(
                        fontSize: 16, color: Colors.black)),
                const SizedBox(height: 10),
                Text("Purchase Date:",
                    style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                Text(
                    df.format(DateTime.parse(counterfeitProductList[index]
                        .cproductPurchasedate
                        .toString())),
                    style: GoogleFonts.montserrat(
                        fontSize: 16, color: Colors.black)),
                const SizedBox(height: 10),
                Text("Buyer:",
                    style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                Text(counterfeitProductList[index].cproductBuyername.toString(),
                    style: GoogleFonts.montserrat(
                        fontSize: 16, color: Colors.black)),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text("Duplicated QR:",
                          style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: QrImage(
                          data: counterfeitProductList[index]
                              .cproductEncryptedcode
                              .toString(),
                          version: QrVersions.auto,
                          size: 200,
                          gapless: false,
                          embeddedImage:
                              AssetImage('assets/images/enQRsure logo.png'),
                          embeddedImageStyle: QrEmbeddedImageStyle(
                            size: Size(40, 40),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ]),
            ])),
            actions: [
              TextButton(
                child: Text(
                  "Close",
                  style: GoogleFonts.montserrat(
                      color: Color(0xFF90E6C3),
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

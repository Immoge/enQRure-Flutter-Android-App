import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:enQRsure/constants.dart';
import 'package:enQRsure/models/product.dart';
import 'package:enQRsure/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class RetailerHomeScreen extends StatefulWidget {
  final User user;
  const RetailerHomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<RetailerHomeScreen> createState() => _RetailerHomeScreenState();
}

class _RetailerHomeScreenState extends State<RetailerHomeScreen> {
  var color;
  var numofpage, curpage = 1;
  String titleCenter = "Loading...";
  String search = "";
  late double screenHeight, screenWidth, resWidth;
  List<Product> productList = <Product>[];
  final df = DateFormat('dd/MM/yyyy');
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
        backgroundColor: const Color(0xFFFFB747),
        title: Text("Retailer",
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              fontSize: 25,
              fontWeight: FontWeight.w500,
            )),
      ),
      body: productList.isEmpty
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
                  itemCount: productList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(
                            CONSTANTS.server +
                                "/enQRsure/assets/productimages/" +
                                productList[index].productId.toString() +
                                '.jpg',
                          ),
                        ),
                        title: Text(productList[index].productName.toString(),
                            style: GoogleFonts.montserrat(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w600)),
                        subtitle:
                            Text(productList[index].productType.toString(),
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
                      color = const Color(0xFFFFB747);
                    } else {
                      color = Colors.black;
                    }
                    return SizedBox(
                      width: 40,
                      child: TextButton(
                          onPressed: () =>
                              {_loadRegisteredProduct(index + 1, "")},
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

  void _loadRegisteredProduct(int pageno, String search) {
    curpage = pageno;
    numofpage ??= 1;
    String userid = widget.user.id.toString();
    http.post(
      Uri.parse("${CONSTANTS.server}/enQRsure/php/loadretailerregisteredproduct.php"),
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
                          productList[index].retailerRegDate.toString())),
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
                      color: const Color(0xFFFFB747),
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

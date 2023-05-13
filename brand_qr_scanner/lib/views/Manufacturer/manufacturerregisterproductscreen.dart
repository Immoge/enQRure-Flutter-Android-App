import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:brand_qr_scanner/constants.dart';
import 'package:brand_qr_scanner/models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;

class ManufacturerRegisterProductScreen extends StatefulWidget {
  const ManufacturerRegisterProductScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _ManufacturerRegisterProductScreenState();
}

class _ManufacturerRegisterProductScreenState
    extends State<ManufacturerRegisterProductScreen> {
  final df = DateFormat('dd/MM/yyyy');
  Product product = Product();
  late double screenHeight, screenWidth, resWidth;
  String? barcode;
  Timer? timer;
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();

    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
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
    return SafeArea(
      child: Scaffold(
          body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          buildQrView(context),
          Positioned(bottom: 30, child: buildResult()),
          Positioned(top: 10, child: buildControlButtons()),
        ],
      )),
    );
  }

  Widget buildControlButtons() => Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: FutureBuilder<bool?>(
                  future: controller?.getFlashStatus(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return Icon(
                          snapshot.data! ? Icons.flash_on : Icons.flash_off);
                    } else {
                      return Container();
                    }
                  }),
              onPressed: () async {
                await controller?.toggleFlash();
                setState(() {});
              },
            ),
            IconButton(
              icon: FutureBuilder(
                  future: controller?.getCameraInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return Icon(Icons.switch_camera);
                    } else {
                      return Container();
                    }
                  }),
              onPressed: () async {
                await controller?.flipCamera();

                setState(() {});
              },
            )
          ],
        ),
      );

  Widget buildResult() => Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Text(
          barcode != null ? 'Result: $barcode' : 'Scan a code!',
          maxLines: 3,
          style: GoogleFonts.montserrat(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      );

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Color(0xFF90E6C3),
          borderRadius: 20,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.5,
        ),
      );

  void onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);
    controller.scannedDataStream.listen((barcode) async {
      controller.pauseCamera();
      setState(() {
        this.barcode = barcode.code;
      });
      await _loginProductInfo();
      timer?.cancel();
      timer = Timer(Duration(seconds: 3), () {
        setState(() {
          this.barcode = null;
        });
      });
    });
  }

  void _loadProductDialog(Product product) {
    if (barcode != null) {
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
                        product.productId.toString() +
                        '.jpg',
                    fit: BoxFit.cover,
                    width: 200,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/broken image icon.png',
                      fit: BoxFit.cover,
                      width: 200,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name: ",
                            style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        Text(product.productName.toString(),
                            style: GoogleFonts.montserrat(
                                fontSize: 16, color: Colors.black)),
                        const SizedBox(height: 10),
                        Text("Description:",
                            style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        Text(product.productDescription.toString(),
                            style: GoogleFonts.montserrat(
                                fontSize: 16, color: Colors.black)),
                        const SizedBox(height: 10),
                        Text("Type: ",
                            style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        Text(product.productType.toString(),
                            style: GoogleFonts.montserrat(
                                fontSize: 16, color: Colors.black)),
                        const SizedBox(height: 10),
                        Text("Barcode:",
                            style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        Text(product.productBarcode.toString(),
                            style: GoogleFonts.montserrat(
                                fontSize: 16, color: Colors.black)),
                        const SizedBox(height: 10),
                        Text("Manufacture Date:",
                            style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        Text((product.productDate.toString()),
                            style: GoogleFonts.montserrat(
                                fontSize: 16, color: Colors.black)),
                        const SizedBox(height: 10),
                        Text("Warranty:",
                            style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        Text(product.productWarranty.toString() + " Months",
                            style: GoogleFonts.montserrat(
                                fontSize: 16, color: Colors.black)),
                        const SizedBox(height: 10),
                        Text("Origin:",
                            style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        Text(product.productOrigin.toString(),
                            style: GoogleFonts.montserrat(
                                fontSize: 16, color: Colors.black)),
                        const SizedBox(height: 10),
                        Text("Registration Date:",
                            style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        Text(product.productInsertDate.toString(),
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
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF77CE80),
                                  side: BorderSide.none,
                                  shape: const StadiumBorder()),
                              child: const Text("Edit Product",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
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
                                ;
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFF5595D),
                                  side: BorderSide.none,
                                  shape: const StadiumBorder()),
                              child: const Text("Delete Product",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
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
                        color: Color(0xFF90E6C3),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    controller!.resumeCamera();
                  },
                ),
              ],
            );
          });
    }
  }

   _loginProductInfo() async {
  http.post(
    Uri.parse(CONSTANTS.server + "/enQRsure/php/loadregisterproduct.php/"),
    body: {
      "encryptedcode": barcode.toString(),
    },
  ).then((response) {
    print(response.body);
    var jsonResponse = json.decode(response.body);
    if (response.statusCode == 200 && jsonResponse['status'] == "success") {
      print(jsonResponse);
      Product product = Product.fromJson(jsonResponse['data']);
      _loadProductDialog(product); 
    } else {
      print(jsonResponse);
      Fluttertoast.showToast(
        msg: "Invalid QR Code!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 14.0,
      );
      controller!.resumeCamera();
    }
  });
}
}

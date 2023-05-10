// import 'dart:convert';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:sn_progress_dialog/sn_progress_dialog.dart';
// import 'package:intl/intl.dart';

// import '../models/course.dart';
// import '../models/user.dart';
// import '../models/cart.dart';

// import 'package:mytutor/views/profilescreen.dart';
// import 'package:mytutor/views/subscribescreen.dart';
// import 'package:mytutor/views/tutorscreen.dart';
// import 'package:mytutor/views/cartscreen.dart';
// import 'package:mytutor/views/favouritescreen.dart';
// import 'package:mytutor/constants.dart';

// class CourseScreen extends StatefulWidget {
//   final User user;
//   const CourseScreen({Key? key, required this.user}) : super(key: key);
//   @override
//   State<CourseScreen> createState() => _CourseScreenState();
// }

// class _CourseScreenState extends State<CourseScreen> {
//   List<Course> courseList = <Course>[];
//   String titlecenter = "Loading...";
//   late double screenHeight, screenWidth, resWidth;
//   final df = DateFormat('dd/MM/yyyy hh:mm a');
//   var _tapPosition;
//   var numofpage, curpage = 1;
//   var color;
//   int cart = 0;
//   String search = "";
//   TextEditingController searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _loadCourses(1, search);
//   }

//   @override
//   Widget build(BuildContext context) {
//     screenHeight = MediaQuery.of(context).size.height;
//     screenWidth = MediaQuery.of(context).size.width;
//     if (screenWidth <= 600) {
//       resWidth = screenWidth;
//     } else {
//       resWidth = screenWidth * 0.75;
//     }
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Courses'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () {
//               _loadSearchDialog();
//             },
//           ),
//           TextButton.icon(
//             onPressed: () async {
//               await Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (content) => CartScreen(
//                             user: widget.user,
//                           )));
//               _loadCourses(1, search);
//               _loadMyCart();
//             },
//             icon: const Icon(
//               Icons.shopping_cart,
//               color: Colors.black,
//             ),
//             label: Text(widget.user.cart.toString(),
//                 style: const TextStyle(color: Colors.black)),
//           )
//         ],
//       ),
//       drawer: Drawer(
//         child: ListView(
//           children: [
//             UserAccountsDrawerHeader(
//               currentAccountPicture: const CircleAvatar(
//                 radius: 50.0,
//                 backgroundColor: const Color(0xFF778899),
//                 backgroundImage: NetworkImage(
//                     "https://cdn.mos.cms.futurecdn.net/JMKgHniH4JYPch6ig2o2MM-970-80.jpg.webp"),
//               ),
//               accountName: Text(widget.user.name.toString()),
//               accountEmail: Text(widget.user.email.toString()),
//             ),
//             _createDrawerItem(
//               icon: Icons.library_books,
//               text: 'Courses',
//               onTap: () => {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (content) => CourseScreen(user: widget.user)))
//               },
//             ),
//             _createDrawerItem(
//               icon: Icons.school,
//               text: 'Tutors',
//               onTap: () => {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (content) => TutorScreen(user: widget.user)))
//               },
//             ),
//             _createDrawerItem(
//               icon: Icons.control_point,
//               text: 'Subscibe',
//               onTap: () => {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (content) => const SubscribeScreen()))
//               },
//             ),
//             _createDrawerItem(
//               icon: Icons.bookmark,
//               text: 'Favourite',
//               onTap: () => {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (content) => const FavouriteScreen()))
//               },
//             ),
//             _createDrawerItem(
//               icon: Icons.person,
//               text: 'Profile',
//               onTap: () => {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (content) => const ProfileScreen()))
//               },
//             ),
//           ],
//         ),
//       ),
//       body: courseList.isEmpty
//           ? Center(
//               child: Text(titlecenter,
//                   style: const TextStyle(
//                       fontSize: 22, fontWeight: FontWeight.bold)))
//           : Column(children: [
//               Expanded(
//                   child: GridView.count(
//                       crossAxisCount: 2,
//                       childAspectRatio: (1 / 1.5),
//                       children: List.generate(courseList.length, (index) {
//                         return InkWell(
//                           splashColor: Colors.cyan,
//                           onTap: () => {loadCourseDetails(index)},
//                           onTapDown: _storePosition,
//                           child: Card(
//                               elevation: 5,
//                               shape: RoundedRectangleBorder(
//                                 side: BorderSide(color: Colors.black, width: 2),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: Column(
//                                 children: [
//                                   Flexible(
//                                     flex: 6,
//                                     child: CachedNetworkImage(
//                                       imageUrl: CONSTANTS.server +
//                                           "/mytutor/mobile/assets/courses/" +
//                                           courseList[index]
//                                               .courseId
//                                               .toString() +
//                                           '.jpg',
//                                       height: screenHeight,
//                                       width: resWidth,
//                                       placeholder: (context, url) =>
//                                           const CircularProgressIndicator(),
//                                       errorWidget: (context, url, error) =>
//                                           const Icon(Icons.error),
//                                     ),
//                                   ),
//                                   Text(
//                                     courseList[index].courseName.toString(),
//                                     textAlign: TextAlign.center,
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Flexible(
//                                       flex: 4,
//                                       child: Column(
//                                         children: [
//                                           Row(
//                                             children: [
//                                               Expanded(
//                                                 flex: 7,
//                                                 child: Column(children: [
//                                                   Text(
//                                                     "Price: RM" +
//                                                         double.parse(courseList[
//                                                                     index]
//                                                                 .coursePrice
//                                                                 .toString())
//                                                             .toStringAsFixed(2),
//                                                     textAlign: TextAlign.left,
//                                                   ),
//                                                   Text(
//                                                     "Sessions: " +
//                                                         courseList[index]
//                                                             .courseSession
//                                                             .toString(),
//                                                     textAlign: TextAlign.left,
//                                                   ),
//                                                   Text(
//                                                     "Rating: " +
//                                                         courseList[index]
//                                                             .courseRating
//                                                             .toString(),
//                                                     textAlign: TextAlign.left,
//                                                   ),
//                                                 ]),
//                                               ),
//                                               Expanded(
//                                                   flex: 3,
//                                                   child: IconButton(
//                                                       onPressed: () {
//                                                         _addtocartDialog(index);
//                                                       },
//                                                       icon: const Icon(Icons
//                                                           .shopping_cart))),
//                                             ],
//                                           )
//                                         ],
//                                       ))
//                                 ],
//                               )),
//                         );
//                       }))),
//               SizedBox(
//                 height: 40,
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: numofpage,
//                   scrollDirection: Axis.horizontal,
//                   itemBuilder: (context, index) {
//                     if ((curpage - 1) == index) {
//                       color = Colors.cyan;
//                     } else {
//                       color = Colors.black;
//                     }
//                     return SizedBox(
//                       width: 40,
//                       child: TextButton(
//                           onPressed: () => {_loadCourses(index + 1, "")},
//                           child: Text(
//                             (index + 1).toString(),
//                             style: TextStyle(color: color),
//                           )),
//                     );
//                   },
//                 ),
//               ),
//             ]),
//     );
//   }

//   Widget _createDrawerItem(
//       {required IconData icon,
//       required String text,
//       required GestureTapCallback onTap}) {
//     return ListTile(
//       title: Row(
//         children: <Widget>[
//           Icon(icon),
//           Padding(
//             padding: const EdgeInsets.only(left: 8.0),
//             child: Text(text),
//           )
//         ],
//       ),
//       onTap: onTap,
//     );
//   }

//   void _loadCourses(int pageno, String _search) {
//     curpage = pageno;
//     numofpage ?? 1;
//     http.post(
//         Uri.parse(CONSTANTS.server + "/mytutor/mobile/php/load_course.php"),
//         body: {
//           'pageno': pageno.toString(),
//           'search': _search,
//         }).timeout(
//       const Duration(seconds: 5),
//       onTimeout: () {
//         return http.Response('Error', 408);
//       },
//     ).then((response) {
//       var jsondata = jsonDecode(response.body);
//       if (response.statusCode == 200 && jsondata['status'] == 'success') {
//         var extractdata = jsondata['data'];
//         numofpage = int.parse(jsondata['numofpage']);

//         if (extractdata['subjects'] != null) {
//           courseList = <Course>[];
//           extractdata['subjects'].forEach((v) {
//             courseList.add(Course.fromJson(v));
//           });
//         } else {
//           titlecenter = "No Course Available";
//         }
//         setState(() {});
//       }
//     });
//   }

//   loadCourseDetails(int index) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(20.0))),
//             title: const Text(
//               "Course Details",
//               style: TextStyle(),
//             ),
//             content: SingleChildScrollView(
//                 child: Column(
//               children: [
//                 CachedNetworkImage(
//                   imageUrl: CONSTANTS.server +
//                       "/mytutor/mobile/assets/courses/" +
//                       courseList[index].courseId.toString() +
//                       '.jpg',
//                   fit: BoxFit.cover,
//                   width: resWidth,
//                   placeholder: (context, url) =>
//                       const LinearProgressIndicator(),
//                   errorWidget: (context, url, error) => const Icon(Icons.error),
//                 ),
//                 Text(
//                   courseList[index].courseName.toString(),
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                       fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                   Text("Description:",
//                       style: const TextStyle(
//                           fontSize: 16, fontWeight: FontWeight.bold)),
//                   Text(courseList[index].courseDesc.toString()),
//                   Text("Price(RM): ",
//                       style: const TextStyle(
//                           fontSize: 16, fontWeight: FontWeight.bold)),
//                   Text(double.parse(courseList[index].coursePrice.toString())
//                       .toStringAsFixed(2)),
//                   Text("Sessions: ",
//                       style: const TextStyle(
//                           fontSize: 16, fontWeight: FontWeight.bold)),
//                   Text(courseList[index].courseSession.toString()),
//                   Text("Rating: ",
//                       style: const TextStyle(
//                           fontSize: 16, fontWeight: FontWeight.bold)),
//                   Text(courseList[index].courseRating.toString()),
//                 ])
//               ],
//             )),
//             actions: [
//               TextButton(
//                 child: const Text(
//                   "Close",
//                   style: TextStyle(),
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         });
//   }

//   void _storePosition(TapDownDetails details) {
//     _tapPosition = details.globalPosition;
//   }

//   void _loadSearchDialog() {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           // return object of type Dialog
//           return StatefulBuilder(
//             builder: (context, StateSetter setState) {
//               return AlertDialog(
//                 title: const Text(
//                   "Search ",
//                 ),
//                 content: SizedBox(
//                   height: screenHeight / 6,
//                   child: Column(
//                     children: [
//                       TextField(
//                         controller: searchController,
//                         decoration: InputDecoration(
//                             labelText: 'Search',
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5.0))),
//                       ),
//                       const SizedBox(height: 5),
//                       ElevatedButton(
//                         onPressed: () {
//                           search = searchController.text;
//                           Navigator.of(context).pop();
//                           _loadCourses(1, search);
//                         },
//                         child: const Text("Search"),
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         });
//   }

//   void _loadMyCart() {
//     http
//         .post(Uri.parse(
//             CONSTANTS.server + "/mytutor/mobile/php/load_mycartqty.php"))
//         .timeout(
//       const Duration(seconds: 5),
//       onTimeout: () {
//         return http.Response('Error', 408);
//       },
//     ).then((response) {
//       print(response.body);
//       var jsondata = jsonDecode(response.body);
//       if (response.statusCode == 200 && jsondata['status'] == 'success') {
//         print(jsondata['data']['carttotal'].toString());
//         setState(() {});
//       }
//     });
//   }

//   _addtocartDialog(int index) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(20.0))),
//             title: const Text(
//               "Add to cart",
//             ),
//             content: const Text("Add this course to your cart?"),
//             actions: <Widget>[
//               TextButton(
//                 child: const Text(
//                   "Yes",
//                 ),
//                 onPressed: () async {
//                   Navigator.of(context).pop();
//                   _addtoCart(index);
//                 },
//               ),
//               TextButton(
//                 child: const Text(
//                   "No",
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         });
//   }

//   void _addtoCart(int index) {
//     http.post(
//         Uri.parse(CONSTANTS.server + "/mytutor/mobile/php/insert_cart.php"),
//         body: {
//           "email": widget.user.email.toString(),
//           "subject_id": courseList[index].courseId.toString(),
//         }).timeout(
//       const Duration(seconds: 5),
//       onTimeout: () {
//         return http.Response('Error', 408);
//       },
//     ).then((response) {
//       print(response.body);
//       var jsondata = jsonDecode(response.body);
//       if (response.statusCode == 200 && jsondata['status'] == 'success') {
//         print(jsondata['data']['carttotal'].toString());
//         setState(() {
//           widget.user.cart = jsondata['data']['carttotal'].toString();
//         });
//         Fluttertoast.showToast(
//             msg: "Success",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM,
//             timeInSecForIosWeb: 1,
//             fontSize: 16.0);
//       }
//     });
//   }
// }

 _prnameEditingController.dispose();
    _prdescriptionEditingController.dispose();
    .dispose();
    _prbarcodeEditingController.dispose();
    _prdateEditingController.dispose();
    _prwarrantyEditingController.dispose();
    _proriginEditingController.dispose();
    _prencryptedcodeEditingController.dispose();

                Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: screenWidth * 0.5,
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0))),
                      child: DropdownButton(
                        value: selectedItem,
                        underline: const SizedBox(),
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: productType.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedItem = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: screenWidth * 0.5,
                    child: TextFormField(
                      controller: _prbarcodeEditingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Quantity',
                          prefixIcon: const Icon(Icons.numbers),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter valid product name';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: screenWidth * 0.5,
                    child: TextFormField(
                      controller: _prbarcodeEditingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Quantity',
                          prefixIcon: const Icon(Icons.numbers),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter valid product name';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
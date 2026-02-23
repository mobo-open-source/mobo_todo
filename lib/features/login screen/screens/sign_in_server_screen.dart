
//   @override


//   @override
//     return Scaffold(
//       body: Container(
//         height: screenheight,
//         width: screenwidth,
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Padding(
//           child: Consumer<AuthProvider>(
//               children: [
//                 Center(
//                   child: Padding(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const HugeIcon(
//                           icon: HugeIcons.strokeRoundedPencilEdit02,
//                           color: ColorConstants.mainWhite,
//                           size: 40,
//                         ),
//                         ///////////// HEADER SECTION ////////
//                         Text(
//                           'mobo todo',
//                           style: TextStyle(
//                             fontFamily: "mobofont",
//                             color: Colors.white,
//                             fontSize: 30,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 ////////SCROLL VIEW SECTION //////
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Padding(
//                       padding: EdgeInsets.only(
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "Sign In",
//                             style: GoogleFonts.montserrat(
//                               color: ColorConstants.mainWhite,
//                               fontWeight: FontWeight.w600,
//                               fontSize: 25,
//                             ),
//                           ),
//                           Text(
//                             "Confgure your server connection",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 15,
//                               fontWeight: FontWeight.w300,
//                             ),
//                           ),
//                           //-------------------------------------------------------//
//                           ///////////////// ENTER THE SERVER ADDRESS /////////
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 15,
//                               vertical: 5,
//                             ),
//                             decoration: BoxDecoration(
//                               boxShadow: const [
//                                 BoxShadow(
//                                   color: Colors.white,
//                                 ),
//                               ],
//                               color: ColorConstants.mainWhite,
//                             ),

//                             child: Row(
//                               children: [
//                                 HugeIcon(
//                                   icon: HugeIcons.strokeRoundedServerStack01,
//                                   color: Colors.grey.shade600,
//                                 ),
//                                 // --------------------------------------------//
//                                 ///////// SELECT NETWORK DROPDOWN /////
//                                 DropdownButtonHideUnderline(
//                                   child: DropdownButton2<String>(
//                                     iconStyleData: const IconStyleData(
//                                       icon: HugeIcon(
//                                         icon:
//                                             HugeIcons.strokeRoundedArrowDown01,
//                                         size: 17,
//                                       ),
//                                     ),
//                                       return DropdownMenuItem<String>(
//                                         value: item,
//                                     value: value.selectedAdress,


//                                       String address = serverController.text
//                                           .replaceAll(RegExp(r'https://'), '')
//                                           .replaceAll(RegExp(r'http://'), '');



//                                       value.selectedAddres(
//                                         v,
//                                         serverAddr,
//                                         context,
//                                         serverController.text,

//                                       if (serverController.text.isNotEmpty &&
//                                           serverAddr ==
//                                         value.dabaseConnection(
//                                           serverAddr,
//                                           context,
//                                         value.databaeError =
//                                     },
//                                   ),
//                                 ), //// DROP DOWN END

//                                 SizedBox(
//                                   height: screenheight * 0.050,
//                                   child: const VerticalDivider(
//                                     indent: 1,
//                                     endIndent: 1,
//                                     thickness: 1,
//                                   ),
//                                 ),

//                                 /////// SERVER ADDRESS TEXTFORM FIELD ///////
//                                 Expanded(
//                                   child: CustomeTextForm(
//                                       final address = serverController.text
//                                           .replaceAll(RegExp(r'https://'), '')
//                                           .replaceAll(RegExp(r'http://'), '');

//                                         value.dabaseConnection(
//                                           serverAddress,
//                                           context,
//                                     },
//                                     controller: serverController,
//                                     false,
//                                     hintText: "Enter Server Address",
//                                     hintcolor: Colors.grey.shade700,
//                                   ),
//                                 ),

//                                 ///////////////// SERVER ADDRESS SUFFIX LOADING ////
//                                 value.dbLoading
//                                     ? SizedBox(
//                                         height: 20,
//                                         width: 20,
//                                         child: CircularProgressIndicator(
//                                           color: Colors.black87,
//                                           strokeWidth: 2.0,
//                                         ),
//                                       )

//                                 /////// SERVER SUFFIX ERROR SHOW
//                                 if (homeProvider.isTapped ==
//                                     true & serverController.text.isEmpty)
//                                   HugeIcon(
//                                     icon: HugeIcons.strokeRoundedAlertCircle,
//                                     size: 17,
//                                     color: ColorConstants.mainRed,
//                                   ),
//                               ],
//                             ),
//                           ),
//                           //////// SERVER EXCEPTION HANDLING
//                           if (value.databaeError != null &&
//                               serverController.text.isNotEmpty)
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   child: HugeIcon(
//                                     icon: HugeIcons.strokeRoundedAlertCircle,

//                                     color: ColorConstants.mainWhite,
//                                     size: 15,
//                                   ),
//                                 ),

//                                 Expanded(
//                                   child: Text(
//                                     value.databaeError!,
//                                     style: TextStyle(
//                                       color: ColorConstants.mainWhite,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           if (homeProvider.isTapped == true &&
//                               serverController.text.isEmpty)
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   child: HugeIcon(
//                                     icon: HugeIcons.strokeRoundedAlertCircle,
//                                     size: 14,
//                                     color: ColorConstants.mainWhite,
//                                   ),
//                                 ),


//                                 Expanded(
//                                   child: Text(
//                                     "Please enter a server URL first.",
//                                     style: TextStyle(
//                                       color: ColorConstants.mainWhite,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),


//                           ///////   please select database section /////////
//                           if (value.database.isNotEmpty &&
//                               value.databaeError == null)
//                             Container(
//                               child: DropdownButtonFormField2<String>(
//                                 isExpanded: true,

//                                 value: value.database.first,

//                                 items: value.database
//                                     .map(
//                                       (db) => DropdownMenuItem<String>(
//                                         value: db,
//                                         child: Text(
//                                           db,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ),
//                                     )

//                                 },

//                                 dropdownStyleData: DropdownStyleData(
//                                   maxHeight: 200,
//                                   decoration: BoxDecoration(
//                                     color: ColorConstants.mainWhite,
//                                   ),
//                                 ),
//                                 iconStyleData: const IconStyleData(
//                                   icon: HugeIcon(
//                                     icon: HugeIcons.strokeRoundedArrowDown01,
//                                     size: 15,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 decoration: InputDecoration(
//                                   prefixIcon: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       HugeIcon(
//                                         icon: HugeIcons.strokeRoundedDatabase02,
//                                         size: 22,
//                                       ),
//                                     ],
//                                   ),
//                                   prefixIconConstraints: BoxConstraints(
//                                     minWidth: 0,
//                                   ),
//                                   border: OutlineInputBorder(
//                                     borderSide: BorderSide.none,
//                                   ),
//                                   isDense: true,
//                                   filled: true,
//                                   fillColor: ColorConstants.mainWhite,

//                                   contentPadding: const EdgeInsets.symmetric(
//                                     horizontal: 12,
//                                     vertical: 20,
//                                   ),
//                                 ),
//                               ),
//                             ),

//                           // Column(
//                           //   children: [
//                           //     InkWell(
//                           //       },
//                           //       child: Container(
//                           //         constraints: const BoxConstraints(
//                           //           maxWidth: 700,
//                           //         ),
//                           //         padding: EdgeInsets.symmetric(
//                           //           horizontal: 10,
//                           //           vertical: 20,
//                           //         ),
//                           //         decoration: BoxDecoration(
//                           //           boxShadow: const [
//                           //             BoxShadow(
//                           //               color: Colors.white,
//                           //             ),
//                           //           ],
//                           //           color: ColorConstants.mainWhite,
//                           //         ),
//                           //         child: Row(
//                           //           children: [
//                           //             HugeIcon(
//                           //               icon:
//                           //                   HugeIcons.strokeRoundedDatabase02,
//                           //               color: Colors.grey.shade600,
//                           //             ),
//                           //             Expanded(
//                           //               child: Text(
//                           //                 value.selectedDatabase.isEmpty
//                           //                     ? value.database.first
//                           //                     : value.selectedDatabase,
//                           //               ),
//                           //             ),

//                           //             HugeIcon(
//                           //               icon: HugeIcons
//                           //                   .strokeRoundedArrowDown01,
//                           //             ),
//                           //           ],
//                           //         ),
//                           //       ),
//                           //     ),
//                           //   ],
//                           // ),

//                           ////////. VISIBLE DATABASE LIST //////
//                           //   ...List.generate(
//                           //     value.database.length,
//                           //     (index) => DatabaseList(
//                           //         value.selctedDatabase(
//                           //           value.database[index],
//                           //           context,
//                           //       },
//                           //       screenwidth: screenwidth,

//                           //       database: value.database[index],
//                           //     ),
//                           //   ),


//                           ////////// NEXT BUTTON  ////////
//                           InkWell(
//                             splashColor: Colors.transparent,
//                             highlightColor: Colors.transparent,
//                               final address = serverController.text
//                                   .replaceAll(RegExp(r'https://'), '')
//                                   .replaceAll(RegExp(r'http://'), '');


//                                 serverAddr,
//                                 context,
//                                 value.selectedDatabase,

//                             },
//                             child: Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 10,
//                                 vertical: 15,
//                               ),
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 color: value.database.isEmpty
//                                     ? Colors.black26
//                                     : Colors.black,

//                               ),
//                               child: Center(
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Center(
//                                       child: Text(
//                                         "Next",
//                                         style: TextStyle(
//                                           color: ColorConstants.mainWhite,
//                                           fontSize: 16,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),

//     super.key,
//     required this.screenwidth,
//     required this.database,
//     this.onTap,


//   @override
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           boxShadow: const [
//           ],
//           color: ColorConstants.mainWhite,
//         ),
//         child: Row(
//           children: [


//             ////////////////// choose database section dropdown  ////////
//           ],
//         ),
//       ),

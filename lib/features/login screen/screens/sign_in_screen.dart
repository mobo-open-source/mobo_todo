

//   @override
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         leading: InkWell(
//           },
          
//           //  HugeIcon(
//           //   icon: HugeIcons.strokeRoundedArrowLeft01,
//           //   color: ColorConstants.mainWhite,
//           // size: 20
//           // ),
//         ),

//         backgroundColor: Colors.transparent,
//       ),
//       body: Container(
//         height: screenheight,
//         width: screenwidth,
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             fit: BoxFit.cover,
//           ),
//         ),

//         child: Padding(

//           child: Column(
//             children: [
//               ///// HEADER SECTION ///
//               Padding(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     HugeIcon(
//                       icon: HugeIcons.strokeRoundedPencilEdit02,
//                       color: ColorConstants.mainWhite,
//                       size: 40,
//                     ),
//                     Text(
//                       'mobo todo',
//                       style: TextStyle(
//                         fontFamily: "mobofont",
//                         color: Colors.white,
//                         fontSize: 30,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Consumer<AuthProvider>(
//                       key: formkey,
//                       child: Padding(
//                         padding: EdgeInsetsGeometry.only(
//                         ),
//                         child: Column(
//                           children: [
//                             Text(
//                               "Sign In",
//                               style: GoogleFonts.montserrat(
//                                 color: ColorConstants.mainWhite,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 25,
//                               ),
//                             ),
//                             Text(
//                               "Enter your credentials to continue",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w300,
//                               ),
//                             ),
//                             ////////// EMAIL CONTAINER /////
//                             Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 10,
//                                 vertical: 5,
//                               ),
//                               decoration: BoxDecoration(
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.white,
//                                   ),
//                                 ],
//                                 color: ColorConstants.mainWhite,
//                               ),
//                               child: Row(
//                                 children: [

//                                   ////// EMAIL TEXTFORM FIELD ///
//                                   Expanded(
//                                     child: TextFormField(
//                                       controller: emailController,
//                                       },

//                                       },
//                                       decoration: InputDecoration(
//                                         border: InputBorder.none,
//                                         focusedBorder: InputBorder.none,
//                                         hintText: "Email",
//                                         hintStyle: TextStyle(
//                                           color: Colors.grey.shade600,
//                                         ),
//                                       ),
//                                     ),
//                                   ),

//                                   homeprovider.emptyEmail
//                                       ? HugeIcon(
//                                           icon: HugeIcons
//                                               .strokeRoundedAlertCircle,
//                                           color: ColorConstants.mainRed,
//                                         )
//                                 ],
//                               ),
//                             ),
//                             //// email visibility section ////
//                             Visibility(
//                               visible: homeprovider.emptyEmail,
//                               child: Row(
//                                 children: [
//                                   Text(
//                                     "Email is required",
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             ////////// PASSWORD SECTION //////
//                             Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 10,
//                                 vertical: 5,
//                               ),
//                               decoration: BoxDecoration(
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.white,
//                                   ),
//                                 ],
//                                 color: ColorConstants.mainWhite,
//                               ),
//                               child: Row(
//                                 children: [
//                                   HugeIcon(
//                                     icon: HugeIcons.strokeRoundedLockPassword,
//                                   ),

//                                   ///////////////// TEXT FIELD //////
//                                   Expanded(
//                                     child: TextFormField(
//                                       },
//                                       controller: passwordController,
//                                       obscureText: homeprovider.isVisible,
//                                       },
//                                       decoration: InputDecoration(
//                                         border: InputBorder.none,
//                                         focusedBorder: InputBorder.none,
//                                         hintText: "Password",
//                                         hintStyle: TextStyle(
//                                           color: Colors.grey.shade600,
//                                         ),
//                                       ),
//                                     ),
//                                   ),

//                                   homeprovider.emptyPass
//                                       ? 
//                                     HugeIcon(
//                                           icon: HugeIcons
//                                               .strokeRoundedAlertCircle,
//                                               color: ColorConstants.mainRed,
//                                     )  
//                                       : InkWell(
//                                           },
//                                           child: homeprovider.isVisible
//                                               ? Icon(
//                                                   Icons.visibility_off,
//                                                   color: Colors.grey.shade600,
//                                                 )
//                                               : Icon(
//                                                   Icons.visibility,
//                                                   color: Colors.grey.shade600,
//                                                 ),
//                                         ),
//                                 ],
//                               ),
//                             ),

//                             Visibility(
//                               visible: homeprovider.emptyPass,
//                               child: Row(
//                                 children: [
//                                   Text(
//                                     "Password is required",
//                                   ),
//                                 ],
//                               ),
//                             ),

//                             //////////   forgot Password //////
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 InkWell(
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                       ),
//                                   },
//                                   child: Text(
//                                     "forgot password?",
//                                     style: TextStyle(
//                                       color: ColorConstants.mainWhite,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),

//                             Visibility(
//                               visible: homeprovider.credentialsError,
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     Icons.error_outline_outlined,
//                                     color: ColorConstants.mainWhite,
//                                     size: 15,
//                                   ),

//                                   Text(
//                                     "Login failed.Please check your credentials",
//                                     style: TextStyle(
//                                       color: ColorConstants.mainWhite,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),

//                             InkWell(
//                               splashColor: Colors.transparent,
//                               highlightColor: Colors.transparent,
//                                 context
//                                         .selectedScreen =
//                                   if (emailController.text.isEmpty ||
//                                     dbName: dbname,
//                                     serverUrl: server,
//                                     context: context,
//                                     email: emailController.text,
//                                     password: passwordController.text,
//                               },
//                               child: Container(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: 10,
//                                   vertical: 15,
//                                 ),
//                                 width: double.infinity,
//                                 decoration: BoxDecoration(
//                                   color: homeprovider.isLoading
//                                       ? Colors.black26
//                                       : Colors.black,

//                                 ),
//                                 child: Center(
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Center(
//                                         child: Text(
//                                           "Sign In",
//                                           style: TextStyle(
//                                             color: ColorConstants.mainWhite,
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),

//                                       homeProvider.isLoading
//                                           ? LoadingAnimationWidget.staggeredDotsWave(
//                                               color: Colors.white,
//                                               size: 18,
//                                             )
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),

//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),


//   @override
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         leading: InkWell(
//           },
//           child: Icon(
//             Icons.arrow_back_ios_new_outlined,
//             color: ColorConstants.mainWhite,
//           ),
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

//         child: Center(
//           child: SingleChildScrollView(
//             child: Padding(
//               child: Consumer<AuthProvider>(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       HugeIcon(
//                         icon: HugeIcons.strokeRoundedLockPassword,
//                         color: ColorConstants.mainWhite,
//                         size: 50,
//                       ),

//                       Text(
//                         "Reset Password",
//                         style: GoogleFonts.montserrat(
//                           color: ColorConstants.mainWhite,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 25,
//                         ),
//                       ),
//                       Text(
//                         "Enter your email address and we'll send you a link to reset your password ",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w300,
//                         ),
//                       ),
//                       Text(
//                         "Server : http:// 9141808181odoo.com",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w300,
//                         ),
//                       ),

//                       ////////  Email section //////
//                       CustomeTextField(
//                         controller: emailController,
//                         obsecure: false,

//                         hintText: "Email Address",
//                         suffixIconColor: Colors.red,
//                         prefixIcon: Icons.email_outlined,
//                         suffixIcons: Icons.error_outline_outlined,
//                         screenwidth: screenwidth,
//                       ),


//                       loginButton(
//                         color: ColorConstants.mainBlack,
//                         title: "Send",
                       
//                         },
//                       ),

//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),


//     super.key,
//     required this.screenwidth,
//     required this.prefixIcon,
//     required this.hintText,
//     required this.suffixIcons,
//     required this.suffixIconColor,
//     required this.obsecure,
//     required this.controller,

//   @override
//     return Container(
//       decoration: BoxDecoration(
//         color: ColorConstants.mainWhite,
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: CustomeTextForm(
//               controller: controller,
//               obsecure,
//               hintText: hintText,
//               hintcolor: Colors.grey.shade700,
//             ),
//           ),
//         ],
//       ),
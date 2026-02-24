
//     super.key,
//     required this.deadline,
//     required this.title,
//     required this.description,
//   @override


//   late TextEditingController deadlinecontroller = TextEditingController(
//     text: widget.deadline,
//   late TextEditingController titleController = TextEditingController(
//     text: widget.title,
//   late TextEditingController descriptionController = TextEditingController(




//       final addTaskProvider = Provider.of<AddTaskProvider>(
//         context,
//         listen: false,

//   @override
//   @override
//     return GestureDetector(
//       },
//       child: Scaffold(
//         backgroundColor: ColorConstants.backgroundWhite,
//         appBar: AppBar(
//           backgroundColor: ColorConstants.backgroundWhite,
//           centerTitle: true,
//           title: Text(
//             "Edit Task",
//             style: TextStyle(
//               color: ColorConstants.mainBlack,
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//             ),
//           ),
//           leading: IconButton(
//             icon: HugeIcon(
//               icon: HugeIcons.strokeRoundedArrowLeft01,
//               color: ColorConstants.mainBlack,
//             ),
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             child: Consumer<AddTaskProvider>(

//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.shade200,
//                             blurRadius: 10,
//                           ),
//                         ],
//                         color: ColorConstants.mainWhite,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 15,
//                               vertical: 10,
//                             ),
//                             child: Text(
//                               "Task Details",
//                               style: TextStyle(
//                                 color: ColorConstants.mainBlack,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 15,
//                               vertical: 10,
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "Task Title",
//                                 ),
//                                 ////// title form /////
//                                 CustomeEditForm(
//                                   focusNode: titleNode,
//                                   controller: titleController,
//                                 ),

//                                 Text(
//                                   "Assignees",
//                                 ),

//                                 Column(
//                                   children: [
//                                     Container(
//                                       constraints: const BoxConstraints(
//                                         minHeight: 40,
//                                       ),
//                                       padding: EdgeInsets.symmetric(
//                                         horizontal: 5,
//                                         vertical: 8,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color:
//                                             ColorConstants.textFieldFillColor,
//                                         border: Border.all(
//                                           color:
//                                               userNode.hasFocus &&
//                                                   addtaskProvider.isRead ==
//                                                       false
//                                               ? ColorConstants.primaryRed
//                                               : Colors.transparent,
//                                           width: userNode.hasFocus ? 1 : 1,
//                                         ),
//                                       ),
//                                       child: Wrap(
//                                         spacing: 6,
//                                         runSpacing: 6,
//                                         children: [
//                                           // --------------------- Selected Users area ---------------------
//                                           ...addtaskProvider.selectedUserItems
//                                                 return Padding(
//                                                   padding: const EdgeInsets.all(
//                                                     4.0,
//                                                   ),
//                                                   child: Container(
//                                                     padding:
//                                                         EdgeInsets.symmetric(
//                                                           horizontal: 10,
//                                                           vertical: 5,
//                                                         ),
//                                                     decoration: BoxDecoration(
//                                                       color:
//                                                           Colors.blue.shade100,
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                             20,
//                                                           ),
//                                                       boxShadow: [
//                                                         if (!isDarkTheme)
//                                                           BoxShadow(
//                                                             color: Colors.grey,
//                                                             blurRadius: 2,
//                                                             offset: Offset(
//                                                               0,
//                                                               2,
//                                                             ),
//                                                           ),
//                                                       ],
//                                                     ),
//                                                     child: SelectedItemWidget(
//                                                       imageFile: item.image1920,
//                                                         if (addtaskProvider
//                                                                 .isRead ==
//                                                           addtaskProvider
//                                                               .removeSelection(
//                                                                 item.name,
//                                                       },
//                                                       showImage: true,
//                                                       title: item.name,
//                                                     ),
//                                                   ),
//                                               }),
//                                           // --------------------- TypeAhead Field ---------------------
//                                           SizedBox(
//                                             width: double.infinity,
//                                             child: TypeAheadField<UserModel>(
//                                               decorationBuilder:
//                                                     return Material(
//                                                       type: MaterialType.card,
//                                                       elevation: 4,
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                             8,
//                                                           ),
//                                                       child: child,
//                                                   },
//                                               constraints: BoxConstraints(
//                                                 maxHeight: 500,
//                                               ),
//                                               suggestionsCallback:
//                                                     return addtaskProvider
//                                                                 .isRead ==
//                                                             false
//                                                         ? addtaskProvider
//                                                               .getUsername(
//                                                                 search,
//                                                               )
//                                                   },
//                                                 return Container(
//                                                   child: TextField(
//                                                     readOnly:
//                                                         addtaskProvider.isRead,
//                                                       addtaskProvider
//                                                     },
//                                                     controller: controller,
//                                                     focusNode: node,
//                                                     decoration: InputDecoration(
//                                                       focusedBorder:
//                                                           InputBorder.none,
//                                                       hintText:
//                                                           addtaskProvider
//                                                               .selectedUserItems
//                                                               .isEmpty
//                                                           ? "Add assignees"
//                                                           : "",
//                                                       border: InputBorder.none,
//                                                     ),
//                                                     style: TextStyle(
//                                                       color: isDarkTheme
//                                                           ? ColorConstants
//                                                                 .mainWhite
//                                                           : ColorConstants
//                                                                 .mainBlack,
//                                                     ),
//                                                   ),
//                                               },
//                                                 final isSelected =
//                                                     addtaskProvider
//                                                         .selectedUserItems
//                                                         .any(
//                                                           (u) =>
//                                                               u.id ==
//                                                               suggestion.id,
//                                                 return Container(
//                                                   decoration: BoxDecoration(
//                                                     color: ColorConstants
//                                                         .mainWhite,
//                                                   ),
//                                                   child: ListTile(
//                                                     title: Text(
//                                                       suggestion.name,
//                                                       style: TextStyle(
//                                                         color: ColorConstants
//                                                             .mainBlack,
//                                                       ),
//                                                     ),
//                                                     trailing: isSelected
//                                                         ? HugeIcon(
//                                                             icon: HugeIcons
//                                                                 .strokeRoundedTick02,
//                                                             color: Colors.green,
//                                                           )
//                                                         : null,
//                                                       addtaskProvider
//                                                           .checkUserItem(
//                                                             suggestion,
//                                                     },
//                                                   ),
//                                               },
//                                                 return Container(
//                                                   width: double.infinity,
//                                                   decoration: BoxDecoration(
//                                                     color: ColorConstants
//                                                         .mainWhite,
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                           8,
//                                                         ),
//                                                   ),
//                                                   child: Text(
//                                                     "No results found",
//                                                     style: TextStyle(
//                                                       color: ColorConstants
//                                                           .primaryRed,
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                     ),
//                                                   ),
//                                               },
//                                                 addtaskProvider.checkUserItem(
//                                                   value,
//                                               },
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),

//                                 Text(
//                                   "Deadline Date",
//                                 ),
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 10,
//                                     vertical: 12,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: ColorConstants.textFieldFillColor,
//                                   ),
//                                   child: Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: [
//                                       HugeIcon(
//                                         icon: HugeIcons.strokeRoundedCalendar01,
//                                         size: 18,
//                                         color: Colors.grey.shade500,
//                                       ),
//                                       Expanded(
//                                         child: TextFormField(
//                                           readOnly: true,
//                                             final pickedDate = await showDatePicker(
//                                                 return Theme(
//                                                   data: ThemeData(
//                                                     colorScheme:
//                                                         ColorScheme.light(
//                                                           primary:
//                                                               ColorConstants
//                                                                   .primaryRed,
//                                                           onPrimary:
//                                                               Colors.white,
//                                                           onSurface:
//                                                               Colors.black,
//                                                         ),
//                                                     textButtonTheme:
//                                                         TextButtonThemeData(
//                                                           style: TextButton.styleFrom(
//                                                             foregroundColor:
//                                                                 ColorConstants
//                                                                     .primaryRed,
//                                                           ),
//                                                         ),
//                                                   ),
//                                                   child: child!,
//                                               },
//                                               context: context,
//                                               // initialDate: addtaskProvider.getInitialdate(
//                                               //   deadlinecontroller.text,
//                                               // ),
//                                             final pickedTime = await showTimePicker(
//                                                 return Theme(
//                                                   data: ThemeData(
//                                                     colorScheme:
//                                                         ColorScheme.light(
//                                                           primary:
//                                                               ColorConstants
//                                                                   .primaryRed,
//                                                           onPrimary:
//                                                               ColorConstants
//                                                                   .mainWhite,
//                                                           onSurface:
//                                                               ColorConstants
//                                                                   .mainBlack,
//                                                         ),
//                                                     textButtonTheme:
//                                                         TextButtonThemeData(
//                                                           style: TextButton.styleFrom(
//                                                             foregroundColor:
//                                                                 ColorConstants
//                                                                     .primaryRed,
//                                                           ),
//                                                         ),
//                                                   ),
//                                                   child: child!,
//                                               },
//                                               context: context,
//                                             final finalDateTime = DateTime(
//                                               pickedDate.year,
//                                               pickedDate.month,
//                                               pickedDate.day,
//                                               pickedTime.hour,
//                                               pickedTime.minute,
//                                             // Format
//                                             final formatted =
//                                             final formattedDate = DateFormat(
//                                               'MMM dd, yyyy',

//                                             final uiFormatted = DateFormat(
//                                               'MMM dd, yyyy hh:mm a',
//                                             deadlinecontroller.text =
//                                           },
//                                           controller: deadlinecontroller,
//                                           style: TextStyle(
//                                             color: ColorConstants.mainBlack,
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                           textAlignVertical:
//                                               TextAlignVertical.center,
//                                           decoration: const InputDecoration(
//                                             focusedBorder: InputBorder.none,
//                                             isDense: true,
//                                             border: InputBorder.none,
//                                             contentPadding: EdgeInsets.zero,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Text(
//                                   "Tags",
//                                 ),

//                                 Consumer<TagProvider>(
//                                     return Column(
//                                       children: [
//                                         Container(
//                                           padding: EdgeInsets.symmetric(
//                                             horizontal: 10,
//                                             vertical: 8,
//                                           ),
//                                           decoration: BoxDecoration(
//                                             color: ColorConstants
//                                                 .textFieldFillColor,
//                                             border: Border.all(
//                                               color:
//                                                   tagNode.hasFocus &&
//                                                       addtaskProvider.isRead ==
//                                                           false
//                                                   ? ColorConstants.primaryRed
//                                                   : Colors.transparent,
//                                             ),
//                                             borderRadius: BorderRadius.circular(
//                                               10,
//                                             ),
//                                           ),
//                                           child: Wrap(
//                                             spacing: 6,
//                                             runSpacing: 6,
//                                             children: [
//                                               ...tagProvider.selectedTagItems.map((
//                                                 item,
//                                                 return Padding(
//                                                   padding: const EdgeInsets.all(
//                                                     8.0,
//                                                   ),
//                                                   child: Container(
//                                                     decoration: BoxDecoration(
//                                                       boxShadow: [
//                                                         if (!isDarkTheme)
//                                                           BoxShadow(
//                                                             color: Colors.grey,
//                                                             blurRadius: 2,
//                                                             offset: Offset(
//                                                               0,
//                                                               2,
//                                                             ),
//                                                           ),
//                                                       ],
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                             20,
//                                                           ),
//                                                       color:
//                                                           Colors.blue.shade100,
//                                                     ),
//                                                     padding:
//                                                         EdgeInsets.symmetric(
//                                                           horizontal: 10,
//                                                           vertical: 5,
//                                                         ),
//                                                     child: SelectedItemWidget(
//                                                       showImage: false,

//                                                         if (addtaskProvider
//                                                                 .isRead ==
//                                                           tagProvider
//                                                               .removeTagSelection(
//                                                                 item.name,
//                                                       },
//                                                       title: item.name,
//                                                     ),
//                                                   ),
//                                               SizedBox(
//                                                 width: double.infinity,
//                                                 child: TypeAheadField<TaskTag>(
//                                                   decorationBuilder:
//                                                         return Material(
//                                                           type:
//                                                               MaterialType.card,
//                                                           elevation: 4,
//                                                           borderRadius:
//                                                               BorderRadius.circular(
//                                                                 8,
//                                                               ),
//                                                           child: child,
//                                                       },
//                                                   constraints: BoxConstraints(
//                                                     maxHeight: 500,
//                                                   ),
//                                                   suggestionsCallback:
//                                                         return addtaskProvider
//                                                                     .isRead ==
//                                                                 false
//                                                             ? tagProvider
//                                                                   .getTags(
//                                                                     search,
//                                                                   )
//                                                       },
//                                                     return TextField(
//                                                       readOnly: addtaskProvider
//                                                           .isRead,
//                                                         tagProvider.searchTags(
//                                                           value,
//                                                       },
//                                                       controller: controller,
//                                                       focusNode: tagNode,
//                                                       decoration: InputDecoration(
//                                                         hintStyle: TextStyle(
//                                                           fontSize: 13,
//                                                         ),
//                                                         focusedBorder:
//                                                             InputBorder.none,

//                                                         hintText:
//                                                             tagProvider
//                                                                 .selectedTagItems
//                                                                 .isEmpty
//                                                             ? "Select Tags"
//                                                             : "",
//                                                         border:
//                                                             InputBorder.none,
//                                                       ),
//                                                   },
//                                                     return Column(
//                                                       children: [
//                                                         InkWell(
//                                                             tagProvider.SelectTag(
//                                                               suggestion,
//                                                           },
//                                                           child: Container(
//                                                             decoration: BoxDecoration(
//                                                               color:
//                                                                   ColorConstants
//                                                                       .mainWhite,
//                                                             ),
//                                                             child: ListTile(
//                                                               title: Text(
//                                                                 suggestion.name,
//                                                                 style: TextStyle(
//                                                                   color: ColorConstants
//                                                                       .mainBlack,
//                                                                 ),
//                                                               ),
//                                                               trailing:
//                                                                   tagProvider
//                                                                       .selectedTagItems
//                                                                       .any(
//                                                                         (u) =>
//                                                                             u.id ==
//                                                                             suggestion.id,
//                                                                       )
//                                                                   ? Icon(
//                                                                       Icons
//                                                                           .check,
//                                                                       color: Colors
//                                                                           .green,
//                                                                     )
//                                                                   : null,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                   },
//                                                     return Container(
//                                                       width: double.infinity,
//                                                       padding: EdgeInsets.all(
//                                                         15,
//                                                       ),
//                                                       decoration: BoxDecoration(
//                                                         color: ColorConstants
//                                                             .mainWhite,
//                                                         borderRadius:
//                                                             BorderRadius.circular(
//                                                               8,
//                                                             ),
//                                                       ),
//                                                       child: Text(
//                                                         "No results found",
//                                                         style: TextStyle(
//                                                           color: ColorConstants
//                                                               .primaryRed,
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                         ),
//                                                       ),
//                                                   },

//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                   },
//                                 ),

//                                 Text(
//                                   "Task Description",
//                                 ),
//                                 CustomeEditForm(
//                                   maxLines: 4,
//                                   focusNode: discriptionNode,
//                                   controller: descriptionController,
//                                 ),

//                                 Row(
//                                   children: [
//                                     Text(
//                                       "Priority",
//                                       style: TextStyle(
//                                         color: isDarkTheme
//                                             ? ColorConstants.mainWhite
//                                             : Colors.grey.shade600,
//                                       ),
//                                     ),
//                                     Row(
//                                         return InkWell(
//                                             if (addtaskProvider.isRead ==
//                                           },
//                                           child: index <= provider.selectedIndex
//                                               ? Icon(
//                                                   Icons.star,
//                                                   color: Colors.yellow.shade600,
//                                                 )
//                                               : Icon(
//                                                   Icons.star_border_sharp,
//                                                   color: Colors.grey,
//                                                 ),
//                                       }),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//               },
//             ),
//           ),
//         ),
//       ),

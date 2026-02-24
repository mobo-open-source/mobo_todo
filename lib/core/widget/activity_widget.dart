import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:mobo_todo/core/utils/color_constants.dart';
import 'package:mobo_todo/features/activity%20screen/provider/activity_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class Activity_Widget extends StatelessWidget {
  final bool isDarkmode;
  final int? activityId;
  final String? deadline;
  final String? summary;
  final String? note;
  final String? resmodel;
  final String activityTypeName;
  final String assignees;
  final String state;
  const Activity_Widget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    this.summary,
    this.note,
    required this.resmodel,
    required this.activityTypeName,
    required this.assignees,
    required this.state,
    this.deadline,
    this.activityId,
    required this.isDarkmode,
  });
  final double screenWidth;
  final double screenHeight;
  @override
  Widget build(BuildContext context) {
    final parsedDate = DateTime.parse(deadline!);
    final homeProvider = Provider.of<ActivityProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: 
           Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  if (!isDarkmode)
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.grey.shade300,
                      offset: Offset(0, 1),
                    ),
                ],
                color: isDarkmode
                    ? ColorConstants.Grey800
                    : ColorConstants.mainWhite,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              summary ?? "",
                              style: TextStyle(
                                color: isDarkmode
                                    ? ColorConstants.mainWhite
                                    : ColorConstants.primaryRed,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                        
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              // border: BoxBorder.all(
                              //   width: 0.5,
                              //   color: state == "planned"
                              //       ? Colors.green
                              //       : state == "today"
                              //       ? Colors.orange
                              //       : ColorConstants.mainRed,
                              // ),
                              color: state == "planned"
                                  ? isDarkmode
                                        ? ColorConstants.grey300
                                        : Colors.green.shade50
                                  : state == "today"
                                  ? isDarkmode
                                        ? ColorConstants.grey300
                                        : Colors.orange.shade50
                                  : isDarkmode
                                  ? ColorConstants.grey300
                                  : Colors.red.shade50,
                            ),
                            child: Text(
                              state,
                              style: TextStyle(
                                color: state == "planned"
                                    ? Colors.green
                                    : state == "today"
                                    ? Colors.orange
                                    : Colors.red,
                                    fontSize: 13
                              ),
                            ),
                          ),
                          SizedBox(width: 7),
                      
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorConstants.mainWhite,
                              boxShadow: [
                                if (!isDarkmode)
                                  BoxShadow(
                                    blurRadius: 20,
                                    color: Colors.grey.shade300,
                                    offset: Offset(0, 2),
                                  ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 13,
                              backgroundColor: !isDarkmode
                                  ? state == "planned"
                                        ? Colors.green.shade400
                                        : state == "overdue"
                                        ? Colors.red
                                        : Colors.orange.shade300
                                  : ColorConstants.grey300,
                              child: Padding(
                                padding: EdgeInsets.all(4),
                                child: activityTypeName == "Call"
                                    ? HugeIcon(
                                        icon: HugeIcons.strokeRoundedCall,
                                        color: isDarkmode
                                            ? ColorConstants.mainBlack
                                            : ColorConstants.mainWhite,
                                      )
                                    : activityTypeName == "Email"
                                    ? HugeIcon(
                                        icon: HugeIcons.strokeRoundedMail01,
                                        color: isDarkmode
                                            ? ColorConstants.mainBlack
                                            : ColorConstants.mainWhite,
                                      )
                                    : activityTypeName == "To-Do"
                                    ? HugeIcon(
                                        icon: HugeIcons.strokeRoundedTick02,
                                        color: isDarkmode
                                            ? ColorConstants.mainBlack
                                            : ColorConstants.mainWhite,
                                      )
                                    : activityTypeName == "Meeting"
                                    ? HugeIcon(
                                        icon: HugeIcons.strokeRoundedUserGroup,
                                        color: isDarkmode
                                            ? ColorConstants.mainBlack
                                            : ColorConstants.mainWhite,
                                      )
                                    : HugeIcon(
                                        icon: HugeIcons.strokeRoundedShare03,
                                        color: isDarkmode
                                            ? ColorConstants.mainBlack
                                            : ColorConstants.mainWhite,
                                      ),
                              ),
                            ),
                          ),
                          //// icpons
                          ///
                          PopupMenuButton<String>(
                            color: isDarkmode
                                ? ColorConstants.Grey800
                                : ColorConstants.mainWhite,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            icon: HugeIcon(
                              icon: HugeIcons.strokeRoundedMoreVertical,
                              color: isDarkmode
                                  ? ColorConstants.mainWhite
                                  : Colors.black,
                              size: 20,
                            ),
                            onSelected: (value) {
                              switch (value) {
                                case 'done':

                                  break;

                                case 'cancel':

                                  break;
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                onTap: () {
                                  context
                                      .read<ActivityProvider>()
                                      .doneActivities(activityId!, context);
                                },
                                value: 'done',
                                child: Row(
                                  children: [
                                    HugeIcon(
                                      icon: HugeIcons
                                          .strokeRoundedCheckmarkCircle02,
                                      size: 18,
                                      color: Colors.green,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Mark as Done',
                                      style: TextStyle(
                                        color: isDarkmode
                                            ? ColorConstants.mainWhite
                                            : ColorConstants.mainBlack,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                onTap: () {
                                  context
                                      .read<ActivityProvider>()
                                      .cancelActivities(activityId!, context);
                                },
                                value: 'cancel',
                                child: Row(
                                  children: [
                                    HugeIcon(
                                      icon: HugeIcons.strokeRoundedCancelCircle,
                                      size: 18,
                                      color: Colors.red,
                                    ),
                                   SizedBox(width: 8),
                                    Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: isDarkmode
                                            ? ColorConstants.mainWhite
                                            : ColorConstants.mainBlack,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        overflow: TextOverflow.ellipsis,
                        "Releated to : ${resmodel}",
                        style: TextStyle(
                          color: isDarkmode
                              ? ColorConstants.mainWhite
                              : ColorConstants.Grey800,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height:5),
                  Row(
                    children: [
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedClock01,
                        size: 14,
                        color: isDarkmode
                            ? ColorConstants.mainWhite
                            : ColorConstants.mainGrey
                      ),
                      SizedBox(width: screenWidth * 0.010),

                      Text(
                        DateFormat('dd MMM yyyy').format(parsedDate),
                        style: TextStyle(
                          color: isDarkmode
                              ? ColorConstants.mainWhite
                              : ColorConstants.Grey800,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),

                  Row(
                    children: [
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedUser,
                        size: 18,
                        color: isDarkmode
                            ? ColorConstants.mainWhite
                            : ColorConstants.mainGrey,
                      ),

                      SizedBox(width: screenWidth * 0.010),
                      Text(
                        "Assigned to :  ${assignees}",
                        style: TextStyle(
                          color: isDarkmode
                              ? ColorConstants.mainWhite
                              : ColorConstants.Grey800,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.010),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       "Activity Type",
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.w600,
                  //         fontSize: 15,
                  //         color: ColorConstants.mainBlack,
                  //       ),
                  //     ),

                  //     Text(
                  //       activityTypeName,
                  //       style: TextStyle(
                  //         color: ColorConstants.primaryRed,

                  //         fontWeight: FontWeight.w600,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     Column(
                  //       children: [
                  // Container(
                  //   decoration: BoxDecoration(
                  //     shape: BoxShape.circle,
                  //     color: ColorConstants.mainWhite,
                  //     boxShadow: [
                  //       BoxShadow(
                  //         blurRadius: 20,
                  //         color: Colors.grey.shade300,
                  //       ),
                  //     ],
                  //   ),
                  //           child: CircleAvatar(
                  //             radius: 25,
                  //             backgroundColor: Colors.grey.shade50,
                  //             child: Padding(
                  //               child: HugeIcon(
                  //                 icon: HugeIcons.strokeRoundedCall,
                  //                 color: ColorConstants.primaryRed,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     Column(
                  //       children: [
                  //         Container(
                  //           decoration: BoxDecoration(
                  //             shape: BoxShape.circle,
                  //             color: ColorConstants.mainWhite,
                  //             boxShadow: [
                  //               BoxShadow(
                  //                 blurRadius: 20,
                  //                 color: Colors.grey.shade300,
                  //               ),
                  //             ],
                  //           ),
                  //           child: CircleAvatar(
                  //             radius: 25,
                  //             backgroundColor: Colors.grey.shade50,
                  //             child: Padding(
                  //               child: HugeIcon(
                  //                 icon: HugeIcons.strokeRoundedMessage01,
                  //                 color: Colors.blue.shade900,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     Column(
                  //       children: [
                  //         Container(
                  //           decoration: BoxDecoration(
                  //             shape: BoxShape.circle,
                  //             color: ColorConstants.mainWhite,
                  //             boxShadow: [
                  //               BoxShadow(
                  //                 blurRadius: 20,
                  //                 color: Colors.grey.shade300,
                  //               ),
                  //             ],
                  //           ),
                  //           child: CircleAvatar(
                  //             radius: 25,
                  //             backgroundColor: Colors.grey.shade50,
                  //             child: Padding(
                  //               child: HugeIcon(
                  //                 icon: HugeIcons.strokeRoundedWhatsapp,
                  //                 color: Colors.green,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //         Text(
                  //           overflow: TextOverflow.ellipsis,

                  //           maxLines: 1,
                  //           "Whats app",
                  //         ),
                  //       ],
                  //     ),
                  //     Column(
                  //       children: [
                  //         Container(
                  //           decoration: BoxDecoration(
                  //             shape: BoxShape.circle,
                  //             color: ColorConstants.mainWhite,
                  //             boxShadow: [
                  //               BoxShadow(
                  //                 blurRadius: 20,
                  //                 color: Colors.grey.shade300,
                  //               ),
                  //             ],
                  //           ),
                  //           child: CircleAvatar(
                  //             radius: 25,
                  //             backgroundColor: Colors.grey.shade50,
                  //             child: Padding(
                  //               child: HugeIcon(
                  //                 icon: HugeIcons.strokeRoundedMailOpen,
                  //                 color: Colors.deepOrangeAccent,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
    );
  }
}

class ActivityCardShimmer extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const ActivityCardShimmer({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isDarkTheme ? const Color(0xFF1E1E1E) : Colors.white,
          boxShadow: isDarkTheme
              ? []
              : [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.grey.shade300,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Shimmer.fromColors(
          baseColor: isDarkTheme ? const Color(0xFF2A2A2A) : Colors.grey.shade300,
          highlightColor: isDarkTheme
              ? const Color(0xFF3A3A3A)
              : Colors.grey.shade100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top row (title + status + icon + menu)
              Row(
                children: [
                  Expanded(
                    child: _box(
                      height: 20,
                      width: double.infinity,
                      isDarkTheme: isDarkTheme,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _box(
                    height: 18,
                    width: 60,
                    radius: 20,
                    isDarkTheme: isDarkTheme,
                  ),
                  SizedBox(width: screenWidth * 0.020),
                  _circle(size: 36, isDarkTheme: isDarkTheme),
                  const SizedBox(width: 10),
                  _box(height: 22, width: 22, isDarkTheme: isDarkTheme),
                ],
              ),
      
              const SizedBox(height: 6),
      
              /// Related to
              _box(height: 14, width: 180, isDarkTheme: isDarkTheme),
      
              SizedBox(height: screenHeight * 0.010),
      
              /// Date row
              Row(
                children: [
                  _box(height: 14, width: 14, isDarkTheme: isDarkTheme),
                  SizedBox(width: screenWidth * 0.010),
                  _box(height: 14, width: 100, isDarkTheme: isDarkTheme),
                ],
              ),
      
              SizedBox(height: screenHeight * 0.010),
      
              /// Assigned to
              Row(
                children: [
                  _box(height: 25, width: 18, isDarkTheme: isDarkTheme),
                  SizedBox(width: screenWidth * 0.010),
                  Expanded(
                    child: _box(
                      height: 14,
                      width: double.infinity,
                      isDarkTheme: isDarkTheme,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  /// Rectangular shimmer box
  Widget _box({
    required double height,
    required double width,
    double radius = 6,
    required bool isDarkTheme,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: isDarkTheme ? const Color(0xFF2F2F2F) : Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  /// Circular shimmer (avatar)
  Widget _circle({required double size, required bool isDarkTheme}) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: isDarkTheme ? const Color(0xFF2F2F2F) : Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

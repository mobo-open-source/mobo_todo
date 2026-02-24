

//   @override
//     final taskTags = allTags
//     //   final colors = [
//     //     Colors.red.shade400,
//     //     Colors.green.shade400,
//     //     Colors.blue.shade400,
//     //     Colors.orange.shade400,
//     //     Colors.purple.shade400,
//     //     Colors.brown.shade400,
//     //     Colors.teal.shade400,
//     //     Colors.indigo.shade400,
//     //     Colors.cyan.shade400,
//     //     Colors.pink.shade400,

//     return Scaffold(
//       backgroundColor: ColorConstants.mainWhite,

//       appBar: AppBar(
//         backgroundColor: ColorConstants.mainWhite,

//         leading: InkWell(
//           },
//         ),
//         title: Text(
//           "Tasks",
//           style: GoogleFonts.montserrat(
//             color: ColorConstants.mainBlack,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         actions: [
//           InkWell(
//             onTap: onEdit,
//             child: HugeIcon(
//               icon: HugeIcons.strokeRoundedPencilEdit02,
//               size: 30,
//               color: Colors.grey.shade700,
//             ),
//           ),
//           ///// popup menu item ///

//         ],
//       ),
//       body: Padding(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   color: ColorConstants.mainWhite,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.shade300,
//                       blurRadius: 5,
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             task.name,
//                             style: TextStyle(
//                               color: ColorConstants.primaryRed,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18,
//                             ),

//                           ),
//                         ),

//                       ],
//                     ),
//                     Text(
//                       style: TextStyle(
//                         color: ColorConstants.mainBlack,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     task.description != null
//                         ? Html(
//                             data: task.description!,
//                               "body": Style(
//                                 margin: Margins.zero,
//                                 padding: HtmlPaddings.zero,
//                                 color: Colors.grey,
//                               ),
//                             },
//                           )
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.calendar_month,
//                           color: Colors.grey,
//                           size: 16,
//                         ),


//                           child: task.dateDeadline != null
//                               ? Text(
//                                   style: TextStyle(
//                                     fontWeight: taskDetailProvider.isUrgent ? FontWeight.bold : FontWeight.w400,
//                                     fontSize: 18,
//                                   ),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 )
//                               : Text("")
//                         ),

//                       ],
//                     ),
//                     Wrap(
//                       spacing: 6,
//                       runSpacing: 6,
//                         return Padding(
//                           child: Container(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 10,
//                               vertical: 5,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.blue.shade100,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey.shade300,
//                                   blurRadius: 5,
//                                 ),
//                               ],
//                             ),
//                             child: Text(
//                               tag.name,
//                               style: TextStyle(
//                                 color: ColorConstants.mainBlack,
//                               ),
//                             ),
//                           ),
//                     ),
//                       Row(
//                             mainAxisAlignment: MainAxisAlignment.end,

//                         children: [
//                             return InkWell(
//                               child: Icon(
//                                 Icons.star_outline_sharp,
//                                 color: Colors.grey.shade400,
//                                 size: 25,
//                               ),
//                           }),
//                         ],
//                       ),

//                       Row(
//                             mainAxisAlignment: MainAxisAlignment.end,

//                           return InkWell(
//                             child: index <= 0
//                                 ? Icon(
//                                     Icons.star,
//                                     color: Colors.yellow.shade700,
//                                   )
//                                 : Icon(
//                                     Icons.star_border_sharp,
//                                     color: Colors.grey,
//                                   ),
//                         }),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                           return InkWell(
//                             child: Icon(
//                               Icons.star,
//                               color: index <= 1
//                                   ? Colors.yellow.shade600
//                                   : Colors.grey.shade400,
//                               size: 25,
//                             ),
//                         }),
//                       ),
//                       Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,

//                           return InkWell(
//                             child: index <= 2
//                                 ? Icon(
//                                     Icons.star,
//                                     color: Colors.yellow.shade600,
//                                   )
//                                 : Icon(
//                                     Icons.star_border_sharp,
//                                     color: Colors.grey,
//                                   ),
//                         }),
//                       ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_todo/core/utils/color_constants.dart';
import 'package:mobo_todo/features/task%20screen/model/Task_model.dart';
import 'package:mobo_todo/features/task%20screen/provider/task_details_provider.dart';
import 'package:provider/provider.dart';

class TaskDetailDialog extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onEdit;

  const TaskDetailDialog({super.key, required this.task, this.onEdit});

  @override
  Widget build(BuildContext context) {
    final taskDetailProvider = Provider.of<TaskDetailsProvider>(context);
    final allTags = taskDetailProvider.allTags;
    final taskTags = allTags
        .where((tag) => task.tagIds.contains(tag.id))
        .toList();

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(),
          width: screenWidth,
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: ColorConstants.mainWhite,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// HEADER
              Container(
                padding: EdgeInsets.only(left: 15, top: 20, right: 15),

                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Task Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        // style: GoogleFonts.montserrat(
                        //   fontSize: 18,
                        //   fontWeight: FontWeight.w600,
                        //   color: ColorConstants.mainBlack,
                        // ),
                      ),
                    ),
                    if (onEdit != null)
                      InkWell(
                        onTap: onEdit,
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedPencilEdit02,
                          size: 26,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, size: 24),
                    ),
                  ],
                ),
              ),

              /// BODY
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TASK NAME
                    Text(
                      task.name,
                      style: TextStyle(
                        color: ColorConstants.primaryRed,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 6),

                    /// ASSIGNEES
                    Text(
                      task.userNames.join(', '),
                      style: TextStyle(
                        fontSize: 16,
                        // fontWeight: FontWeight.w600,
                      ),

                      // overflow: TextOverflow.ellipsis,
                    ),

                    /// DESCRIPTION
                    if (task.description != null)
                      Html(
                        data: task.description!,
                        style: {
                          "body": Style(
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                            fontSize: FontSize(15),
                            color: ColorConstants.mainGrey,
                          ),
                        },
                      ),
                    /// DEADLINE
                    if (task.dateDeadline != null)
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Deadline",
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              task.dateDeadline.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: taskDetailProvider.isUrgent
                                    ? FontWeight.bold
                                    : FontWeight.w400,
                                color: taskDetailProvider.deadline(
                                  task.dateDeadline.toString(),
                                ),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                    SizedBox(height: 12),

                    /// TAGS
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: taskTags.map((tag) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 3,
                            vertical: 3,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 7,
                                  offset: Offset(0, 2),
                                ),
                              ],
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              tag.name,
                              style: TextStyle(color: ColorConstants.mainBlack),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        ...List.generate(3, (index) {
                          final priority =
                              int.tryParse(task.priority ?? "0") ?? 0;
                          return Icon(
                            index < priority ? Icons.star : Icons.star_border,
                            color: index < priority
                                ? Colors.yellow.shade700
                                : Colors.grey,
                            size: 25,
                          );
                        }),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

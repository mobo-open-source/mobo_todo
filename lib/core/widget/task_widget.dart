import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_todo/features/activity%20screen/overlay/activity_creation.dart';
import 'package:mobo_todo/features/task%20screen/model/Task_model.dart';
import 'package:mobo_todo/features/task%20screen/provider/task_details_provider.dart';
import 'package:mobo_todo/core/utils/color_constants.dart';
import 'package:mobo_todo/features/task%20screen/provider/task_provider.dart';
import 'package:provider/provider.dart';

import 'shimmer_widgets/all_task_card_widget.dart';

class TasksListCard extends StatelessWidget {
  final TaskModel task;
  final bool isDarkmode;
  final void Function()? onTap;
  final void Function()? onActivity;

  const TasksListCard({
    super.key,
    required this.task,
    required this.screenHeight,
    //    required this.title,
    // this.description,
    //   required this.assignees,
    //  required this.deadline,
    //  required this.tags,
    this.onTap,

    this.onActivity,
    required this.isDarkmode,
  });
  final double screenHeight;
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final taskDetailsProvider = Provider.of<TaskDetailsProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: InkWell(
        onTap: onTap,
        child: taskProvider.isLoading
            ? TaskCardShimmer(
                screenHeight: screenHeight,
                isDarkmode: isDarkmode,
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: isDarkmode
                      ? ColorConstants.Grey800
                      : ColorConstants.mainWhite,
                  boxShadow: [
                    BoxShadow(
                      color: isDarkmode
                          ? ColorConstants.mainBlack
                          : Colors.grey.shade300,
                      blurRadius: 5,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            task.name,
                            style: TextStyle(
                              color: isDarkmode
                                  ? ColorConstants.mainWhite
                                  : ColorConstants.primaryRed,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 10),
                        EnhancedActivityIcon(
                          isDarkmode: isDarkmode,

                          resId: task.id,
                          resModel: 'project.task',
                          recordName: task.name,
                        ),
                      ],
                    ),
                    Text(
                      task.userNames.join(', '),
                      style: TextStyle(
                        color: isDarkmode
                            ? ColorConstants.grey100
                            : ColorConstants.Grey800,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    if (taskProvider.odooVersion == "19") ...[
                      if (task.dateDeadline != null &&
                          task.dateDeadline!.isNotEmpty)
                        Column(
                          children: [
                            SizedBox(height: 10),
                            Row(
                              children: [
                                task.dateDeadline!.isNotEmpty
                                    ? HugeIcon(
                                        icon: HugeIcons.strokeRoundedCalendar03,
                                        size: 20,
                                        color: isDarkmode
                                            ? ColorConstants.grey100
                                            : ColorConstants.mainGrey,
                                      )
                                    : SizedBox(),
                                SizedBox(width: 5),

                                Text(
                                  "Deadline",
                                  style: TextStyle(
                                    color: isDarkmode
                                        ? ColorConstants.grey100
                                        : ColorConstants.Grey800,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    taskDetailsProvider.deadlineAgo(
                                      task.dateDeadline ?? "",
                                    ),
                                    style: TextStyle(
                                      color: isDarkmode
                                          ? ColorConstants.grey100
                                          : taskDetailsProvider.deadline(
                                              task.dateDeadline!,
                                            ),
                                      fontSize: 15,
                                      fontWeight: taskDetailsProvider.isUrgent
                                          ? FontWeight.bold
                                          : FontWeight.w300,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                    ],

                    if (taskProvider.odooVersion == "18") ...[
                      if (task.priority == "0")
                        Row(
                          children: [
                            ...List.generate(1, (index) {
                              return Icon(
                                Icons.star_border_purple500_outlined,
                                color: Colors.grey.shade400,
                                size: 25,
                              );
                            }),
                          ],
                        ),
                      if (task.priority == "1")
                        Row(
                          children: List.generate(1, (index) {
                            return index <= 0
                                ? Icon(
                                    Icons.star,
                                    color: Colors.yellow.shade600,
                                  )
                                : Icon(
                                    Icons.star_border_sharp,
                                    color: Colors.grey,
                                  );
                          }),
                        ),
                    ],

                    if (taskProvider.odooVersion == "19") ...[
                      if (task.priority == "0")
                        Row(
                          children: [
                            ...List.generate(3, (index) {
                              return Icon(
                                Icons.star_border_purple500_outlined,
                                color: Colors.grey.shade400,
                                size: 25,
                              );
                            }),
                          ],
                        ),
                      if (task.priority == "1")
                        Row(
                          children: List.generate(3, (index) {
                            return index <= 0
                                ? Icon(
                                    Icons.star,
                                    color: Colors.yellow.shade600,
                                  )
                                : Icon(
                                    Icons.star_border_sharp,
                                    color: Colors.grey,
                                  );
                          }),
                        ),
                    ],
                    if (task.priority == "2")
                      Row(
                        children: [
                          ...List.generate(3, (index) {
                            return InkWell(
                              onTap: () {},
                              child: index <= 1
                                  ? Icon(
                                      Icons.star,
                                      color: Colors.yellow.shade600,
                                    )
                                  : Icon(
                                      Icons.star_border_sharp,
                                      color: Colors.grey,
                                    ),
                            );
                          }),
                        ],
                      ),
                    if (task.priority == "3")
                      Row(
                        children: [
                          ...List.generate(3, (index) {
                            return index <= 2
                                ? Icon(
                                    Icons.star,
                                    color: Colors.yellow.shade600,
                                  )
                                : Icon(
                                    Icons.star_border_sharp,
                                    color: Colors.grey,
                                  );
                          }),
                        ],
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}

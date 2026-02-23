import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_todo/core/utils/color_constants.dart';
import 'package:mobo_todo/core/widget/loading_widget.dart';
import 'package:mobo_todo/core/widget/save_button.dart';
import 'package:mobo_todo/features/activity%20screen/model/activity_model.dart';
import 'package:mobo_todo/features/activity%20screen/model/activity_type_model.dart';
import 'package:mobo_todo/features/activity%20screen/provider/activity_provider.dart';
import 'package:mobo_todo/features/activity%20screen/provider/old_acitivity_provider.dart';
import 'package:mobo_todo/features/addTask%20screen/model/user_model.dart';
import 'package:mobo_todo/features/task%20screen/provider/task_provider.dart';
import 'package:mobo_todo/features/task%20screen/screens/all_task_screen.dart';
import 'package:provider/provider.dart';

class AddActivityDialog extends StatefulWidget {
  final int resId;
  final String model;
  final void Function()? onSuccess;
  const AddActivityDialog({
    super.key,
    required this.resId,
    required this.model,
    this.onSuccess,
  });

  @override
  State<AddActivityDialog> createState() => _AddActivityDialogState();
}

class _AddActivityDialogState extends State<AddActivityDialog> {
  bool validateActivityForm(ActivityProvider provider) {
    bool isValid = true;

    setState(() {
      activityTypeError = null;
      assigneeError = null;
      dateError = null;

      if (provider.selecteActivity == null) {
        activityTypeError = "Please select activity type";
        isValid = false;
      }

      if (provider.selectUser == null) {
        assigneeError = "Please select assignee";
        isValid = false;
      }

      if (activityDateController.text.isEmpty) {
        dateError = "Please select date";
        isValid = false;
      }
    });

    return isValid;
  }

  String? activityTypeError;
  String? assigneeError;
  String? dateError;
  String? selectedDate;
  ActivityType? selectedActivity;
  TextEditingController titleController = TextEditingController();
  TextEditingController desccontroller = TextEditingController();
  TextEditingController deadlinecontroller = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController summaryController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController activityDateController = TextEditingController();
  TextEditingController activitySearchController = TextEditingController();
  TextEditingController assigneesSearchController = TextEditingController();
  FocusNode activityNode = FocusNode();
  FocusNode userNode = FocusNode();

  FocusNode summaryNode = FocusNode();
  FocusNode noteNode = FocusNode();

  bool showDropdown = false;
  int selectedActivityType = 0;
  int selectedIndex = 0;
  int SelectedtagIndex = 0;
  final formkey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ActivityProvider>().fecthActivityType();
      context.read<ActivityProvider>().fethcActivityUsers();
      context.read<ActivityProvider>().focusActivity(activityNode);

      summaryNode.addListener(() {
        setState(() {});
      });
      noteNode.addListener(() {
        setState(() {});
      });
      userNode.addListener(() {
        setState(() {});
      });
      activityNode.addListener(() {
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    summaryController.dispose();
    noteController.dispose();
    super.dispose();
  }

  bool get isMeeting => selectedActivity?.name.toLowerCase() == 'meeting';
  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    return Dialog(
      backgroundColor: isDarkTheme
          ? ColorConstants.Grey800
          : ColorConstants.mainWhite,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Consumer2<ActivityProvider, OldAcitivityProvider>(
        builder: (context, activityProvider, oldprovider, child) {
          return SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          // HugeIcon(
                          //   icon: HugeIcons.strokeRoundedCalendar03,

                          //   size: 20,
                          //   color: ColorConstants.primaryRed,
                          // ),
                          Text(
                            "Add Activity",
                            style: TextStyle(
                              color: isDarkTheme
                                  ? ColorConstants.mainWhite
                                  : ColorConstants.mainBlack,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              activityProvider.clearSelectedActivity(
                                activitySearchController,
                              );
                            },
                            child: HugeIcon(
                              icon: HugeIcons.strokeRoundedCancel01,
                              color: isDarkTheme
                                  ? ColorConstants.mainWhite
                                  : ColorConstants.mainBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Activity Type",
                          style: TextStyle(
                            color: isDarkTheme
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                            fontSize: 15,
                          ),
                        ),

                        SizedBox(height: 5),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isDarkTheme
                                ? ColorConstants.grey900
                                : ColorConstants.textFieldFillColor,
                            border: Border.all(
                              color: activityNode.hasFocus
                                  ? ColorConstants.primaryRed
                                  : Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              // --------------------- Selected Users area ---------------------

                              // --------------------- TypeAhead Field ---------------------
                              SizedBox(
                                width: double.infinity,
                                child: TypeAheadField<ActivityTypeModel>(
                                  controller: activitySearchController,
                                  decorationBuilder: (context, child) {
                                    return Material(
                                      type: MaterialType.card,
                                      elevation: 4,
                                      borderRadius: BorderRadius.circular(8),
                                      child: child,
                                    );
                                  },
                                  constraints: BoxConstraints(maxHeight: 500),
                                  suggestionsCallback: (String search) {
                                    return activityProvider.getActivityType(
                                      search,
                                    );
                                  },
                                  builder: (context, controller, node) {
                                    activityNode = node;
                                    return Container(
                                      child: SizedBox(
                                        height:
                                            activityProvider.selecteActivity ==
                                                null
                                            ? screenHeight * 0.040
                                            : 40,
                                        child: TextField(
                                          controller: controller,
                                          focusNode: node,
                                          onChanged: (value) {
                                            activityProvider.searchActivity(
                                              value,
                                            );
                                         

                                          },
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            hintStyle: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontSize: 16,
                                            ),
                                            hintText:
                                                activityProvider
                                                        .selecteActivity ==
                                                    null
                                                ? "Select Activity Type"
                                                : "",

                                            prefixIconConstraints:
                                                BoxConstraints(
                                                  minWidth: 0,
                                                  minHeight: 0,
                                                ),

                                            prefixIcon:
                                                activityProvider
                                                        .selecteActivity !=
                                                    null
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          left: 6,
                                                          right: 6,
                                                        ),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                            vertical: 6,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey,
                                                            blurRadius: 2,
                                                            offset: Offset(
                                                              0,
                                                              2,
                                                            ),
                                                          ),
                                                        ],
                                                        color: Colors
                                                            .blue
                                                            .shade100,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              20,
                                                            ),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            activityProvider
                                                                .selecteActivity!
                                                                .name,
                                                            style:
                                                                const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                          ),
                                                          const SizedBox(
                                                            width: 6,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              activityProvider
                                                                  .clearSelectedActivity(
                                                                    activitySearchController,
                                                                  );
                                                            },
                                                            child: CircleAvatar(
                                                              radius: 10,
                                                              backgroundColor:
                                                                  Colors
                                                                      .black54,
                                                              child: const Icon(
                                                                Icons.close,
                                                                size: 16,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: ColorConstants.mainWhite,
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          suggestion.name,
                                          style: TextStyle(
                                            color: ColorConstants.mainBlack,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  emptyBuilder: (context) {
                                    return Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: ColorConstants.mainWhite,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "No results found",
                                        style: TextStyle(
                                          color: ColorConstants.primaryRed,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
                                  onSelected: (ActivityTypeModel value) {
                                    setState(() {
                                      activityTypeError = null;
                                    });
                                    activityProvider.onSelectedtype(value);
                                    assigneesSearchController.clear();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (activityTypeError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              activityTypeError!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        SizedBox(height: screenHeight * 0.020),
                        Text(
                          "Summary",
                          style: TextStyle(
                            color: isDarkTheme
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 5),
                        ActivityTextField(
                          isdarkmode: isDarkTheme,
                          focusNode: summaryNode,
                          controller: summaryController,
                          hintText: "Enter summary",
                        ),
                        SizedBox(height: screenHeight * 0.020),
                        Text(
                          "Assigned To",
                          style: TextStyle(
                            fontSize: 15,
                            color: isDarkTheme
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: BoxBorder.all(
                              color: userNode.hasFocus
                                  ? ColorConstants.primaryRed
                                  : Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(5),
                            color: isDarkTheme
                                ? ColorConstants.grey900
                                : ColorConstants.textFieldFillColor,
                          ),
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              // --------------------- Selected Users area ---------------------
                              if (activityProvider.selectUser != null)
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        if (!isDarkTheme)
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 2,
                                            offset: Offset(0, 2),
                                          ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          activityProvider.selectUser!.name,
                                          style: const TextStyle(
                                            color: ColorConstants.mainBlack,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        InkWell(
                                          onTap: () {
                                            activityProvider.clearSelectedUser(
                                              assigneesSearchController,
                                            );
                                          },
                                          child: CircleAvatar(
                                            radius: 10,
                                            backgroundColor: Colors.black54,
                                            child: HugeIcon(
                                              icon: HugeIcons
                                                  .strokeRoundedCancel01,
                                              color: ColorConstants.mainWhite,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              // --------------------- TypeAhead Field ---------------------
                              SizedBox(
                                width: double.infinity,
                                child: TypeAheadField<UserModel>(
                                  controller: assigneesSearchController,
                                  decorationBuilder: (context, child) {
                                    return Material(
                                      type: MaterialType.card,
                                      elevation: 4,
                                      borderRadius: BorderRadius.circular(8),
                                      child: child,
                                    );
                                  },
                                  constraints: BoxConstraints(maxHeight: 500),
                                  suggestionsCallback: (String search) {
                                    return activityProvider.getUsernames(
                                      search,
                                    );
                                  },
                                  builder: (context, controller, node) {
                                    userNode = node;
                                    return Container(
                                      child: SizedBox(
                                        height:
                                            activityProvider.selectUser == null
                                            ? screenHeight * 0.040
                                            : screenWidth * 0.025,
                                        child: TextField(
                                          onChanged: (value) {
                                            activityProvider.searchUser(value);
                                          },
                                          controller: controller,
                                          focusNode: node,
                                          decoration: InputDecoration(
                                            focusedBorder: InputBorder.none,
                                            hintText:
                                                activityProvider.selectUser !=
                                                    null
                                                ? ""
                                                : "Select Assignees",
                                            hintStyle: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontSize: 15,
                                            ),
                                            // "Select Activity",
                                            border: InputBorder.none,
                                          ),
                                          style: TextStyle(
                                            color: ColorConstants.mainBlack,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: ColorConstants.mainWhite,
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          suggestion.name,

                                          style: TextStyle(
                                            color: ColorConstants.mainBlack,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  emptyBuilder: (context) {
                                    return Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: ColorConstants.mainWhite,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "No results found",
                                        style: TextStyle(
                                          color: ColorConstants.primaryRed,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
                                  onSelected: (UserModel value) {
                                    setState(() {
                                      assigneeError = null;
                                    });
                                    activityProvider.onSelecteeUser(value);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (assigneeError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              assigneeError!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),

                        SizedBox(height: screenHeight * 0.020),
                        Text(
                          "Note",
                          style: TextStyle(
                            fontSize: 15,
                            color: isDarkTheme
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.010),
                        ActivityTextField(
                          isdarkmode: isDarkTheme,
                          focusNode: noteNode,
                          controller: noteController,
                          hintText: "Enter Internal Note",
                        ),
                        SizedBox(height: screenHeight * 0.020),
                        Text(
                          "Date",
                          style: TextStyle(
                            fontSize: 15,
                            color: isDarkTheme
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: isDarkTheme
                                ? ColorConstants.grey900
                                : ColorConstants.textFieldFillColor,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedCalendar01,
                                size: 18,
                                color: Colors.grey.shade500,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  // },
                                  readOnly: true,
                                  onTap: () async {
                                    final pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: ColorScheme.light(
                                              primary: Theme.of(
                                                context,
                                              ).primaryColor,
                                              onPrimary: Colors.white,
                                              surface: Colors.white,
                                              onSurface: Colors.black87,
                                            ),
                                            datePickerTheme:
                                                DatePickerThemeData(
                                                  dividerColor:
                                                      Colors.transparent,
                                                  headerBackgroundColor:
                                                      Theme.of(
                                                        context,
                                                      ).primaryColor,
                                                  headerForegroundColor:
                                                      Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          28,
                                                        ),
                                                  ),
                                                ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (pickedDate == null) return;
                                    setState(() {
                                      dateError = null;
                                    });
                                    final finalDateTime = DateTime(
                                      pickedDate.year,
                                      pickedDate.month,
                                      pickedDate.day,
                                    );
                                    // Format
                                    final formatted =
                                        "${finalDateTime.year.toString().padLeft(4, '0')}-"
                                        "${finalDateTime.month.toString().padLeft(2, '0')}-"
                                        "${finalDateTime.day.toString().padLeft(2, '0')}";
                                    activityDateController.text = formatted;
                                  },
                                  controller: activityDateController,
                                  style: TextStyle(
                                    color: ColorConstants.mainBlack,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    hintText: "Select date",
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 15,
                                    ),
                                    focusedBorder: InputBorder.none,
                                    isDense: true,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (dateError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              dateError!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        SizedBox(height: screenHeight * 0.030),
                        SaveButton(
                          onTap: () async {
                            final activityProvider = context
                                .read<ActivityProvider>();
                            final taskProvider = context.read<TaskProvider>();

                            if (!validateActivityForm(activityProvider)) return;


                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              // useRootNavigator: true,
                              builder: (_) => ShowLoading(
                                screenHeight: screenHeight,
                                title: "Creating Activity",
                                fucntion: "add",
                                action: "activity",
                              ),
                            );
                            try {
                              await oldprovider.createActivity(
                                context: context,
                                resId: widget.resId,
                                activityTypeId:
                                    activityProvider.selecteActivity!.id,
                                userId: activityProvider.selectUser!.id,
                                summary: summaryController.text,
                                dateDeadline: activityDateController.text,
                                resModel: 'project.task',
                                note: noteController.text,
                              );
                              activityProvider.selectUser = null;
                              activityProvider.selecteActivity = null;
                              activityDateController.clear();

                              if (context.mounted) {
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pop();
                              }

                              await oldprovider.fetchActivities(
                                resId: widget.resId,
                                resModel: 'project.task',
                              );

                              await taskProvider.fetchTasks();
                            } catch (e) {

                            }
                          },

                          title: "Create",
                        ),
                        SizedBox(height: screenHeight * 0.010),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

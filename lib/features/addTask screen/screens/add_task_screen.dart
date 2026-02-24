import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:mobo_todo/core/widget/bottom_navigation_bar.dart';
import 'package:mobo_todo/core/widget/custome_edit_textfield.dart';
import 'package:mobo_todo/core/widget/snackbar.dart';
import 'package:mobo_todo/features/addTask%20screen/provider/personal_stage_provider.dart';
import 'package:mobo_todo/features/addTask%20screen/provider/tag_provider.dart';
import 'package:mobo_todo/features/addTask%20screen/provider/add_task_provider.dart';
import 'package:mobo_todo/features/addTask%20screen/screens/selected_item_widge.dart';
import 'package:mobo_todo/features/task%20screen/provider/task_details_provider.dart';
import 'package:mobo_todo/features/task%20screen/provider/task_provider.dart';
import 'package:mobo_todo/features/addTask%20screen/model/tag_model.dart';
import 'package:mobo_todo/features/addTask%20screen/model/user_model.dart';
import 'package:mobo_todo/core/utils/color_constants.dart';
import 'package:mobo_todo/core/widget/loading_widget.dart';
import 'package:mobo_todo/core/widget/save_button.dart';
import 'package:provider/provider.dart';

class AddTaskScreen extends StatefulWidget {
  final List<dynamic>? tags;
  final int? id;
  final bool isEdit;
  final String? personalStagename;
  final int? personalStageid;
  final String? title;
  final String? description;
  final String? deadline;
  final String? assignees;
  final String? priority;

  const AddTaskScreen({
    super.key,
    required this.isEdit,
    this.title,
    this.deadline,
    this.assignees,
    this.description,
    this.id,
    this.tags,

    this.priority,
    this.personalStagename,
    this.personalStageid,
  });

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  String stripHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  late TextEditingController titleController = TextEditingController(
    text: widget.title,
  );
  late TextEditingController desccontroller = TextEditingController(
    text: widget.description != null ? stripHtml(widget.description!) : "",
  );
  late TextEditingController deadlinecontroller = TextEditingController(
    text: widget.deadline != null ? widget.deadline : "",
  );
  late TextEditingController searchController = TextEditingController();
  late TextEditingController tagController = TextEditingController();
  FocusNode tagNode = FocusNode();
  FocusNode userNode = FocusNode();
  FocusNode titleNode = FocusNode();
  FocusNode discriptionNode = FocusNode();

  int selectedIndex = 0;
  int SelectedtagIndex = 0;
  final formkey = GlobalKey<FormState>();

  @override
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final addTaskProvider = Provider.of<AddTaskProvider>(
        context,
        listen: false,
      );
      context.read<PersonalStageProvider>().PersonalStages();
      context.read<PersonalStageProvider>().initstage(widget.personalStageid);
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      final tagProvider = Provider.of<TagProvider>(context, listen: false);
      final taskDetailProvider = Provider.of<TaskDetailsProvider>(
        context,
        listen: false,
      );
      addTaskProvider.fethcUsers();
      taskProvider.fetchTasks();
      await tagProvider.fetchTags();
      taskProvider.userFocus(userNode);
      tagProvider.tagFocus(tagNode);
      if (widget.isEdit && widget.tags != null) {
        final allTags = taskDetailProvider.allTags;
        final allUser = taskDetailProvider.allUSers;
        final selectedTags = allTags
            .where((tag) => widget.tags!.contains(tag.id))
            .toList();
        final selectedUsers = allUser
            .where((element) => widget.assignees!.contains(element.name))
            .toList();
        addTaskProvider.selectedUserItems = selectedUsers;
        tagProvider.selectedTagItems = selectedTags;
        tagProvider.notifyListeners();
      }
      if (widget.isEdit && widget.priority != null) {
        final taskProvider = Provider.of<TaskProvider>(context, listen: false);
        int parsedPriority = int.tryParse(widget.priority!) ?? 0;
        taskProvider.selectedIndex = parsedPriority - 1;
      }
    });
  }

  @override
  void dispose() {
    searchController;
    tagController;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final taskProvider = Provider.of<TaskProvider>(context);
    final tagProvider = Provider.of<TagProvider>(context);
    final addTaskProvider = Provider.of<AddTaskProvider>(context);
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    return Scaffold(
      backgroundColor: isDarkTheme
          ? ColorConstants.grey900
          : ColorConstants.mainWhite,
      appBar: AppBar(
        backgroundColor: isDarkTheme
            ? ColorConstants.grey900
            : ColorConstants.backgroundWhite,
        actions: [
          SizedBox(width: screenWidth * 0.040),
          widget.isEdit
              ? InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        backgroundColor: isDarkTheme
                            ? ColorConstants.Grey800
                            : ColorConstants.mainWhite,

                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Delete Task",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),

                              Text(
                                "Are you sure you want to delete This Task? This action is permanent and cannot be undone",
                              ),
                              SizedBox(height: screenHeight * 0.020),

                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          color: ColorConstants.mainWhite,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 10,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                              color: ColorConstants.mainBlack,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        Navigator.pop(context);
                                        late BuildContext loadingDialogContext;
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (dialogContext) {
                                            loadingDialogContext =
                                                dialogContext;
                                            return ShowLoading(
                                              screenHeight: screenHeight,
                                              title: "Deleting Task",
                                              action: "task",
                                              fucntion: "delete",
                                            );
                                          },
                                        );
                                        await addTaskProvider.deleteTask(
                                          widget.id!,
                                          context,
                                        );

                                        Navigator.pushAndRemoveUntil(
                                          loadingDialogContext,
                                          MaterialPageRoute(
                                            builder: (context) => BottomNavig(),
                                          ),
                                          (route) => false,
                                        );
                                        CustomSnackbar.showSuccess(
                                          loadingDialogContext,
                                          "Task deleted successfully",
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            if (!isDarkTheme)
                                              BoxShadow(
                                                offset: Offset(1, 4),
                                                blurRadius: 5,
                                                color: Colors.grey,
                                              ),
                                          ],
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          color: Colors.red.shade900,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(
                                              color: ColorConstants.mainWhite,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                    /////  delete  task function here///
                  },
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedDelete02,
                    color: ColorConstants.mainRed,
                  ),
                )
              : SizedBox(),
          widget.isEdit
              ? Consumer<PersonalStageProvider>(
                  builder: (context, stageProvider, child) {
                    return PopupMenuButton<int>(
                      onSelected: (selectedStageId) async {
                        await stageProvider.updatePersonalStage(
                          context: context,
                          taskId: widget.id!,
                          personalStageId: selectedStageId,
                        );
                      },
                      offset: Offset(10, 10),
                      constraints: BoxConstraints(
                        maxHeight: screenHeight * 0.30,
                      ),
                      iconColor: isDarkTheme
                          ? ColorConstants.mainWhite
                          : Colors.grey.shade700,
                      color: ColorConstants.mainWhite,
                      itemBuilder: (context) {
                        return stageProvider.personalStages.map((stage) {
                          final isSelected =
                              stage.id == stageProvider.personalstageId!;
                          return PopupMenuItem<int>(
                            value: stage.id,
                            child: ListTile(
                              leading: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                      size: 20,
                                    )
                                  : const SizedBox(width: 20),
                              title: Text(
                                stage.name,

                                style: TextStyle(
                                  color: ColorConstants.mainBlack,
                                ),
                              ),
                            ),
                          );
                        }).toList();
                      },
                    );
                  },
                )
              : SizedBox(),
        ],
        title: Text(
          widget.isEdit ? "Edit task" : "Add Task",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: isDarkTheme
                ? ColorConstants.mainWhite
                : ColorConstants.mainBlack,
          ),
        ),
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: isDarkTheme
                ? ColorConstants.mainWhite
                : ColorConstants.mainBlack,
          ),
          onPressed: () {
            taskProvider.selectedIndex = -1;
            addTaskProvider.isLoggedUserAutomaticallyAdded = false;
            titleController.clear();
            deadlinecontroller.clear();
            desccontroller.clear();
            searchController.clear();
            tagController.clear();
            addTaskProvider.userList.clear();
            addTaskProvider.selectedUserItems.clear();
            tagProvider.selectedTagItems.clear();
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Consumer<AddTaskProvider>(
            builder: (context, addtaskProvider, child) {
              final provider = Provider.of<TaskProvider>(context);
              return Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          if (!isDarkTheme)
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 10,
                              offset: Offset(0, 1),
                            ),
                        ],
                        color: isDarkTheme
                            ? ColorConstants.Grey800
                            : ColorConstants.mainWhite,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            child: Text(
                              "Task Details",
                              style: TextStyle(
                                color: isDarkTheme
                                    ? ColorConstants.mainWhite
                                    : ColorConstants.mainBlack,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Divider(
                            color: isDarkTheme
                                ? ColorConstants.mainGrey
                                : Colors.grey.shade300,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Task Title",
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                                SizedBox(height: 5),
                                ////// title form /////
                                CustomeEditForm(
                                  // hintetext: "Enter task title",
                                  isdarkmode: isDarkTheme,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Title is Required";
                                    } else {
                                      return null;
                                    }
                                  },
                                  focusNode: titleNode,
                                  controller: titleController,
                                ),
                                SizedBox(height: 20),

                                Text(
                                  "Assignees",
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                                SizedBox(height: 5),
                                Column(
                                  children: [
                                    Container(
                                      constraints: const BoxConstraints(
                                        minHeight: 40,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isDarkTheme
                                            ? ColorConstants.grey900
                                            : ColorConstants.textFieldFillColor,
                                        border: Border.all(
                                          color: userNode.hasFocus
                                              ? ColorConstants.primaryRed
                                              : Colors.transparent,
                                          width: userNode.hasFocus ? 1 : 1,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
                                        children: [
                                          // --------------------- Selected Users area ---------------------
                                          ...addtaskProvider.selectedUserItems
                                              .map((item) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(
                                                    4.0,
                                                  ),
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 5,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.blue.shade100,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                      boxShadow: [
                                                        if (!isDarkTheme)
                                                          BoxShadow(
                                                            color: Colors.grey,
                                                            blurRadius: 2,
                                                            offset: Offset(
                                                              0,
                                                              2,
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                    child: SelectedItemWidget(
                                                      imageFile: item.image1920,
                                                      onRemove: () {
                                                        addtaskProvider
                                                            .removeSelection(
                                                              item.name,
                                                            );
                                                      },
                                                      showImage: true,
                                                      title: item.name,
                                                    ),
                                                  ),
                                                );
                                              }),
                                          // --------------------- TypeAhead Field ---------------------
                                          SizedBox(
                                            width: double.infinity,
                                            child: TypeAheadField<UserModel>(
                                              decorationBuilder:
                                                  (context, child) {
                                                    return Material(
                                                      type: MaterialType.card,
                                                      elevation: 4,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      child: child,
                                                    );
                                                  },
                                              constraints: BoxConstraints(
                                                maxHeight: 500,
                                              ),
                                              suggestionsCallback:
                                                  (String search) {
                                                    return addtaskProvider
                                                        .getUsername(search);
                                                  },
                                              builder: (context, controller, node) {
                                                userNode = node;
                                                return Container(
                                                  child: SizedBox(
                                                    child: TextField(
                                                      readOnly: false,

                                                      onChanged: (value) {
                                                        addtaskProvider
                                                            .searchUser(value);
                                                      },
                                                      controller: controller,
                                                      focusNode: node,
                                                      decoration: InputDecoration(
                                                        focusedBorder:
                                                            InputBorder.none,
                                                        hint: Padding(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 10,
                                                              ),
                                                          child: Text(
                                                            addtaskProvider
                                                                    .selectedUserItems
                                                                    .isEmpty
                                                                ? "Add assignees"
                                                                : "",
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .grey
                                                                  .shade600,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),

                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                      style: TextStyle(
                                                        color: isDarkTheme
                                                            ? ColorConstants
                                                                  .mainWhite
                                                            : ColorConstants
                                                                  .mainBlack,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              itemBuilder: (context, suggestion) {
                                                final isSelected =
                                                    addtaskProvider
                                                        .selectedUserItems
                                                        .any(
                                                          (u) =>
                                                              u.id ==
                                                              suggestion.id,
                                                        );
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    color: ColorConstants
                                                        .mainWhite,
                                                  ),
                                                  child: ListTile(
                                                    title: Text(
                                                      suggestion.name,
                                                      style: TextStyle(
                                                        color: ColorConstants
                                                            .mainBlack,
                                                      ),
                                                    ),
                                                    trailing: isSelected
                                                        ? HugeIcon(
                                                            icon: HugeIcons
                                                                .strokeRoundedTick02,
                                                            color: Colors.green,
                                                          )
                                                        : null,
                                                    onTap: () {
                                                      addtaskProvider
                                                          .checkUserItem(
                                                            suggestion,
                                                          );
                                                    },
                                                  ),
                                                );
                                              },
                                              emptyBuilder: (context) {
                                                return Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.all(15),
                                                  decoration: BoxDecoration(
                                                    color: ColorConstants
                                                        .mainWhite,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    "No results found",
                                                    style: TextStyle(
                                                      color: ColorConstants
                                                          .primaryRed,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                );
                                              },
                                              onSelected: (value) {
                                                addtaskProvider.checkUserItem(
                                                  value,
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                               
                                if (taskProvider.odooVersion == "19") ...[

                                   SizedBox(height: 20),
                                  Text(
                                    "Deadline Date",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        HugeIcon(
                                          icon:
                                              HugeIcons.strokeRoundedCalendar01,
                                          size: 18,
                                          color: Colors.grey.shade500,
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: TextFormField(
                                            readOnly: true,
                                            onTap: () async {
                                              final pickedDate = await showDatePicker(
                                                context: context,
                                                initialDate: addtaskProvider
                                                    .getInitialdate(
                                                      deadlinecontroller.text,
                                                    ),
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2100),
                                                builder: (context, child) {
                                                  return Theme(
                                                    data: Theme.of(context).copyWith(
                                                      colorScheme:
                                                          ColorScheme.light(
                                                            primary: Theme.of(
                                                              context,
                                                            ).primaryColor,
                                                            onPrimary:
                                                                Colors.white,
                                                            surface:
                                                                Colors.white,
                                                            onSurface:
                                                                Colors.black87,
                                                          ),
                                                      datePickerTheme: DatePickerThemeData(
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
                                              final pickedTime = await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now(),
                                                builder: (context, child) {
                                                  return Theme(
                                                    data: Theme.of(context).copyWith(
                                                      timePickerTheme: TimePickerThemeData(
                                                        dayPeriodTextColor:
                                                            MaterialStateColor.resolveWith((
                                                              states,
                                                            ) {
                                                              if (states.contains(
                                                                MaterialState
                                                                    .selected,
                                                              )) {
                                                                return Colors
                                                                    .white;
                                                              }
                                                              return ColorConstants
                                                                  .primaryRed;
                                                            }),
                                                      ),
                                                      colorScheme:
                                                          ColorScheme.light(
                                                            primary:
                                                                ColorConstants
                                                                    .primaryRed,
                                                            onPrimary:
                                                                ColorConstants
                                                                    .mainWhite,
                                                            onSurface:
                                                                ColorConstants
                                                                    .mainBlack,
                                                          ),
                                                      textButtonTheme:
                                                          TextButtonThemeData(
                                                            style: TextButton.styleFrom(
                                                              foregroundColor:
                                                                  ColorConstants
                                                                      .primaryRed,
                                                            ),
                                                          ),
                                                    ),
                                                    child: child!,
                                                  );
                                                },
                                              );

                                              if (pickedTime == null) return;
                                              final finalDateTime = DateTime(
                                                pickedDate.year,
                                                pickedDate.month,
                                                pickedDate.day,
                                                pickedTime.hour,
                                                pickedTime.minute,
                                              );
                                              // Format
                                              final formatted =
                                                  "${finalDateTime.year.toString().padLeft(4, '0')}-"
                                                  "${finalDateTime.month.toString().padLeft(2, '0')}-"
                                                  "${finalDateTime.day.toString().padLeft(2, '0')} "
                                                  "${finalDateTime.hour.toString().padLeft(2, '0')}:"
                                                  "${finalDateTime.minute.toString().padLeft(2, '0')}:"
                                                  "00";
                                              final formattedDate = DateFormat(
                                                'MMM dd, yyyy',
                                              ).format(finalDateTime);

                                              final odooDate = DateFormat(
                                                'yyyy-MM-dd HH:mm:ss',
                                              ).format(finalDateTime);
                                              deadlinecontroller.text =
                                                  odooDate;
                                              userNode.unfocus();
                                              tagNode.unfocus();
                                            },
                                            controller: deadlinecontroller,
                                            style: TextStyle(
                                              color: isDarkTheme
                                                  ? ColorConstants.mainGrey
                                                  : ColorConstants.mainBlack,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            decoration: InputDecoration(
                                              hintText: "Select date",
                                              hintStyle: TextStyle(
                                                color: Colors.grey.shade600,
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
                                ],
                                SizedBox(height: 20),
                                Text(
                                  "Tags",
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                                SizedBox(height: 5),

                                Consumer<TagProvider>(
                                  builder: (context, tagProvider, child) {
                                    return Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 5,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isDarkTheme
                                                ? ColorConstants.grey900
                                                : ColorConstants
                                                      .textFieldFillColor,
                                            border: Border.all(
                                              color: tagNode.hasFocus
                                                  ? ColorConstants.primaryRed
                                                  : Colors.transparent,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Wrap(
                                            spacing: 5,
                                            runSpacing: 5,
                                            children: [
                                              ...tagProvider.selectedTagItems.map((
                                                item,
                                              ) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 5,
                                                      ),

                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        if (!isDarkTheme)
                                                          BoxShadow(
                                                            color: Colors.grey,
                                                            blurRadius: 2,
                                                            offset: Offset(
                                                              0,
                                                              2,
                                                            ),
                                                          ),
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                      color:
                                                          Colors.blue.shade100,
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 5,
                                                        ),
                                                    child: SelectedItemWidget(
                                                      showImage: false,

                                                      onRemove: () {
                                                        tagProvider
                                                            .removeTagSelection(
                                                              item.name,
                                                            );
                                                      },
                                                      title: item.name,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              SizedBox(
                                                width: double.infinity,
                                                child: TypeAheadField<TaskTag>(
                                                  decorationBuilder:
                                                      (context, child) {
                                                        return Material(
                                                          type:
                                                              MaterialType.card,
                                                          elevation: 4,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                          child: child,
                                                        );
                                                      },
                                                  offset: Offset(0, 12),
                                                  constraints: BoxConstraints(
                                                    maxHeight: 500,
                                                  ),
                                                  suggestionsCallback:
                                                      (String search) {
                                                        return tagProvider
                                                            .getTags(search);
                                                      },
                                                  builder: (context, controller, node) {
                                                    tagNode = node;
                                                    return SizedBox(
                                                      // height: tagProvider.selectedTagItems.isNotEmpty ? 10 : null,
                                                      child: TextField(
                                                        style: TextStyle(),
                                                        onChanged: (value) {
                                                          tagProvider
                                                              .searchTags(
                                                                value,
                                                              );
                                                        },
                                                        controller: controller,
                                                        focusNode: tagNode,
                                                        decoration: InputDecoration(
                                                          hint: Padding(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      10,
                                                                ),
                                                            child: Text(
                                                              tagProvider
                                                                      .selectedTagItems
                                                                      .isEmpty
                                                                  ? "Select Tags"
                                                                  : "",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade600,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),

                                                          focusedBorder:
                                                              InputBorder.none,

                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  itemBuilder: (context, suggestion) {
                                                    return Column(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            tagProvider.SelectTag(
                                                              suggestion,
                                                            );
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  ColorConstants
                                                                      .mainWhite,
                                                            ),
                                                            child: ListTile(
                                                              title: Text(
                                                                suggestion.name,
                                                                style: TextStyle(
                                                                  color: ColorConstants
                                                                      .mainBlack,
                                                                ),
                                                              ),
                                                              trailing:
                                                                  tagProvider
                                                                      .selectedTagItems
                                                                      .any(
                                                                        (u) =>
                                                                            u.id ==
                                                                            suggestion.id,
                                                                      )
                                                                  ? Icon(
                                                                      Icons
                                                                          .check,
                                                                      color: Colors
                                                                          .green,
                                                                    )
                                                                  : null,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                  emptyBuilder: (context) {
                                                    return Container(
                                                      width: double.infinity,
                                                      padding: EdgeInsets.all(
                                                        15,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: ColorConstants
                                                            .mainWhite,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        "No results found",
                                                        style: TextStyle(
                                                          color: ColorConstants
                                                              .primaryRed,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    );
                                                  },

                                                  onSelected: (value) {},
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                SizedBox(height: 20),

                                Text(
                                  "Task Description",
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                                SizedBox(height: 5),
                                CustomeEditForm(
                                  isdarkmode: isDarkTheme,
                                  maxLines: 4,
                                  focusNode: discriptionNode,
                                  controller: desccontroller,
                                ),

                                SizedBox(height: 20),
                                if (taskProvider.odooVersion != "17")
                                  Row(
                                    children: [
                                      Text(
                                        "Priority",
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),

                                      Row(
                                        children: List.generate(
                                          provider.getPriorityLength(
                                            taskProvider.odooVersion,
                                          ),
                                          (index) {
                                            return InkWell(
                                              onTap: () {
                                                provider.priority(index);
                                              },
                                              child:
                                                  index <=
                                                      provider.selectedIndex
                                                  ? Icon(
                                                      Icons.star,
                                                      color: Colors
                                                          .yellow
                                                          .shade600,
                                                    )
                                                  : Icon(
                                                      Icons.star_border_sharp,
                                                      color: Colors.grey,
                                                    ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        if (!widget.isEdit)
                          Expanded(
                            child: SaveButton(
                              backgroundColor: ColorConstants.backgroundWhite,
                              borderColor: ColorConstants.primaryRed,
                              texttColor: ColorConstants.primaryRed,
                              title: "Discard",
                              onTap: () {
                                provider.selectedIndex = -1;
                                titleController.clear();
                                deadlinecontroller.clear();
                                desccontroller.clear();
                                searchController.clear();
                                tagController.clear();
                                addtaskProvider.userList.clear();
                                addtaskProvider.selectedUserItems.clear();
                                addtaskProvider.isLoggedUserAutomaticallyAdded =
                                    false;
                                tagProvider.selectedTagItems.clear();
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        SizedBox(width: screenWidth * 0.020),
                        Expanded(
                          child: SaveButton(
                            onTap: () async {




                              final priorityCount = provider.selectedIndex + 1;
                              if (!formkey.currentState!.validate()) return;
                              showDialog(
                                context: context,

                                builder: (context) => ShowLoading(
                                  fucntion: widget.isEdit ? "update" : "add",
                                  action: "task",
                                  screenHeight: screenHeight,
                                  title: widget.isEdit
                                      ? "Updating Task..."
                                      : "Add Task...",
                                ),
                              );
                              try {
                                if (widget.isEdit) {
                                  await context
                                      .read<AddTaskProvider>()
                                      .updateTask(
                                        id: widget.id!,
                                        context,
                                        name: titleController.text,
                                        userId: addtaskProvider
                                            .selectedUserItems
                                            .map((u) => u.id)
                                            .toList(),
                                        deadline: deadlinecontroller.text
                                            .replaceAll(".000", ""),
                                        description: desccontroller.text,
                                        priority: priorityCount.toString(),
                                        tagId: tagProvider.selectedTagItems
                                            .map((t) => t.id)
                                            .toList(),
                                      );
                                } else {
                                  await context.read<AddTaskProvider>().addTask(
                                    context,
                                    name: titleController.text,
                                    userId: addtaskProvider.selectedUserItems
                                        .map((u) => u.id)
                                        .toList(),
                                    deadline: deadlinecontroller.text
                                        .replaceAll(".000", ""),
                                    description: desccontroller.text,
                                    priority: priorityCount,
                                    tagId: tagProvider.selectedTagItems
                                        .map((t) => t.id)
                                        .toList(),
                                  );
                                }
                                ;
                                Navigator.pop(context);
                                provider.selectedIndex = -1;
                                titleController.clear();
                                deadlinecontroller.clear();
                                desccontroller.clear();
                                searchController.clear();
                                tagController.clear();
                                addtaskProvider.userList.clear();
                                addtaskProvider.selectedUserItems.clear();
                                addtaskProvider.isLoggedUserAutomaticallyAdded =
                                    false;
                                tagProvider.selectedTagItems.clear();
                                context.read<TaskProvider>().fetchTasks();
                              } catch (e) {
                                Navigator.pop(context);

                              }
                            },
                            title: widget.isEdit ? "Update Task" : "Add Task",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

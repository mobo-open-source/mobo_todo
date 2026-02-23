import 'dart:developer';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart' show TypeAheadField;
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons/styles/stroke_rounded.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:mobo_todo/core/routing/page_transition.dart';
import 'package:mobo_todo/features/company/providers/company_provider.dart';
import 'package:mobo_todo/features/company/widgets/company_selector_widget.dart';
import 'package:mobo_todo/features/profile/pages/profile_screen.dart';
import 'package:mobo_todo/features/profile/providers/profile_provider.dart';
import 'package:mobo_todo/shared/widgets/snackbars/custom_snackbar.dart';

import 'package:mobo_todo/features/activity%20screen/model/activity_type_model.dart';
import 'package:mobo_todo/features/activity%20screen/provider/activity_provider.dart';
import 'package:mobo_todo/features/addTask%20screen/model/tag_model.dart';
import 'package:mobo_todo/features/addTask%20screen/model/user_model.dart';
import 'package:mobo_todo/features/addTask%20screen/provider/personal_stage_provider.dart';
import 'package:mobo_todo/features/dashboard%20screen/provider/dash_board_provider.dart';
import 'package:mobo_todo/features/addTask%20screen/provider/add_task_provider.dart';
import 'package:mobo_todo/features/addTask%20screen/provider/tag_provider.dart';
import 'package:mobo_todo/features/task%20screen/model/Task_model.dart';
import 'package:mobo_todo/features/task%20screen/provider/task_details_provider.dart';
import 'package:mobo_todo/features/task%20screen/provider/task_provider.dart';
import 'package:mobo_todo/features/addTask%20screen/screens/add_task_screen.dart';
import 'package:mobo_todo/core/utils/color_constants.dart';
import 'package:mobo_todo/core/widget/task_widget.dart';
import 'package:mobo_todo/features/task%20screen/screens/edit_task_screen.dart';
import 'package:mobo_todo/features/task%20screen/screens/task_details.screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController desccontroller = TextEditingController();
  TextEditingController deadlinecontroller = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController summaryController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController activityDateController = TextEditingController();
  TextEditingController activitySearchController = TextEditingController();
  TextEditingController assigneesSearchController = TextEditingController();
  final FocusNode searchNode = FocusNode();
  FocusNode ActivityNode = FocusNode();
  final FocusNode userNode = FocusNode();
  bool showDropdown = false;
  int selectedActivityType = 0;
  int selectedIndex = 0;
  int SelectedtagIndex = 0;
  final formkey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<TaskProvider>().fetchTasks();
      Provider.of<AddTaskProvider>(context, listen: false).fethcUsers();
      context.read<TaskDetailsProvider>().fetchAllTags();
      context.read<TaskDetailsProvider>().fetchAllUsers();
      context.read<TaskProvider>().searchFocus(searchNode);
      context.read<ActivityProvider>().fecthActivityType();
      context.read<ActivityProvider>().fethcActivityUsers();
      context.read<ActivityProvider>().focusActivity(ActivityNode);
    });
  }

  List<Widget> _buildProfileActions(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      // Company selector
      // CompanySelectorWidget(

      //     // Get the newly selected company name for better feedback
      //     final companyName =

      //     // Refresh profile data
      //       forceRefresh: true,
      //     // Show success message
      //     // Reload all feature providers with new company context
      //   },
      // ),
      Container(
        margin: const EdgeInsets.only(right: 8),
        child: Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) {
            final userAvatar = profileProvider.userAvatar;
            final isLoading = profileProvider.isLoading && userAvatar == null;
            return IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isLoading
                    ? SizedBox(
                        key: const ValueKey('avatar_loading'),
                        width: 32,
                        height: 32,
                        child: Shimmer.fromColors(
                          baseColor: isDark
                              ? Colors.grey[700]!
                              : Colors.grey[300]!,
                          highlightColor: isDark
                              ? Colors.grey[600]!
                              : Colors.grey[200]!,
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey[800] : Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      )
                    : (userAvatar != null
                          ? CircleAvatar(
                              key: const ValueKey('avatar_with_image'),
                              radius: 16,
                              backgroundColor: isDark
                                  ? Colors.grey[800]
                                  : Colors.grey[300],
                              backgroundImage: MemoryImage(userAvatar),
                            )
                          : CircleAvatar(
                              key: const ValueKey('avatar_placeholder'),
                              radius: 16,
                              backgroundColor: isDark
                                  ? Colors.grey[800]
                                  : Colors.grey[300],
                              child: HugeIcon(
                                icon: HugeIcons.strokeRoundedUserCircle,
                                color: isDark ? Colors.white70 : Colors.black54,
                                size: 18,
                              ),
                            )),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  dynamicRoute(context, const ProfileScreen()),
                ).then((_) {
                  // Refresh profile data after returning from profile screen
                  if (mounted) {
                    context.read<ProfileProvider>().fetchUserProfile(
                      forceRefresh: true,
                    );
                  }
                });
              },
            );
          },
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final activityProvider = Provider.of<ActivityProvider>(context);
    final personalStageProvider = Provider.of<PersonalStageProvider>(context);
    final taskDetailProvider = Provider.of<TaskDetailsProvider>(context);
    final tagProvider = Provider.of<TagProvider>(context);
    final dashboardProvider = Provider.of<DashBoardProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    return Scaffold(
      backgroundColor: isDarkTheme
          ? ColorConstants.grey900
          : ColorConstants.backgroundWhite,
      appBar: AppBar(
        backgroundColor: isDarkTheme
            ? ColorConstants.grey900
            : ColorConstants.backgroundWhite,
        actions: _buildProfileActions(context),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Tasks",
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              color: isDarkTheme
                  ? ColorConstants.mainWhite
                  : ColorConstants.mainBlack,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(135),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 15),
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: isDarkTheme
                            ? ColorConstants.Grey800
                            : ColorConstants.mainWhite,
                        border: Border.all(
                          width: 1,
                          color: searchNode.hasFocus
                              ? ColorConstants.primaryRed
                              : Colors.transparent,
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            color: isDarkTheme
                                ? ColorConstants.mainBlack
                                : Colors.grey.shade300,
                            offset: Offset(0, 1),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          context.read<TaskProvider>().searchTask(value);
                        },
                        focusNode: searchNode,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          hintText: 'Search by Task..',
                          hintStyle: TextStyle(
                            color: isDarkTheme
                                ? ColorConstants.mainWhite
                                : ColorConstants.mainBlack,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          border: InputBorder.none,
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 45,
                          ),
                          prefixIcon: InkWell(
                            child: HugeIcon(
                              icon: HugeIcons.strokeRoundedFilterHorizontal,
                              color: isDarkTheme
                                  ? ColorConstants.mainGrey
                                  : ColorConstants.balck87,
                              size: 18,
                            ),
                            onTap: () {
                              filterBottomsheet(
                                isDarkTheme,
                                context,
                                screenHeight,
                                taskProvider,
                                screenWidth,
                              );
                            },
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 13),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          if (taskProvider.appliedFilterItem.isNotEmpty)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black,
                              ),
                              ///////////////////////////////  filtertext section //////////////////////
                              child: Row(
                                children: [
                                  // HugeIcon(
                                  //   icon: HugeIcons
                                  //       .strokeRoundedFilterHorizontal,
                                  //   size: 15,

                                  //   color: ColorConstants.mainWhite,
                                  // ),
                                  SizedBox(width: 5),
                                  Text(
                                    "${taskProvider.appliedFilterItem.length} Active",
                                    style: TextStyle(
                                      color: ColorConstants.mainWhite,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          if (taskProvider.appliedFilterItem.isEmpty)
                            Column(
                              children: [
                                Text(
                                  "No filters applied",
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),

                          Spacer(),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: ColorConstants.mainGrey,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  color: isDarkTheme
                                      ? ColorConstants.Grey800
                                      : Colors.grey.shade100,
                                ),
                                child: Text(
                                  // "1-40/58"
                                  '${taskProvider.startIndex}-${taskProvider.endIndex}/${taskProvider.totalCount}',
                                  style: TextStyle(
                                    color: isDarkTheme
                                        ? ColorConstants.mainWhite
                                        : ColorConstants.mainBlack,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: HugeIcon(
                                  icon: HugeIcons.strokeRoundedArrowLeft01,
                                  color: taskProvider.canGoPrevious
                                      ? isDarkTheme
                                            ? ColorConstants.mainWhite
                                            : Colors.black
                                      : Colors.grey.withAlpha(80),
                                ),
                                onPressed: taskProvider.canGoPrevious
                                    ? () => taskProvider.previousPage(context)
                                    : null,
                              ),
                              IconButton(
                                icon: HugeIcon(
                                  icon: HugeIcons.strokeRoundedArrowRight01,
                                  color: taskProvider.canGoNext
                                      ? isDarkTheme
                                            ? ColorConstants.mainWhite
                                            : Colors.black
                                      : Colors.grey.withAlpha(80),
                                ),

                                onPressed: taskProvider.canGoNext
                                    ? () => taskProvider.nextPage(context)
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: HugeIcon(
          icon: HugeIcons.strokeRoundedPlusSign,
          color: isDarkTheme
              ? ColorConstants.mainBlack
              : ColorConstants.mainWhite,
        ),
        backgroundColor: isDarkTheme
            ? ColorConstants.mainWhite
            : ColorConstants.primaryRed,
        onPressed: () {
          context.read<TagProvider>().selectedTagItems.clear();
          context.read<TaskProvider>().selectedIndex == -1;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(isEdit: false),
            ),
          );
        },
      ),
      body: RefreshIndicator(
        backgroundColor: isDarkTheme
            ? ColorConstants.Grey800
            : ColorConstants.mainWhite,
        color: ColorConstants.primaryRed,
        onRefresh: () async {
          await context.read<TaskProvider>().fetchTasks();
        },
        child: SingleChildScrollView(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<TaskProvider>(
                  builder: (context, homeprovider, child) {
                    if (homeprovider.todoList.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: screenHeight * 0.20),
                                SizedBox(
                                  width: 130,
                                  child: Lottie.asset(
                                    'assets/lotties/empty ghost.json',
                                    repeat: true,
                                    animate: true,
                                  ),
                                ),
                                Text(
                                  "No Task found",
                                  style: TextStyle(
                                    color: ColorConstants.mainBlack,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 20),
                                if (taskProvider.appliedFilterItem.isNotEmpty)
                                  InkWell(
                                    onTap: () {
                                      context
                                          .read<TaskProvider>()
                                          .filterClear();
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 150,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: BoxBorder.all(
                                          color: ColorConstants.primaryRed,
                                        ),
                                        color: Colors.transparent,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Clear All filters",
                                          style: TextStyle(
                                            color: ColorConstants.primaryRed,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: homeprovider.todoList.length,
                      itemBuilder: (context, index) {
                        final todo = homeprovider.todoList[index];
                        return TasksListCard(
                          isDarkmode: isDarkTheme,
                          task: todo,
                          // title: todo.name,
                          // // description: todo.description ?? "",
                          // deadline: taskDetailProvider.deadlineAgo(
                          //   todo.dateDeadline,
                          // ),
                          // tags: "",
                          screenHeight: screenHeight,
                          onTap: () {
                            final allTags = taskDetailProvider.allTags;
                            final taskTags = allTags
                                .where((tag) => todo.tagIds.contains(tag.id))
                                .toList();
                            taskdetails(
                              context,
                              screenWidth,
                              isDarkTheme,
                              todo,
                              taskProvider,
                              taskDetailProvider,
                              taskTags,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> taskdetails(
    BuildContext context,
    double screenWidth,
    bool isDarkTheme,
    TaskModel todo,
    TaskProvider taskprovider,
    TaskDetailsProvider taskDetailProvider,
    List<TaskTag> taskTags,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(top: 60),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 800),
            child: IntrinsicHeight(
              child: Container(
                width: screenWidth,
                decoration: BoxDecoration(
                  color: isDarkTheme
                      ? ColorConstants.grey900
                      : ColorConstants.mainWhite,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// ================= HEADER =================
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        top: 20,
                        right: 15,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Task Details",
                              style: TextStyle(
                                color: isDarkTheme
                                    ? ColorConstants.mainWhite
                                    : ColorConstants.mainBlack,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          /// EDIT
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddTaskScreen(
                                    personalStageid: todo.personalStageId,
                                    personalStagename: todo.personalStageName,
                                    priority: todo.priority,
                                    assignees: todo.userNames.join(', '),
                                    tags: todo.tagIds,
                                    id: todo.id,
                                    isEdit: true,
                                    title: todo.name,
                                    deadline: todo.dateDeadline,
                                    description: todo.description,
                                  ),
                                ),
                              );
                            },
                            child: HugeIcon(
                              icon: HugeIcons.strokeRoundedPencilEdit02,
                              size: 26,
                              color: Colors.grey.shade700,
                            ),
                          ),

                          const SizedBox(width: 12),

                          /// CLOSE
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.close,
                              size: 24,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// TASK NAME
                            Text(
                              todo.name,
                              style: TextStyle(
                                color: ColorConstants.primaryRed,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            /// ASSIGNEES
                            Text(
                              todo.userNames.join(', '),
                              style: const TextStyle(fontSize: 16),
                            ),

                            const SizedBox(height: 8),

                            /// DESCRIPTION
                            if (todo.description != null)
                              Html(
                                data: todo.description!,
                                style: {
                                  "body": Style(
                                    margin: Margins.zero,
                                    padding: HtmlPaddings.zero,
                                    fontSize: FontSize(15),
                                    color: ColorConstants.mainGrey,
                                  ),
                                },
                              ),

                            const SizedBox(height: 10),

                            /// DEADLINE
                            ///
                            if (taskprovider.odooVersion == "19") ...[

                              if (todo.dateDeadline != null)
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
                                      style: TextStyle(
                                        color: isDarkTheme
                                            ? ColorConstants.mainWhite
                                            : ColorConstants.mainBlack,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        todo.dateDeadline.toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                              taskDetailProvider.isUrgent
                                              ? FontWeight.bold
                                              : FontWeight.w400,
                                          color: isDarkTheme
                                              ? ColorConstants.mainWhite
                                              : ColorConstants.mainBlack,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                 
                                  ],
                                ),
                                   const SizedBox(height: 12),
                            ],

                            /// TAGS
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: taskTags.map((tag) {
                                return Container(
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
                                          color: Colors.grey.shade300,
                                          blurRadius: 7,
                                          offset: const Offset(0, 2),
                                        ),
                                    ],
                                  ),
                                  child: Text(
                                    tag.name,
                                    style: const TextStyle(
                                      color: ColorConstants.mainBlack,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                            const SizedBox(height: 12),

                            /// PRIORITY
                            /// 
                            if(taskprovider.odooVersion == '19')...[

                                 Row(
                              children: List.generate(3, (index) {
                                final priority =
                                    int.tryParse(todo.priority ?? "0") ?? 0;
                                return Icon(
                                  index < priority
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: index < priority
                                      ? Colors.yellow.shade700
                                      : Colors.grey,
                                  size: 25,
                                );
                              }),
                            ),

                            const SizedBox(height: 20),
                            ],
                            if(taskprovider.odooVersion =="18")...[
    Row(
                              children: List.generate(1, (index) {
                                final priority =
                                    int.tryParse(todo.priority ?? "0") ?? 0;
                                return Icon(
                                  index < priority
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: index < priority
                                      ? Colors.yellow.shade700
                                      : Colors.grey,
                                  size: 25,
                                );
                              }),
                            ),

                            ]
                        
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> filterBottomsheet(
    bool isDarkTheme,
    BuildContext context,
    double screenHeight,
    TaskProvider taskProvider,
    double screenWidth,
  ) {
    return showModalBottomSheet(
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      backgroundColor: isDarkTheme ? ColorConstants.grey900 : Colors.white,
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.black38,
      builder: (sheetContext) {
        return DefaultTabController(
          length: 1,
          child: Consumer<TaskProvider>(
            builder: (context, provider, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Filter",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: HugeIcon(icon: HugeIcons.strokeRoundedCancel01),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),

                    decoration: BoxDecoration(
                      color: isDarkTheme
                          ? ColorConstants.grey900
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ButtonsTabBar(
                      backgroundColor: ColorConstants.primaryRed,
                      unselectedBackgroundColor: Colors.transparent,
                      labelStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        color: ColorConstants.balck87,
                        fontWeight: FontWeight.w500,
                      ),
                      radius: 10,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 65,
                      ),
                      tabs: [
                        Tab(text: "Filter"),
                      ],
                    ),
                  ),
                  if (provider.selectedFilterItem.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: screenHeight * 0.020),
                          Wrap(
                            children: [
                              if (provider.selectedFilterItem.isNotEmpty)
                                ...List.generate(
                                  provider.selectedFilterItem.length,
                                  (index) {
                                    final filterIndex =
                                        provider.selectedFilterItem[index];

                                    return Container(
                                      margin: EdgeInsets.all(5),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: ColorConstants.mainGrey,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        color: isDarkTheme
                                            ? ColorConstants.Grey800
                                            : Colors.red.shade50,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            filterIndex.toString(),
                                            style: TextStyle(
                                              color: isDarkTheme
                                                  ? ColorConstants.mainWhite
                                                  : ColorConstants.mainBlack,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          InkWell(
                                            onTap: () {
                                              provider.selectFilter(
                                                filterIndex,
                                              );
                                            },
                                            child: InkWell(
                                              onTap: () {
                                                provider.removeSelectedFilter(
                                                  index,
                                                );
                                              },
                                              child: HugeIcon(
                                                icon: HugeIconsStrokeRounded
                                                    .cancel01,
                                                size: 17,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Status",
                          style: TextStyle(
                            color: isDarkTheme
                                ? ColorConstants.mainWhite
                                : Colors.grey.shade900,

                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.010),
                        Wrap(
                          spacing: 6,
                          runSpacing: 10,
                          children: List.generate(taskProvider.filter.length, (
                            index,
                          ) {
                            final item = taskProvider.filter[index];
                            final isSelected = taskProvider.selectedFilterItem
                                .contains(item);
                            return GestureDetector(
                              onTap: () {
                                provider.selectFilter(index);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isSelected
                                        ? ColorConstants.primaryRed
                                        : ColorConstants.mainGrey,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  color: isSelected
                                      ? ColorConstants.primaryRed
                                      : isDarkTheme
                                      ? ColorConstants.Grey800
                                      : Colors.red.shade50,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (isSelected)
                                      HugeIcon(
                                        icon: HugeIcons.strokeRoundedTick02,
                                        color: ColorConstants.mainWhite,
                                        size: 16,
                                      ),
                                    SizedBox(width: 6),

                                    Text(
                                      item,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : isDarkTheme
                                            ? ColorConstants.mainWhite
                                            : Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                        SizedBox(height: 30),
                        InkWell(
                          onTap: () {
                            provider.filterClear();
                            Navigator.pop(context);
                          },
                          child: Container(
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: BoxBorder.all(
                                      color: ColorConstants.primaryRed,
                                    ),
                                    color: Colors.transparent,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Clear All",
                                      style: TextStyle(
                                        color: ColorConstants.primaryRed,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      final provider = context
                                          .read<TaskProvider>();
                                      provider.appliedFilterItem = List.from(
                                        provider.selectedFilterItem,
                                      );
                                      provider.fetchTasks();
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: ColorConstants.primaryRed,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Apply",
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
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class ActivityTextField extends StatelessWidget {
  final bool isdarkmode;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final String hintText;
  const ActivityTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.focusNode,
    required this.isdarkmode,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: BoxBorder.all(
            color: focusNode!.hasFocus
                ? ColorConstants.primaryRed
                : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(5),
          color: isdarkmode
              ? ColorConstants.grey900
              : ColorConstants.textFieldFillColor,
        ),
        child: TextField(
          focusNode: focusNode,

          controller: controller,
          decoration: InputDecoration(
            focusedBorder: InputBorder.none,
            hint: Text(
              hintText,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

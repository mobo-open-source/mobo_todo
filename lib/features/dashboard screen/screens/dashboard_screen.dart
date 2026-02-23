import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_todo/core/routing/page_transition.dart';
import 'package:mobo_todo/features/company/providers/company_provider.dart';
import 'package:mobo_todo/features/company/widgets/company_selector_widget.dart';
import 'package:mobo_todo/features/profile/pages/profile_screen.dart';
import 'package:mobo_todo/features/profile/providers/profile_provider.dart';
import 'package:mobo_todo/shared/widgets/snackbars/custom_snackbar.dart';
import 'package:mobo_todo/core/theme/app_theme.dart';
import 'package:mobo_todo/core/widget/shimmer_widgets/greeting_shimmer.dart';
import 'package:mobo_todo/features/activity%20screen/provider/activity_provider.dart';
import 'package:mobo_todo/features/activity%20screen/provider/old_acitivity_provider.dart';
import 'package:mobo_todo/features/activity%20screen/service/activity_service.dart';
import 'package:mobo_todo/features/addTask%20screen/provider/tag_provider.dart';
import 'package:mobo_todo/features/dashboard%20screen/provider/dash_board_provider.dart';
import 'package:mobo_todo/features/addTask%20screen/provider/add_task_provider.dart';
import 'package:mobo_todo/features/task%20screen/provider/task_provider.dart';
import 'package:mobo_todo/features/addTask%20screen/screens/add_task_screen.dart';
import 'package:mobo_todo/core/utils/color_constants.dart';
import 'package:mobo_todo/core/widget/task_count_widget.dart';
import 'package:mobo_todo/core/widget/task_overview_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // final sessionProvider = Provider.of<SessionProvider>(
      //   context,
      //   listen: false,
      context.read<TaskProvider>().fetchTasks();
      context.read<DashBoardProvider>().fetchAllTaskCount(context);
      context.read<DashBoardProvider>().fetchAllPendingTaskCount();
      context.read<DashBoardProvider>().fetchCompletedTaskCount();
      context.read<DashBoardProvider>().fetchmediumPriorityTaskCount();
      context.read<DashBoardProvider>().fetchLowpriorityTaskCount();
      context.read<DashBoardProvider>().fetchHighPriorityCount();
      context.read<DashBoardProvider>().fetchThisMonthTaskCount();
      context.read<DashBoardProvider>().fetchThisWeekTaskCount();
      context.read<DashBoardProvider>().fetchTodayTaskCount();
      context.read<DashBoardProvider>().getUser();
      context.read<ActivityProvider>().fetchActivities();
      context.read<ProfileProvider>().fetchUserProfile();
      context.read<AddTaskProvider>().fethcUsers();
      ActivityService service = ActivityService();
      Provider.of<OldAcitivityProvider>(
        context,
        listen: false,
      ).initActivityData(service);
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
    final homeProvider = Provider.of<DashBoardProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);
    final addTaskProvider = Provider.of<AddTaskProvider>(context);
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: HugeIcon(
          icon: HugeIcons.strokeRoundedPlusSign,
          color: isDarkTheme
              ? ColorConstants.mainBlack
              : AppTheme.secondaryColor,
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
      backgroundColor: isDarkTheme
          ? ColorConstants.grey900
          : ColorConstants.backgroundWhite,
      appBar: AppBar(
        backgroundColor: isDarkTheme
            ? ColorConstants.grey900
            : ColorConstants.backgroundWhite,
        actions: _buildProfileActions(context),
        // InkWell(
        //     Navigator.push(
        //       context,
        //   },
        //   child: CircleAvatar(
        //     radius: 20,
        //     backgroundColor: ColorConstants.mainWhite,
        //     backgroundImage: homeProvider.userImage != null
        //         : null,
        //     child: homeProvider.userImage == null
        //         ? HugeIcon(
        //             icon: HugeIcons.strokeRoundedUser,
        //             size: 22,
        //             color: ColorConstants.mainGrey,
        //           )
        //         : null,
        //   ),
        // ),
        title: Text(
          "Dashboard",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: isDarkTheme
                ? ColorConstants.mainWhite
                : ColorConstants.mainBlack,
          ),
        ),
      ),
      body: RefreshIndicator(
        backgroundColor: isDarkTheme
            ? ColorConstants.mainBlack
            : ColorConstants.mainWhite,
        color: ColorConstants.primaryRed,
        onRefresh: () async {
          context.read<DashBoardProvider>().fetchAllTaskCount(context);
          context.read<DashBoardProvider>().fetchAllPendingTaskCount();
          context.read<DashBoardProvider>().fetchCompletedTaskCount();
          context.read<DashBoardProvider>().fetchmediumPriorityTaskCount();
          context.read<DashBoardProvider>().fetchLowpriorityTaskCount();
          context.read<DashBoardProvider>().fetchHighPriorityCount();
          context.read<DashBoardProvider>().fetchThisMonthTaskCount();
          context.read<DashBoardProvider>().fetchThisWeekTaskCount();
          context.read<DashBoardProvider>().fetchTodayTaskCount();

          context.read<DashBoardProvider>().getUser();
          context.read<AddTaskProvider>().fethcUsers();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Consumer<DashBoardProvider>(
              builder: (context, provider, child) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  homeProvider.isLoading
                      ? GreetingHeaderShimmer()
                      : Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            color: ColorConstants.primaryRed,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      "${provider.greetings}  ${provider.username}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: ColorConstants.mainWhite,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 5),

                                    Text(
                                      "Manage Your Task Operation Efficiently",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: ColorConstants.mainWhite,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.transparent,
                                backgroundImage: provider.userImage != null
                                    ? MemoryImage(provider.userImage!)
                                    : null,
                                child: provider.userImage == null
                                    ? HugeIcon(
                                        icon: HugeIcons.strokeRoundedUser,
                                        size: 30,
                                        color: ColorConstants.mainWhite,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                  SizedBox(height: 20),
                  Text(
                    "Task Count",
                    style: TextStyle(
                      color: isDarkTheme
                          ? ColorConstants.mainWhite
                          : ColorConstants.mainBlack,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 7),
                      child: Row(
                        children: [
                          TaskCountWidget(
                            screenWidth: screenWidth,
                            title: "All Tasks",
                            Count: provider.totalTaskCount,
                            subtittle: "Total Task",
                            dividerColor: Colors.green,
                          ),
                          SizedBox(width: 15),
                          TaskCountWidget(
                            screenWidth: screenWidth,
                            title: "Pending Task",
                            Count: provider.pendingTaskCount,
                            subtittle: "Total Pending Task",
                            dividerColor: Colors.blue,
                          ),
                          SizedBox(width: 15),
                          TaskCountWidget(
                            screenWidth: screenWidth,
                            title: "Completed Task",
                            Count: provider.CompletedTaskCount,
                            subtittle: "Total completed Task",
                            dividerColor: Colors.greenAccent,
                          ),
                          SizedBox(width: 15),
                          if (taskProvider.odooVersion == "19") ...[
                           
                            TaskCountWidget(
                              screenWidth: screenWidth,
                              title: "High Priority Task",
                              Count: provider.highPriorityTaskCount,
                              subtittle: "Total High Priority Task",
                              dividerColor: Colors.red.shade300,
                            ),
                            SizedBox(width: 15),
                            TaskCountWidget(
                              screenWidth: screenWidth,
                              title: "Medium Priority Task",
                              Count: provider.mediumPriorityTaskCount,
                              subtittle: "Total Medium Priority Task",
                              dividerColor: Colors.orange,
                            ),
                            SizedBox(width: 15),
                            TaskCountWidget(
                              screenWidth: screenWidth,
                              title: "Low Priority Task",
                              Count: provider.lowPriorityTaskCount,
                              subtittle: "Tottal Low Priority Task",
                              dividerColor: Colors.lightGreen,
                            ),
                          ],
                          if (taskProvider.odooVersion == "18") ...[
                            TaskCountWidget(
                              screenWidth: screenWidth,
                              title: "High Priority Task",
                              Count: provider.mediumPriorityTaskCount,
                              subtittle: "Total High Priority Task",
                              dividerColor: Colors.red,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  // Text(
                  //   "Continue Working On",
                  // ),
                  // homeProvider.isLoading
                  //     : Container(
                  //         decoration: BoxDecoration(
                  //           color: ColorConstants.mainWhite,
                  //           boxShadow: [
                  //             BoxShadow(
                  //               color: Colors.grey.shade300,

                  //               blurRadius: 10,
                  //             ),
                  //           ],
                  //         ),
                  //         padding: EdgeInsets.symmetric(
                  //           horizontal: 20,
                  //           vertical: 30,
                  //         ),
                  //         child: Center(
                  //           child: Column(
                  //             children: [
                  //               HugeIcon(
                  //                 icon: HugeIcons.strokeRoundedClock01,
                  //                 size: 35,
                  //                 color: ColorConstants.mainGrey,
                  //               ),
                  //               Text(
                  //                 "No recent items",
                  //                 style: TextStyle(
                  //                   color: Colors.grey.shade800,
                  //                   fontSize: 15,
                  //                 ),
                  //               ),
                  //               Text(
                  //                 "Your recently viewed items will appear here",
                  //                 style: TextStyle(
                  //                   color: Colors.grey.shade600,
                  //                   fontWeight: FontWeight.w400,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  SizedBox(height: 20),
                  Text(
                    "Task Overview",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDarkTheme
                          ? ColorConstants.mainWhite
                          : ColorConstants.mainBlack,
                    ),
                  ),
                  SizedBox(
                    height: 15, // assignees: todo.userNames.join(', '),
                  ),
                  GridView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 10,
                      crossAxisCount: 2,
                      mainAxisExtent: 180,
                    ),
                    children: [
                      TaskOverviewWidget(
                        title: "Today",
                        count: provider.todayTaskCount.toString(),
                        icon: HugeIcons.strokeRoundedTaskDaily01,
                        iconColor: Colors.blue,
                        iconbackgroundColor: Colors.blue.shade50,
                        subtitle: "Manage Task This day",
                      ),
                      TaskOverviewWidget(
                        title: "This Week",
                        count: provider.weekTaskCount.toString(),
                        icon: HugeIcons.strokeRoundedCalendar01,
                        iconColor: Colors.orange,
                        iconbackgroundColor: Colors.orange.shade50,
                        subtitle: "Monitor This Week Task",
                      ),
                    ],
                  ),
                  TaskOverviewWidget(
                    title: "This Month",
                    count: provider.monthTaskCount.toString(),
                    icon: HugeIcons.strokeRoundedBook01,
                    iconColor: Colors.green,
                    iconbackgroundColor: Colors.green.shade50,
                    subtitle: "Track This Month Task",
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

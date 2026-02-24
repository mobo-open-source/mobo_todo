import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';
import 'package:mobo_todo/core/routing/page_transition.dart';
import 'package:mobo_todo/features/profile/pages/profile_screen.dart';
import 'package:mobo_todo/features/profile/providers/profile_provider.dart';
import 'package:mobo_todo/core/widget/activity_widget.dart';
import 'package:mobo_todo/features/activity%20screen/provider/activity_provider.dart';
import 'package:mobo_todo/core/utils/color_constants.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}
class _ActivityScreenState extends State<ActivityScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<ActivityProvider>().fetchActivities();
      context.read<ActivityProvider>().fecthActivityType();
      context.read<ActivityProvider>().fethcActivityUsers();
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
        title: Text(
          "Activities",
          style: TextStyle(
            color: isDarkTheme
                ? ColorConstants.mainWhite
                : ColorConstants.mainBlack,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.010),
              Consumer<ActivityProvider>(
                builder: (context, provider, child) {
                  if (provider.isloding) {
                    return Column(
                      children: [
                        ...List.generate(
                          10,
                          (index) => ActivityCardShimmer(
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),
                        ),
                      ],
                    );
                  }
                  if (provider.activity.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: screenHeight * 0.25),
                             SizedBox(
                                  width: 130,
                                  child: Lottie.asset(
                                    'assets/lotties/empty ghost.json',
                                    repeat: true,
                                    animate: true,
                                  ),
                                ),
                       
                          Text(
                            "No Activities",
                            style: TextStyle(
                              color: isDarkTheme
                                  ? ColorConstants.mainWhite
                                  : Colors.grey.shade800,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.030),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: provider.activity.length,
                    itemBuilder: (context, index) {
                      final activity = provider.activity[index];
                      return Activity_Widget(
                        isDarkmode: isDarkTheme,
                        activityId: activity.id,
                        activityTypeName: activity.activityTypeId[1],
                        assignees: activity.userId[1],
                        resmodel: activity.resName,
                        state: activity.state,
                        summary: activity.summary,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        deadline: activity.dateDeadline.toString(),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

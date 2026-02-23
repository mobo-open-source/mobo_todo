import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_todo/core/utils/color_constants.dart';
import 'package:mobo_todo/features/dashboard%20screen/provider/dash_board_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class TaskCountWidget extends StatelessWidget {
  final String title;
  final int Count;
  final String subtittle;
  final Color dividerColor;
  const TaskCountWidget({
    super.key,
    required this.screenWidth,
    required this.title,
    required this.Count,
    required this.subtittle,
    required this.dividerColor,
  });
  final double screenWidth;
  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final dashbordProvider = Provider.of<DashBoardProvider>(context);
    return Padding(
      padding: EdgeInsets.only(left: 3),
      child: dashbordProvider.isLoading
          ? CountCardShimmer(screenWidth: screenWidth, isDarkTheme: isDarkTheme)
          : Container(
              width: screenWidth * 0.60,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: isDarkTheme
                    ? ColorConstants.Grey800
                    : ColorConstants.mainWhite,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: isDarkTheme
                        ? ColorConstants.mainBlack
                        : ColorConstants.grey300,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      color: isDarkTheme
                          ? ColorConstants.mainWhite
                          : ColorConstants.mainBlack,
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedPencilEdit02,
                        color: isDarkTheme
                            ? ColorConstants.mainWhite
                            : ColorConstants.mainGrey,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "${Count.toString().isEmpty ? 0 : Count.toString()}",
                        style: TextStyle(
                          fontSize: 21,
                          color: isDarkTheme
                              ? ColorConstants.mainWhite
                              : ColorConstants.mainBlack,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    subtittle,
                    style: TextStyle(
                      color: isDarkTheme
                          ? ColorConstants.mainWhite
                          : Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 5),

                  Divider(
                    endIndent: screenWidth * 0.40,
                    color: dividerColor,
                    thickness: 3,
                  ),
                ],
              ),
            ),
    );
  }
}

class CountCardShimmer extends StatelessWidget {
  final double screenWidth;
  final bool isDarkTheme;

  const CountCardShimmer({
    super.key,
    required this.screenWidth,
    required this.isDarkTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: screenWidth * 0.60,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: isDarkTheme ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Shimmer.fromColors(
        baseColor: isDarkTheme ? const Color(0xFF2A2A2A) : Colors.grey.shade300,
        highlightColor: isDarkTheme
            ? const Color(0xFF3A3A3A)
            : Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
            _box(height: 14, width: 100, isDarkTheme: isDarkTheme),

            const SizedBox(height: 15),

            /// Icon + Count
            Row(
              children: [
                _box(
                  height: 22,
                  width: 22,
                  radius: 6,
                  isDarkTheme: isDarkTheme,
                ),
                const SizedBox(width: 10),
                _box(height: 24, width: 50, isDarkTheme: isDarkTheme),
              ],
            ),

            const SizedBox(height: 10),

            /// Subtitle
            _box(height: 12, width: 140, isDarkTheme: isDarkTheme),

            const SizedBox(height: 10),

            /// Divider
            Container(
              height: 3,
              width: screenWidth * 0.20,
              decoration: BoxDecoration(
                color: isDarkTheme
                    ? const Color(0xFF2F2F2F)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _box({
    required double height,
    required double width,
    double radius = 4,
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
}

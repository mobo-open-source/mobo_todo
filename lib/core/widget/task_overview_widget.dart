import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_todo/core/utils/color_constants.dart';
import 'package:mobo_todo/features/dashboard%20screen/provider/dash_board_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class TaskOverviewWidget extends StatelessWidget {
  final String count;
  final String title;
  final String subtitle;
  final List<List<dynamic>> icon;
  final Color iconColor;
  final Color iconbackgroundColor;
  const TaskOverviewWidget({
    super.key,
    required this.count,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconbackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final dashbordProvider = Provider.of<DashBoardProvider>(context);
    final mediaquery = MediaQuery.of(context);
    final screewidth = mediaquery.size.width;
    final screenheight = mediaquery.size.height;
    return Column(
      children: [
        dashbordProvider.isLoading
            ? AnalysisCardShimmer(
                screenWidth: screewidth,
                screenHeight: screenheight,
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                decoration: BoxDecoration(
                  color: isDarkTheme
                      ? ColorConstants.Grey800
                      : ColorConstants.mainWhite,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkTheme
                          ? ColorConstants.mainBlack
                          : Colors.grey.shade300,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${count.toString().isEmpty ? 0 : count.toString()}",
                            style: TextStyle(
                              color: isDarkTheme
                                  ? ColorConstants.mainWhite
                                  : ColorConstants.mainBlack,
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: isDarkTheme
                                  ? ColorConstants.mainWhite
                                  : Colors.grey.shade800,
                            ),
                          ),
                          SizedBox(height: screenheight * 0.005),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkTheme
                                  ? ColorConstants.mainGrey
                                  : Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: iconbackgroundColor,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                      child: HugeIcon(icon: icon, color: iconColor),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}

class AnalysisCardShimmer extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  const AnalysisCardShimmer({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });
  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
      decoration: BoxDecoration(
        color: isDarkTheme ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: isDarkTheme
            ? []
            : [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 10,
                  offset: const Offset(0, 1),
                ),
              ],
      ),
      child: Shimmer.fromColors(
        baseColor: isDarkTheme ? const Color(0xFF2A2A2A) : Colors.grey.shade300,
        highlightColor: isDarkTheme
            ? const Color(0xFF3A3A3A)
            : Colors.grey.shade100,
        child: Row(
          children: [
            /// Left content
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Count
                  _box(height: 22, width: 60, isDarkTheme: isDarkTheme),

                  const SizedBox(height: 20),

                  /// Title
                  _box(height: 25, width: 140, isDarkTheme: isDarkTheme),

                  SizedBox(height: screenHeight * 0.005),
                  /// Subtitle
                  _box(height: 15, width: 180, isDarkTheme: isDarkTheme),
                ],
              ),
            ),

            const SizedBox(width: 10),

            /// Icon placeholder
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isDarkTheme ? const Color(0xFF2F2F2F) : Colors.white,
              ),
              child: _box(
                height: 24,
                width: 24,
                radius: 6,
                isDarkTheme: isDarkTheme,
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
}

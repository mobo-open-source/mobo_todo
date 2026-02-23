
import 'package:flutter/material.dart';
import 'package:mobo_todo/core/utils/color_constants.dart';
import 'package:shimmer/shimmer.dart';

class TaskCardShimmer extends StatelessWidget {
  final double screenHeight;
  final bool isDarkmode;

  const TaskCardShimmer({
    super.key,
    required this.screenHeight,
    required this.isDarkmode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: isDarkmode
            ? const Color(0xFF1E1E1E)
            : ColorConstants.mainWhite,
        boxShadow: isDarkmode
            ? []
            : [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 7,
                  offset: const Offset(0, 1),
                ),
              ],
      ),
      child: Shimmer.fromColors(
        baseColor: isDarkmode
            ? const Color(0xFF2A2A2A)
            : Colors.grey.shade300,
        highlightColor: isDarkmode
            ? const Color(0xFF3A3A3A)
            : Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title + Icon row
            Row(
              children: [
                Expanded(
                  child: _shimmerBox(
                    height: 20,
                    width: double.infinity,
                    isDarkmode: isDarkmode,
                  ),
                ),
                const SizedBox(width: 10),
                _shimmerBox(
                  height: 22,
                  width: 22,
                  isDarkmode: isDarkmode,
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// Username
            _shimmerBox(
              height: 18,
              width: 150,
              isDarkmode: isDarkmode,
            ),

            SizedBox(height: screenHeight * 0.015),

            /// Deadline row
            Row(
              children: [
                _shimmerBox(
                  height: 20,
                  width: 20,
                  isDarkmode: isDarkmode,
                ),
                const SizedBox(width: 5),
                _shimmerBox(
                  height: 15,
                  width: 60,
                  isDarkmode: isDarkmode,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: _shimmerBox(
                    height: 15,
                    width: double.infinity,
                    isDarkmode: isDarkmode,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// Action icons
            Row(
              children: List.generate(
                3,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: _shimmerBox(
                    height: 22,
                    width: 22,
                    isDarkmode: isDarkmode,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBox({
    required double height,
    required double width,
    required bool isDarkmode,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: isDarkmode
            ? const Color(0xFF2F2F2F)
            : Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class GreetingHeaderShimmer extends StatelessWidget {
  const GreetingHeaderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme =
        Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: isDarkTheme
            ? const Color(0xFF1E1E1E)
            : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Shimmer.fromColors(
        baseColor: isDarkTheme
            ? const Color(0xFF2A2A2A)
            : Colors.grey.shade300,
        highlightColor: isDarkTheme
            ? const Color(0xFF3A3A3A)
            : Colors.white.withOpacity(0.9),
        child: Row(
          children: [
            /// Left text skeleton
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _shimmerBox(
                    height: 54,
                    width: 200,
                    isDarkTheme: isDarkTheme,
                  ),
                   SizedBox(height: 8),
                  _shimmerBox(
                    height: 16,
                    width: 260,
                    isDarkTheme: isDarkTheme,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            /// Avatar skeleton
            _ShimmerCircle(
              size: 60,
              isDarkTheme: isDarkTheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBox({
    required double height,
    required double width,
    required bool isDarkTheme,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: isDarkTheme
            ? const Color(0xFF2F2F2F)
            : Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

class _ShimmerCircle extends StatelessWidget {
  final double size;
  final bool isDarkTheme;

  const _ShimmerCircle({
    required this.size,
    required this.isDarkTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: isDarkTheme
            ? const Color(0xFF2F2F2F)
            : Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

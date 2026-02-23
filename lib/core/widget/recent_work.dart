
import 'package:flutter/material.dart';
import 'package:mobo_todo/core/utils/color_constants.dart';

class RecentWork extends StatelessWidget {
  final String title;
  final String desc;
  const RecentWork({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.title,
    required this.desc,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,

        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 0),

              color: Colors.grey.shade300,
              blurRadius: 2,
            ),
          ],
          color: ColorConstants.mainWhite,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.020,
          vertical: screenHeight * 0.020,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    overflow: TextOverflow.ellipsis,
                    title,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),

                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: ColorConstants.mainBlack,
                    ),
                  ),
                ],
              ),
            ),
            Text("Just now", style: TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
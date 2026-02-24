import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mobo_todo/core/utils/color_constants.dart';

class ShowLoading extends StatelessWidget {
  final String title;
  final String action;
  final String fucntion ;
  const ShowLoading({
    super.key,
    required this.screenHeight,
    required this.title, required this.action, required this.fucntion,
    
  });

  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Dialog(
        
        backgroundColor: ColorConstants.mainWhite,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.040),
      
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(29),
                  child: LoadingAnimationWidget.fourRotatingDots(
                    color: ColorConstants.primaryRed,
                    size: 50,
                  ),
                ),
              ),
      
              SizedBox(height: screenHeight * 0.070),
      
              Text(
                title,
                style: TextStyle(
                  color: ColorConstants.mainBlack,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: screenHeight * 0.020),
              Text(
               
                "Please wait while we $fucntion your $action ",
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
              SizedBox(height: screenHeight * 0.030),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobo_todo/core/utils/color_constants.dart';

class SaveButton extends StatelessWidget {
  final Color? borderColor;
  final Color? texttColor;
  final Color? backgroundColor;
  final void Function()? onTap;


  final String title;

  const SaveButton({super.key, required this.title, this.onTap,   this.borderColor, this.texttColor, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
       
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    
        decoration: BoxDecoration(
          color: backgroundColor ?? ColorConstants.primaryRed,
          borderRadius: BorderRadius.circular(10),
          border: BoxBorder.all(
            color:borderColor ?? Colors.transparent
          ),
      
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: texttColor ?? ColorConstants.mainWhite,
              fontWeight: FontWeight.bold,
    
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
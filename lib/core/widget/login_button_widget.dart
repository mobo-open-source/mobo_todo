import 'package:flutter/material.dart';
import 'package:mobo_todo/core/utils/color_constants.dart';

class loginButton extends StatelessWidget {

  final Color color;

  final void Function()?ontap;
  final String title;
  const loginButton({
    super.key, required this.title, this.ontap, required this.color, 
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
highlightColor: Colors.transparent,      
      onTap: ontap,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 700
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
      
          color: color
        ),
        child: Center(
          child: Text(
          title,
            style: TextStyle(
              color: ColorConstants.mainWhite,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
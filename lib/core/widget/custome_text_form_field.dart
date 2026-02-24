import 'package:flutter/material.dart';
import 'package:mobo_todo/core/utils/color_constants.dart';

class CustomeTaskField extends StatelessWidget {
  final  void Function()? onTap;
  final void Function()? calendarTap;
  final String? Function(String?)? validator;
  final bool ? isCalender;
  final bool? readOnly;
  final int? maxLines;
  final String hinttext;
  final TextEditingController? controller;
  const CustomeTaskField({
    super.key,
    this.controller,
    required this.hinttext,
    this.maxLines,
    this.readOnly,
    this.calendarTap,
    this.validator, this.isCalender, this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
    onTap: onTap,
      validator: validator,
      readOnly: readOnly ?? false,
      maxLines: maxLines,
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: isCalender == true
            ? InkWell(onTap: calendarTap, child: Icon(Icons.calendar_month))
            : null,
        focusedBorder: readOnly == false ?  OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: ColorConstants.primaryRed, width: 1),
        ) : OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: ColorConstants.mainGrey, width: 1),
        ) ,

        hintText: hinttext,
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),

          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}

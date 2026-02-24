import 'package:flutter/material.dart';
import 'package:mobo_todo/core/utils/color_constants.dart';

class CustomeEditForm extends StatelessWidget {
  final bool isdarkmode;
  final String? Function(String?)? validator;
  final String? hintetext;
  final bool readonly;
  final int? maxLines;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  CustomeEditForm({
    super.key,
    this.focusNode,
    this.controller,
    this.maxLines,
    this.readonly = false,
    this.validator,
    this.hintetext,
    required this.isdarkmode,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        border: BoxBorder.all(
          color: focusNode!.hasFocus
              ? ColorConstants.primaryRed
              : Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(10),
        color:isdarkmode ? ColorConstants.grey900 : ColorConstants.textFieldFillColor,
      ),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,

        validator: validator,
        readOnly: readonly,

        maxLines: maxLines,
        controller: controller,
        focusNode: focusNode,

        style: TextStyle(
          color: isdarkmode ? ColorConstants.mainGrey : ColorConstants.mainBlack,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hint: Text(
            hintetext ?? "",
            style: TextStyle(color: Colors.grey.shade600),
          ),
          focusedBorder: InputBorder.none,
          isDense: true,
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

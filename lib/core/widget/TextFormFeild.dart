import 'package:flutter/material.dart';

class CustomeTextForm extends StatelessWidget {
  final void Function(String)? onChanged;
  final bool obsecure;
 final TextEditingController? controller;
  final String hintText;
  final Color hintcolor;
  final String? Function(String?)? validator;
  const CustomeTextForm( this.obsecure ,{
    super.key, required this.hintText, this.validator, required this.hintcolor, this.controller, this.onChanged,   

  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      controller:controller,
      obscureText: obsecure,
      validator: validator,
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        hintText: hintText,
        hintStyle: TextStyle(
          color: hintcolor
        )
      ),
    );
  }
}
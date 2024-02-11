
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rolade_pos/styles/colors.dart';
class FormInputField extends StatelessWidget{
  TextEditingController controller;
  String? placeholder;
  String? label;
  IconData? prefixIcon;
  Color? backgroundColor;
  bool isNumeric;
  FocusNode? focus;


  FormInputField({
    required this.controller,
    this.placeholder,
    this.label,
    this.prefixIcon,
    this.backgroundColor,
    required this.isNumeric,
    this.focus
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: backgroundColor??Karas.background,
      ),
      child: TextField(
        controller: controller,
        focusNode: focus??FocusNode(),
        keyboardType: isNumeric!?TextInputType.number:TextInputType.text,
        inputFormatters: isNumeric!?<TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ]:[],
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: placeholder,
          contentPadding: EdgeInsets.symmetric(horizontal: 15)
        ),
      ),
    );
  }

}
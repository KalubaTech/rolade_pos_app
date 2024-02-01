import 'package:flutter/material.dart';
import 'package:rolade_pos/styles/colors.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

class Button1 extends StatelessWidget {
  String label;
  double? height;
  double? width;
  Function() tap;
  TextStyle? textStyle;
  Color? backgroundColor;

  Button1({required this.label, required this.tap, this.backgroundColor, this.textStyle, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return TouchRippleEffect(
      onTap: tap,
      borderRadius: BorderRadius.circular(8),
      rippleColor: Colors.grey.withOpacity(0.3),
      child: Container(
        height: height??30,
        width: double.infinity,
        decoration: BoxDecoration(
           color: backgroundColor??Karas.primary,
           borderRadius: BorderRadius.circular(8)
        ),
        child: Center(child: Text(label,style: textStyle??TextStyle(color: Colors.white),)),
      ),
    );
  }
}

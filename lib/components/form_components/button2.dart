import 'package:flutter/material.dart';
import 'package:rolade_pos/styles/colors.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

class Button2 extends StatelessWidget {
  Widget content;
  double? height;
  double? width;
  final void Function() tap;
  TextStyle? textStyle;
  Color? backgroundColor;
  Border? border;

  Button2({
    required this.content,
    required this.tap,
    this.backgroundColor,
    this.textStyle, // Provide a default value or make it required if necessary
    this.height,
    this.width,
    this.border,
  });


  @override
  Widget build(BuildContext context) {
    return TouchRippleEffect(
      onTap: tap,
      borderRadius: BorderRadius.circular(8),
      rippleColor: Colors.grey.withOpacity(0.6),
      child: Container(
        height: height??30,
        width: double.infinity,
        decoration: BoxDecoration(
           color: backgroundColor??Karas.primary,
           borderRadius: BorderRadius.circular(8),
           border: border
        ),
        child: Center(child: content),
      ),
    );
  }
}

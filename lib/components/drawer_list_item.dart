import 'package:flutter/material.dart';
import 'package:rolade_pos/styles/title_styles.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

import '../styles/colors.dart';

class DrawerListItem extends StatelessWidget {
  String title;
  Widget? trailing;
  Widget? leading;
  void Function() tap;
  DrawerListItem({required this.title, this.leading, this.trailing, required this.tap});

  @override
  Widget build(BuildContext context) {
    return TouchRippleEffect(
        rippleColor: Colors.grey.withOpacity(0.3),
        onTap: tap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: BorderDirectional(
              bottom: BorderSide(color: Karas.secondary)
            )
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            children: [
              leading??Container(),
              Expanded(
                  child: Text(title, style: title3,)
              ),
              trailing??Container()
            ],
          ),
        )
    );
  }
}

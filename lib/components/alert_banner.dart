import 'package:flutter/material.dart';
import 'package:rolade_pos/styles/colors.dart';

class AlertBanner extends StatelessWidget {
  String message;
  Widget? child;
  TextStyle?  messageTextStyle;
  
  AlertBanner({required this.message, this.child, this.messageTextStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.grey,blurRadius: 2, offset: Offset(0, 1))
        ]
      ),
      child: Row(
        children: [
          CircleAvatar(
              backgroundColor: Karas.secondary,
              child: Icon(Icons.warning_amber, color: Colors.orange)
          ),
          SizedBox(width: 10,),
          Expanded(child: Text(message, style: messageTextStyle??TextStyle(color: Colors.deepOrange.shade300, fontSize: 14, fontWeight: FontWeight.w500),)),
          child??Container()
        ],
      ),
    );
  }
}

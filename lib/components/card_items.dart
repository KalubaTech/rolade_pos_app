import 'package:flutter/material.dart';

class CardItems extends StatelessWidget {
  Widget head;
  Widget body;
  CardItems({required this.head, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey,blurRadius: 2, offset: Offset(0, 1))
          ]
      ),
      child: Column(
        children: [
          head,
          body
        ],
      ),
    );
  }
}

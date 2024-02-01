import 'package:flutter/material.dart';
import 'package:rolade_pos/styles/colors.dart';
class SearchMock extends StatelessWidget {
  String placeholder;
  SearchMock({required this.placeholder});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Karas.background,
        borderRadius: BorderRadius.circular(10)
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey,),
          SizedBox(width: 5,),
          Expanded(
              child: Container(
                child: Text(placeholder,style: TextStyle(color: Colors.grey),)
              )
          )
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rolade_pos/controllers/user_controller.dart';

import '../styles/colors.dart';
import 'package:get/get.dart';




class HeaderAvatar extends StatelessWidget {
  HeaderAvatar({Key? key}) : super(key: key);

  UserController _userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hey 😊', style: TextStyle(color: Karas.white, fontSize: 12),),
          SizedBox(height: 5,),
          Text('${_userController.user.value.displayName}', style: TextStyle(color: Karas.white, fontSize: 12),),
        ],
    ),
    );
  }
}

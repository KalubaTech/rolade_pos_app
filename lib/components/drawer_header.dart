import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rolade_pos/controllers/store_controller.dart';
import 'package:rolade_pos/styles/title_styles.dart';
import '../controllers/user_controller.dart';
import '../styles/colors.dart';


class CustomDrawerHeader extends StatelessWidget {
  CustomDrawerHeader({Key? key}) : super(key: key);

  UserController _userController = Get.find();
  StoreController _storeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [

        Container(
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Karas.background,
              image: DecorationImage(
                  image: AssetImage('assets/logo_splash.png')
              )
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Karas.primary.withOpacity(0.8),
            ),
          ),
        ),
        Positioned(
            bottom: -30,
            child: Column(
              children: [
                Container(
                  width: Get.width-80,
                  padding: EdgeInsets.symmetric(vertical:16, horizontal: 20),
                  child: Text('${_storeController.store.value.name}', style: titlewhite,textAlign: TextAlign.center,),
                ),
                Container(
                  width: Get.width-70,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        width: 80,
                        height: 80,
                        imageUrl: _userController.user.value.photo,
                        errorWidget: (c,e,i)=>CircleAvatar(
                          backgroundImage: AssetImage('assets/avatar_placeholder.jpg'),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
        ),
      ],
    );
  }
}

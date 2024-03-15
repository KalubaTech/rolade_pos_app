import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rolade_pos/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:rolade_pos/models/user_model.dart';
import 'package:rolade_pos/styles/colors.dart';
import 'package:rolade_pos/styles/title_styles.dart';
import 'package:rolade_pos/views/home.dart';
import 'package:rolade_pos/views/intro_views/create_store.dart';
import 'package:rolade_pos/views/pages_anchor.dart';

import 'methods.dart';

var _connectionStatus = ''.obs;
bool mounted = true;
Future<void> _initConnectivity() async {
  ConnectivityResult result;
  try {
    result = await Connectivity().checkConnectivity();
  } catch (e) {
    print(e.toString());
    result = ConnectivityResult.none;
  }

  if (!mounted) {
    return;
  }

    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        _connectionStatus.value = 'Connected';
        break;
      case ConnectivityResult.none:
        _connectionStatus.value = 'No Internet Connection';
        break;
      default:
        _connectionStatus.value = 'Unknown';
        break;
    }

}


void signInUp({String? displayName, String? photo, required String email, String? phone})async{
  UserController userController = Get.find();
  Methods _methods = Methods();

  await FirebaseFirestore.instance.collection('store_user')
      .where('user', isEqualTo: email).where('active',isEqualTo: true)
      .get().then((value){
    if(value.docs.length>0) {
      _methods.getMyStore(email);
      FirebaseFirestore.instance.collection('users')
          .where('email', isEqualTo: email).get().then((user) {
        userController.user.value = photo==null?UserModel(
            uid: user.docs.first.id,
            email: user.docs.first.get('email'),
            displayName: value.docs.first.get('name'),
            phone: '',
            photo: '${user.docs.first.get('photo')}',
            datetime: value.docs.first.get('datetime'),
            password: user.docs.first.get('password')
        ):UserModel(
            uid: user.docs.first.id,
            email: user.docs.first.get('email'),
            displayName: value.docs.first.get('name'),
            phone: '',
            photo: '$photo',
            datetime: value.docs.first.get('datetime'),
            password: user.docs.first.get('password')
        );

        Map<String,dynamic> data = photo==null? {
          'displayName':value.docs.first.get('name')
        } : {
          'photo':'$photo',
          'displayName':value.docs.first.get('name')
        };

        FirebaseFirestore.instance.collection('users')
            .doc(user.docs.first.id).update(
            data
        ).then((value) {
          GetStorage().write('user', email);
          return Get.offAll(()=>PagesAnchor());
        });


        return null;
      });

    }else{
      Get.defaultDialog(
          title: 'Unknown User',
          titleStyle: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
          titlePadding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
          content: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(
                  'This Email Is Either Deactivated Or Not Associated With Any Store On The System.',
                  style: title1,textAlign: TextAlign.center,),
                SizedBox(height: 10,),
                Text('Kindly Contact the Store Admin or reach us on +260962407441 for help.', textAlign:TextAlign.center,style: TextStyle(color: Karas.primary, fontSize: 14, fontWeight: FontWeight.w600),)
              ],
            ),
          )
      );
    };



  });}
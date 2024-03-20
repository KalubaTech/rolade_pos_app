import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rolade_pos/components/form_components/button1.dart';
import 'package:rolade_pos/styles/colors.dart';
import 'package:rolade_pos/styles/title_styles.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:rolade_pos/views/pages_anchor.dart';
import '../../helpers/sign_up_helper.dart';

class SignSilently extends StatefulWidget {
  const SignSilently({Key? key}) : super(key: key);

  @override
  State<SignSilently> createState() => _SignSilentlyState();
}

class _SignSilentlyState extends State<SignSilently> {


  ConnectivityWrapper connnectivity = ConnectivityWrapper.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    signInUp(email: GetStorage().read('user'));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Karas.secondary,
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.width,
          width: MediaQuery.of(context).size.width,
          child:FutureBuilder(
            future: ConnectivityWrapper.instance.isHostReachable(AddressCheckOptions(hostname: 'www.google.com')),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                if(snapshot.data!.isSuccess){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.fourRotatingDots( size: 40, color: Karas.primary),
                      SizedBox(height: 10),
                      Text('Fetching data...', style: title2,)
                    ],
                  );
                }else{
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/nointernet.png', width: 250,),
                      SizedBox(height: 10),
                      Text('NO INTERNET CONNECTION', style: title1,),
                      SizedBox(height: 50,),
                      Button1(
                        width: 300,
                        label: 'Continue',
                        tap: () {
                          Get.to(()=>PagesAnchor());
                        },
                      )
                    ],
                  ); //No connection
                }
              }else{
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingAnimationWidget.fourRotatingDots( size: 40, color: Karas.primary),
                    SizedBox(height: 10),
                    Text('Fetching data...', style: title2,)
                  ],
                );
              }
            }
          ),
        ),
      ),
    );
  }
}

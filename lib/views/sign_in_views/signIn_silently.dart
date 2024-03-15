import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rolade_pos/styles/colors.dart';
import 'package:rolade_pos/styles/title_styles.dart';

import '../../helpers/sign_up_helper.dart';

class SignSilently extends StatefulWidget {
  const SignSilently({Key? key}) : super(key: key);

  @override
  State<SignSilently> createState() => _SignSilentlyState();
}

class _SignSilentlyState extends State<SignSilently> {

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingAnimationWidget.fourRotatingDots( size: 40, color: Karas.primary),
              SizedBox(height: 10),
              Text('Configuring...', style: title2,)
            ],
          ),
        ),
      ),
    );
  }
}

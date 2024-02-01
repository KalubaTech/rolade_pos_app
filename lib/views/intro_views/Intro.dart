import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rolade_pos/components/form_components/button2.dart';
import 'package:rolade_pos/views/intro_views/create_store.dart';
import 'package:rolade_pos/views/sign_in_views/sign_up.dart';

import '../../styles/colors.dart';

class Intro1 extends StatelessWidget {
  const Intro1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        color: Karas.primary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30,),
            Text("Let's Setup Your Store", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),),
            SizedBox(height: 20,),
            Spacer(),
            Button2(
                  height: 40,
                  border: Border.all(color: Karas.background),
                  content: Text('GET STARTED', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  tap: (){
                    Get.to(()=>SignUp());
                  }
            ),
            SizedBox(height: 50,)
          ],
        ),
      ),
    )
    );
  }
}

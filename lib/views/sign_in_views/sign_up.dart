import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rolade_pos/components/card_items.dart';
import 'package:rolade_pos/components/form_components/button1.dart';
import 'package:rolade_pos/components/form_components/button2.dart';
import 'package:rolade_pos/components/form_components/form_input_field.dart';
import 'package:rolade_pos/helpers/google_sign_helper.dart';
import 'package:rolade_pos/helpers/sign_up_helper.dart';
import 'package:rolade_pos/styles/title_styles.dart';
import 'package:get/get.dart';
import '../../styles/colors.dart';


class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GoogleSignInHelper googleSignInHelper = GoogleSignInHelper();

  @override
  Widget build(BuildContext context) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Karas.secondary,
          body: Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            height: double.infinity,
            child: CardItems(
                head: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      Text('SIGN UP', style: title1,),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),
                body:  Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email or username', style: title3,),
                      SizedBox(height: 10,),
                      FormInputField(
                        controller: emailController,
                        isNumeric: false,
                        placeholder: 'Enter your email or username',
                        backgroundColor: Karas.secondary,
                      ),
                      SizedBox(height: 15),
                      Text('Password', style: title3,),
                      SizedBox(height: 10,),
                      FormInputField(
                        controller: emailController,
                        isNumeric: false,
                        placeholder: 'Enter your password',
                        backgroundColor: Karas.secondary,
                      ),
                      SizedBox(height: 20,),
                      Button1(
                          label: 'Sign In',
                          tap: ()=>null,
                          height: 40
                      ),
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Expanded(child: Container(color: Karas.background,height: 0.5,)),
                          SizedBox(width: 10,),
                          Text('  OR  ', style: title3,),
                          SizedBox(width: 10,),
                          Expanded(child: Container(color: Karas.background,height: 0.5,))
                        ],
                      ),
                      SizedBox(height: 20),
                      Button2(
                        height: 40,
                          border: Border.all(color: Karas.primary),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/google.png', width: 20,),
                              SizedBox(width: 10,),
                              Text('Sign In with Google', style: title4,)
                            ],
                          ),
                          tap: ()async{
                            Get.dialog(
                              Center(
                                child: LoadingAnimationWidget.flickr(leftDotColor: Colors.deepOrange, rightDotColor: Karas.primary, size: 30),
                              ),
                              barrierDismissible: false,
                              barrierColor: Colors.black12
                            );
                            User? user = await googleSignInHelper.signInWithGoogle();
                            signInUp(
                                email: '${user!.email}',
                                displayName: '${user!.displayName}',
                                photo: '${user!.photoURL}',
                                phone: '',
                            );
                            Get.back();
                          },
                          backgroundColor: Karas.secondary,
                      )
                    ],
                  ),
                )
            ),
          ),
        ),
      );
  }
}

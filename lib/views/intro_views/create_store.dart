import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rolade_pos/components/card_items.dart';
import 'package:rolade_pos/components/card_items_header.dart';
import 'package:rolade_pos/components/form_components/button1.dart';
import 'package:rolade_pos/components/form_components/form_input_field.dart';
import 'package:rolade_pos/styles/colors.dart';
import 'package:rolade_pos/styles/title_styles.dart';
import 'package:get/get.dart';
import 'package:rolade_pos/views/pages_anchor.dart';
import '../../controllers/user_controller.dart';

class CreateStore extends StatelessWidget {
  CreateStore({Key? key}) : super(key: key);

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  UserController _userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Karas.secondary,
          body: Container(
            height: double.infinity,
            padding: EdgeInsets.all(18),
            child: ListView(
              shrinkWrap: true,
              children: [
                Text('New Store', style: title1,),
                SizedBox(height: 8,),
                Text("Create Your Store.", style: title4,),
                SizedBox(height: 40,),
                CardItems(
                    head: CardItemsHeader(title: 'Store Details'),
                    body: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          FormInputField(
                            isNumeric: false,
                            controller: nameController,
                            backgroundColor: Karas.secondary,
                            placeholder: 'Store Name',
                          ),
                          SizedBox(height: 15,),
                          FormInputField(
                            isNumeric: false,
                            controller: descriptionController,
                            backgroundColor: Karas.secondary,
                            placeholder: 'Description',
                          ),
                          SizedBox(height: 15,),
                        ],
                      ),
                    )
                ),
                SizedBox(height: 20),
                Button1(
                    height: 35,
                    label: 'SAVE',
                    tap: ()async{

                      if(nameController.text.isNotEmpty){

                        Map<String,dynamic>data = {
                          'name':nameController.text,
                          'description':descriptionController.text,
                          'email':_userController.user.value.email,
                          'datetime': '${DateTime.now()}'
                        };

                        await FirebaseFirestore.instance.collection('store').add(data).then((value){
                          FirebaseFirestore.instance.collection('store_user').add({
                            'store_id':value.id,
                            'user':_userController.user.value.email,
                            'datetime':'${DateTime.now()}'
                          });
                          Get.offAll(()=>PagesAnchor());
                        });
                      }else{

                      }
                    }
                )
              ],
            ),
          ),
        )
    );
  }
}

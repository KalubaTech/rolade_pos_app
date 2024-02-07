import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rolade_pos/components/card_items.dart';
import 'package:rolade_pos/components/card_items_header.dart';
import 'package:rolade_pos/controllers/store_controller.dart';
import 'package:rolade_pos/controllers/user_controller.dart';
import 'package:rolade_pos/helpers/methods.dart';
import 'package:rolade_pos/models/user_model.dart';
import 'package:rolade_pos/styles/colors.dart';
import 'package:rolade_pos/styles/title_styles.dart';
import 'package:rolade_pos/views/settings/working_hours.dart';
import 'package:rolade_pos/views/super_admin/onboard.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

import '../../helpers/date_formater.dart';


class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);


  UserController _userController = Get.find();
  StoreController _storeController = Get.find();

  Methods _methods = Methods();

  FirebaseFirestore fs = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    UserModel user = _userController.user.value;
    return SafeArea(
        child: DraggableHome(
          appBarColor: Karas.primary,
          body: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CardItems(
                  head: CardItemsHeader(
                    title: 'Store Settings', 
                    seeallbtn: _userController.user.value.email==_storeController.store.value.email?TouchRippleEffect(
                      onTap: ()=>_methods.editStore(fs),
                      rippleColor: Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Karas.secondary,
                        child: Icon(Icons.edit, size: 15,)
                                        ),
                    ):Container()),
                  body: GetBuilder<StoreController>(
                    builder:(controllerStore)=> Container(
                      child: Column(
                        children: [
                          ListTile(
                            title: Text('${controllerStore.store.value.name}', style: TextStyle(fontWeight: FontWeight.w500),),
                            subtitle: Text('Store Name', style: TextStyle(fontSize: 13),),
                          ),
                          Container(height: 1,color: Karas.secondary,width: double.infinity,),
                          ListTile(
                            title: Text('${controllerStore.store.value.description}', style: TextStyle(fontWeight: FontWeight.w500),),
                            subtitle: Text('Description', style: TextStyle(fontSize: 13),),
                          ),
                          Container(height: 1,color: Karas.secondary,width: double.infinity,),
                          ListTile(
                            title: Text('${formatDate(controllerStore.store.value.datetime)}', style: TextStyle(fontWeight: FontWeight.w500),),
                            subtitle: Text('Onboard Date', style: TextStyle(fontSize: 13),),
                          ),
                        ],
                      ),
                    ),
                  )
              ),
            ),
            SizedBox(height: 18,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CardItems(
                  head: CardItemsHeader(
                    title: 'Cashiers',
                    seeallbtn: _userController.user.value.email==_storeController.store.value.email?TouchRippleEffect(
                      rippleColor: Colors.green.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      onTap: ()=>_methods.addUser(fs),
                      child: Container(
                          padding:EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 3),
                          child: Text('Add New', style: title3,)
                      ),
                    ):Container(),
                  ),
                  body: Container(
                    child: StreamBuilder(
                      stream:fs.collection('store_user')
                      .where('store_id', isEqualTo: _storeController.store.value.id)
                      .snapshots(),
                        builder: (context, snapshot) {
                        return snapshot.hasData && snapshot.data!.docs.length>0?ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.size,
                          itemBuilder: (context,index){
                            return snapshot.data!.docs[index].get('user')!=user.email?ListTile(
                              title: Text('${snapshot.data!.docs[index].get('name')}', style: TextStyle(color: snapshot.data!.docs[index].get('active')?Colors.black:Colors.red,fontWeight: !snapshot.data!.docs[index].get('active')?FontWeight.normal:FontWeight.w500),),
                              subtitle: Text('${snapshot.data!.docs[index].get('user')}', style: TextStyle(fontSize: 13),),
                              trailing: _userController.user.value.email==_storeController.store.value.email?GestureDetector(
                                onTap: ()=>_methods.editUser(snapshot.data!.docs[index], fs),
                                child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Karas.secondary,
                                    child: Icon(Icons.edit, size: 15,)
                                ),
                              ):Container(),
                            ):Container();
                          },
                        ):Container();
                      }
                    ),
                  )
              ),
            ),
            SizedBox(height: 18,),
            _userController.user.value.email==_storeController.store.value.email?Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CardItems(
                  head: CardItemsHeader(
                    title: 'Working Hours',
                    seeallbtn: TouchRippleEffect(
                      rippleColor: Colors.green.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      onTap: ()=>Get.to(()=>WorkingHours()),
                      child: Container(
                          padding:EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 3),
                          child: Text('Add', style: title3,)
                      ),
                    ),
                  ),
                  body: Container(
                    child: Container(),
                  )
              ),
            ):Container(),
            SizedBox(height: 20,),
            _userController.user.value.email==_storeController.store.value.email?Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CardItems(
                  head: CardItemsHeader(
                    title: 'Super Admin, Onboard Stores',
                    seeallbtn: TouchRippleEffect(
                      rippleColor: Colors.green.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      onTap: ()=>Get.to(()=>Onboard()),
                      child: Container(
                          padding:EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 3),
                          child: Text('Add Store', style: title3,)
                      ),
                    ),
                  ),
                  body: Container(
                    child: Container(),
                  )
              ),
            ):Container(),
            SizedBox(height: 50,),
          ],
          headerWidget: Container(
            child:GetBuilder<UserController>(
              builder: (userC) {
                return Container(
                  width: double.infinity,
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 20),
                  color: Karas.background,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        foregroundImage: NetworkImage('${userC.user.value.photo}'),
                      ),
                      SizedBox(height: 15,),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              child: Center(
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    GestureDetector(onTap: ()=>_methods.editMyName(fs),child: Text('${userC.user.value.displayName}', style: title1,)),
                                    Positioned(
                                      right: -15,
                                      top: -10,
                                      child: TouchRippleEffect(
                                        onTap: ()=>_methods.editMyName(fs),
                                        rippleColor: Colors.grey.withOpacity(0.4),
                                        borderRadius: BorderRadius.circular(20),
                                        child: Icon(Icons.edit, size: 15,color: Colors.blue,),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        child: Column(
                          children: [
                            Text('${userC.user.value.email}', style: title4,)
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            ),
          ),
          title: Text('Settings'),
        )
    );
  }
}

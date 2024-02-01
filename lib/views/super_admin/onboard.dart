import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:rolade_pos/components/card_items.dart';
import 'package:rolade_pos/components/card_items_header.dart';
import 'package:rolade_pos/components/form_components/button1.dart';
import 'package:rolade_pos/components/form_components/button2.dart';
import 'package:rolade_pos/components/form_components/form_input_field.dart';
import 'package:rolade_pos/components/location_picker.dart';
import 'package:rolade_pos/controllers/picked_location.dart';
import 'package:rolade_pos/styles/title_styles.dart';
import 'package:get/get.dart';
import '../../styles/colors.dart';

class Onboard extends StatelessWidget {
  Onboard({Key? key});

  TextEditingController _storenameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _subscriptionController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _districtController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  String province = '';
  String district = '';

  List<String> provinces = [
    'Central Province',
    'Copperbelt Province',
    'Eastern Province',
    'Luapula Province',
    'Lusaka Province',
    'Muchinga Province',
    'Northern Province',
    'North-Western Province',
    'Southern Province',
    'Western Province',
  ];


  @override
  Widget build(BuildContext context) {
    return DraggableHome(
        title: Text('Onboard Form'),
        headerWidget: Container(),
        headerExpandedHeight: 0.1,
        alwaysShowTitle: true,
        alwaysShowLeadingAndAction: true,
        body: [
          CardItems(
              head: CardItemsHeader(title: 'Store Details'),
              body: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Text('Store Name', style: title4,),
                    SizedBox(height: 10,),
                    FormInputField(
                        controller: _storenameController,
                        isNumeric: false,
                        placeholder: 'Store Name',
                    ),
                    SizedBox(height: 15,),
                    Text('Description', style: title4,),
                    SizedBox(height: 10,),
                    FormInputField(
                        controller: _descriptionController,
                        isNumeric: false,
                        placeholder: 'Description',
                    ),
                    SizedBox(height: 15,),
                    Text('Email (Admin)', style: title4,),
                    SizedBox(height: 10,),
                    FormInputField(
                        controller: _emailController,
                        isNumeric: false,
                        placeholder: 'Email',
                    ),
                    Text('Phone Number', style: title4,),
                    SizedBox(height: 10,),
                    FormInputField(
                        controller: _phoneController,
                        isNumeric: true,
                        placeholder: 'Phone Number',
                    ),
                    SizedBox(height: 15,),
                    Text('Subscription Fee (K)', style: title4,),
                    SizedBox(height: 10,),
                    FormInputField(
                        controller: _subscriptionController,
                        isNumeric: true,
                        placeholder: 'Subscription Fee',
                    ),
                    SizedBox(height: 15,),
                    Text('Location (LatLng)', style: title4,),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        GetBuilder<PickedLocationController>(
                          builder: (location) {
                            _locationController.text = location.pickedLocation.value;
                            return Expanded(
                              child: FormInputField(
                                  controller: _locationController,
                                  isNumeric: false,
                                  placeholder: 'Location',
                              ),
                            );
                          }
                        ),
                        SizedBox(width: 10,),
                        SizedBox(
                            width: 45,
                            height: 48,
                            child: Button2(
                                height: 50,
                                content: Icon(Icons.add_location_alt, color: Colors.white,),
                                tap: ()=>Get.to(()=>LocationPicker())
                            )
                        )
                      ],
                    ),

                    SizedBox(height: 15,),
                    Text('Province', style: title4,),
                    SizedBox(height: 10,),
                    DropdownSearch<String>(
                      items: provinces,
                      popupProps: PopupProps.menu(
                        showSelectedItems: true,
                        fit: FlexFit.loose,
                        disabledItemFn: (String s) => s.startsWith('I'),
                      ),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsetsDirectional.symmetric(
                                  horizontal: 15,
                                  vertical: 15
                              ),
                              filled: true,
                              fillColor: Karas.background
                          )
                      ),
                      dropdownButtonProps: DropdownButtonProps(

                      ),
                      onChanged:(value)=> province=value!,
                      selectedItem: "Select Category",
                    ),
                    SizedBox(height: 15,),
                    Text('District', style: title4,),
                    SizedBox(height: 10,),
                    FormInputField(
                        controller: _districtController,
                        isNumeric: false,
                        placeholder: 'District'),
                    SizedBox(height: 15,),
                    Text('Address', style: title4,),
                    SizedBox(height: 10,),
                    FormInputField(
                        controller: _addressController,
                        isNumeric: false,
                        placeholder: 'Address'),
                    SizedBox(height: 20,)

                  ],
                ),
              )
          ),
          SizedBox(height: 20,),
          CardItems(
              head: CardItemsHeader(title: 'Store User (Admin)'),
              body: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Text('User Name', style: title4,),
                    SizedBox(height: 10,),
                    FormInputField(
                      controller: _usernameController,
                      isNumeric: false,
                      placeholder: 'User Name',
                    ),
                    SizedBox(height: 20,)

                  ],
                ),
              )
          ),
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
              child: Button1(
                  height: 40,
                  label: 'FINISH',
                  tap: ()async{

                    Map<String,dynamic>data = {
                      'name': '${_storenameController.text}',
                      'email': '${_emailController.text}',
                      'phone': '${_phoneController.text}',
                      'description': '${_descriptionController.text}',
                      'location': '${_locationController.text}',
                      'province': '${province}',
                      'district': '${_districtController.text}',
                      'address': '${_addressController.text}',
                      'datetime':'${DateTime.now()}',
                      'status': 'active',
                    };

                    await FirebaseFirestore.instance.collection('store').add(data).then((value) {
                      Map<String,dynamic>userData = {
                        'name':'${_usernameController.text}',
                        'user':'${_emailController.text}',
                        'store_id':value.id,
                        'active':true,
                        'datetime':'${DateTime.now()}'
                      };

                      Map<String,dynamic> user = {
                        'displayName':'${_usernameController.text}',
                        'email':'${_emailController.text}',
                        'phone':'${_phoneController.text}',
                        'photo':'',
                        'datetime':'${DateTime.now()}'
                      };

                      FirebaseFirestore.instance.collection('users').add(user);
                      FirebaseFirestore.instance.collection('store_user').add(userData);
                      Get.back();
                    });
                  }
              )
          ),
          SizedBox(height: 20,),
        ]
    );
  }
}

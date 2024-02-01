import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rolade_pos/components/card_items.dart';
import 'package:rolade_pos/components/card_items_header.dart';
import 'package:rolade_pos/components/form_components/button1.dart';
import 'package:rolade_pos/controllers/workdays_controller.dart';
import 'package:rolade_pos/helpers/notifications.dart';
import 'package:rolade_pos/styles/colors.dart';
import 'package:rolade_pos/styles/title_styles.dart';

import '../../controllers/store_controller.dart';

class WorkingHours extends StatefulWidget {
  WorkingHours({Key? key}) : super(key: key);

  @override
  State<WorkingHours> createState() => _WorkingHoursState();
}

class _WorkingHoursState extends State<WorkingHours> {
  var _startTime = TimeOfDay.now().obs;

  var _endTime = TimeOfDay.now().obs;

  String day = '';

  StoreController _storeController = Get.find();
  bool isWorking = false;

  int counter = 0;

  // Function to schedule a background task
  void _scheduleBackgroundTask() async {
    const MethodChannel platform =
    MethodChannel('com.kalutech.rolade_pos');
    try {
      await platform.invokeMethod('scheduleBackgroundTask');
    } on PlatformException catch (e) {
      print("Failed to schedule background task: '$e'");
    }
  }
  void backgroundTask() {
    // Your background task logic goes here
    // Update the counter or perform any other background tasks
    counter++;

    // Show a notification
    NotificationsHelper().showNotification('WORK IN PROGRESS', '$counter');
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorkdaysController>(
      builder: (workdaysController) {
        return DraggableHome(
          title: Text('Working Hours'),
          headerExpandedHeight: 0.1,
          actions: [
            IconButton(
                onPressed: (){
                  Get.bottomSheet(
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Karas.secondary,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Set Working Hours', style: title1,),
                          SizedBox(height: 20),
                          DropdownSearch<String>(
                            items: [
                              'Sunday',
                              'Monday',
                              'Tuesday',
                              'Wednesday',
                              'Thursday',
                              'Friday',
                              'Suturday',
                            ],
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
                                    fillColor: Karas.white
                                )
                            ),
                            dropdownButtonProps: DropdownButtonProps(

                            ),
                            onChanged:(value)=> day = value!,
                            selectedItem: "Select Day",
                          ),
                          SizedBox(height: 20,),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('    From', style: TextStyle(fontWeight: FontWeight.w500),),
                                    SizedBox(height: 10,),
                                    InkWell(
                                      onTap: ()async{
                                        _scheduleBackgroundTask();
                                        _startTime.value = (await showTimePicker(context: context, initialTime: TimeOfDay.now()))!;
                                        setState(() {

                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        height: 40,
                                        child: Center(child: Obx(()=> Text('${'${_startTime.value.hour}:${_startTime.value.minute<10?'0${_startTime.value.minute}':_startTime.value.minute}'??'00:00'}', style: TextStyle(fontSize: 16, fontWeight:  FontWeight.w600),))),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20,),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('    To', style: TextStyle(fontWeight: FontWeight.w500),),
                                    SizedBox(height: 10,),
                                    InkWell(
                                      onTap: ()async{
                                        _endTime.value = (await showTimePicker(context: context, initialTime: TimeOfDay.now()))!;

                                        setState(() {

                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        height: 40,
                                        child: Center(child: Obx(()=> Text('${'${_endTime.value.hour}:${_endTime.value.minute<10?'0${_endTime.value.minute}':_endTime.value.minute}'??'00:00'}', style: TextStyle(fontSize: 16, fontWeight:  FontWeight.w600),))),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Button1(
                              label: 'Add',
                              tap: (){
                                FirebaseFirestore.instance.collection('working_hours').add({
                                  'startTime':'${_startTime.value.hour}:${_startTime.value.minute<10?'0${_startTime.value.minute}':_startTime.value.minute}',
                                  'endTime':'${_endTime.value.hour}:${_endTime.value.minute<10?'0${_endTime.value.minute}':_endTime.value.minute}',
                                  'day': '$day',
                                  'store_id':_storeController.store.value.id
                                });
                                Get.back();
                              }
                          )
                        ],
                      ),
                    ),

                  );
                },
                icon: Icon(Icons.add)
            )
          ],
          alwaysShowLeadingAndAction: true,
          alwaysShowTitle: true,
          appBarColor: Karas.primary,
          headerWidget: Container(
            color: Karas.primary,
          ),
          body: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('Today: '),
                                Text('${['Sunday','Monday','Tuesday','Wednesday','Thursday','Firday','Saturday'][DateTime.now().weekday]}', style: title2,),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text('Status: '),
                                Text('NOT WORKING', style: title2,),
                              ],
                            ),
                          ],
                        ),
                        Container(
                            width:80,
                            child: isWorking?Button1(
                                width: 80,
                                label: 'Start',
                                tap: ()=>setState(() {
                                  isWorking=!isWorking;
                                  backgroundTask();
                                })
                            ):Button1(
                                width: 80,
                                label: 'Stop',
                                tap: ()=>setState(()=>isWorking=!isWorking)
                            )
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  CardItems(
                      head: CardItemsHeader(title: '',),
                      body: Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Table(
                          children: [
                            TableRow(children: [
                              Text(''),
                              Text('FROM', textAlign: TextAlign.right,),
                              Text('TO', textAlign: TextAlign.right,),
                            ]),
                            if(workdaysController.workdays.length>0)
                              ...workdaysController.workdays.value.map((e) => TableRow(
                                  children: [
                                    Text('${e.day}', textAlign: TextAlign.right,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                    Text('${e.from}', textAlign: TextAlign.right,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                    Text('${e.to}', textAlign: TextAlign.right,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                  ]
                              )),
                          ],
                        ),
                      )
                  ),
                ],
              ),
            )
          ],
        );
      }
    );
  }
}


import 'package:draggable_home/draggable_home.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdf/pdf.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as imglib;
import 'package:rolade_pos/components/form_components/button1.dart';
import 'package:rolade_pos/components/form_components/button2.dart';
import 'package:rolade_pos/components/form_components/form_input_field.dart';
import 'package:rolade_pos/styles/colors.dart';
import 'package:get/get.dart';
import 'package:rolade_pos/styles/title_styles.dart';
import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import '../../helpers/pdf_gen_code.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:math';


class CodeGen extends StatefulWidget {
  CodeGen({Key? key}) : super(key: key);

  @override
  State<CodeGen> createState() => _CodeGenState();
}

class _CodeGenState extends State<CodeGen> {
  Uint8List? encodedBytes;

  TextEditingController _textController = TextEditingController();
 // Uint8List _imageFile;

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  int symbology = 0; //0 qrcode   1 barcode
  FocusNode fnode = FocusNode();

  var showText = false.obs;
  var barColor = Color(0xff000000).obs;
  var backColor = Color(0x6bcce5d9).obs;

  String generateRandomNumber() {
    Random random = Random();
    String randomNumber = '';
    for (int i = 0; i < 13; i++) {
      randomNumber += random.nextInt(9).toString();
    }
    return randomNumber;
  }


  String generateRandomString() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();
    String randomString = '';
    for (int i = 0; i < 16; i++) {
      randomString += chars[random.nextInt(chars.length)];
    }
    return randomString;
  }


  @override
  Widget build(BuildContext context) {
    return DraggableHome(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          String barcodeValue = generateRandomNumber();
          String qrCodeValue = generateRandomString();

          setState(() {
            if(symbology==0){
              _textController.text = qrCodeValue;
            }else{
              _textController.text = barcodeValue;
            }
          });

        },
        child: Icon(Icons.auto_awesome),
        backgroundColor: Karas.primary,
      ),
      bottomSheet: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: _textController.text.isNotEmpty?Row(
          children: [
            SizedBox(
              width: 100,
              child: Button2(
                  backgroundColor: Karas.secondary,
                  height: 40, content: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.share, color: Colors.deepOrange),
                  SizedBox(width: 10,),
                  Text('SHARE',style: TextStyle(color: Karas.primary, fontWeight: FontWeight.bold),),
                  SizedBox(width: 10,)
                ],
              ), tap: ()async{
                await screenshotController.capture(delay: const Duration(milliseconds: 10)).then((Uint8List? image) async {
                  if (image != null) {
                    final directory = await getDownloadsDirectory();
                    final imagePath = await File('${directory!.path}/${symbology==0?'qrcode_${generateRandomString().hashCode}':'${generateRandomNumber().hashCode}'}.png').create();
                    await imagePath.writeAsBytes(image);

                    /// Share Plugin
                     await FlutterShare.shareFile(
                         title: symbology==0?'qrcode_${generateRandomString().hashCode}':'barcode_${generateRandomNumber().hashCode}',
                         filePath: '${imagePath.path}',
                         text: symbology==0?'qrcode_${generateRandomString().hashCode}':'barcode_${generateRandomNumber().hashCode}',
                     );
                  }
                });
              }),
            ),
          ],
        ):Container(
          child: Text('Generate Barcode or QR Code', style: title2,textAlign: TextAlign.center,),
        )
      ),
      body: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              FormInputField(
                  controller: _textController,
                  isNumeric: false,
                  focus: fnode
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Button2(
                      backgroundColor: Karas.secondary,
                      height: 40,
                      tap: ()async{
                        final directory = (await getApplicationDocumentsDirectory ()).path; //from path_provide package
                        String fileName = '${DateTime.now().microsecondsSinceEpoch}';
                        String path = '$directory';
                        setState(() {
                            symbology = 0;
                        });

                        screenshotController.captureAndSave(
                            path, //set path where screenshot will be saved
                            fileName:fileName
                        );
                      }, content: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 10,),
                        Icon(Ionicons.qr_code_outline),
                        SizedBox(width: 10),
                        Text('QR Code', style: title3,),
                        SizedBox(width: 10,),
                      ],
                    ),
                      border: symbology==1?Border.all(color: Colors.transparent):Border.all(color: Karas.background),
                    ),
                  ),
                  SizedBox(width: 20,),
                  Expanded(
                    child: Button2(
                      backgroundColor: Karas.secondary,
                      height: 40,
                      tap: ()async{
                        final directory = (await getApplicationDocumentsDirectory ()).path; //from path_provide package
                        String fileName = '${DateTime.now().microsecondsSinceEpoch}';
                        String path = '$directory';
                        setState(() {
                          symbology = 1;
                        });

                        screenshotController.captureAndSave(
                            path, //set path where screenshot will be saved
                            fileName:fileName
                        );
                      },
                      border: symbology==0?Border.all(color: Colors.transparent):Border.all(color: Karas.background),
                      content: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 10,),
                        Icon(Ionicons.barcode_outline),
                        SizedBox(width: 10),
                        Text('Barcode', style:title3),
                        SizedBox(width: 10,),
                      ],
                    ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              _textController.text.isNotEmpty?Center(
                  child: Container(
                    height: symbology == 0?200:100,
                    child: Screenshot(
                      controller: screenshotController,
                      child: Obx(
                        ()=> SfBarcodeGenerator(
                            value: '${_textController.text}',
                            showValue: showText.value,
                            symbology: symbology == 0? QRCode() : Code128(),
                            barColor: barColor.value,
                            textStyle: TextStyle(color: barColor.value),
                            textSpacing: 5,
                            backgroundColor: backColor.value,

                        ),
                      ),
                    ),
                  ),
              ):Container(),
              SizedBox(height: 100,),

            ],
          ),
        )
      ],
      title: Text('Code Generator'),
      headerWidget: Container(
        color: Karas.primary,
      ),
      appBarColor: Karas.primary,
      actions: [
        IconButton(
            onPressed: (){
              fnode.unfocus();
              Get.bottomSheet(
                Container(
                  margin: EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          width: double.infinity,
                          child: Text('Settings', style: title1,),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Karas.secondary,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('  Show Value', style: title3,),
                                          Obx(
                                            ()=> Switch(
                                              value: showText.value,
                                              onChanged: (bool value) {
                                                showText.value = value;
                                              },
                                              activeColor: Karas.primary,
                                              activeTrackColor: Karas.background,
                                              inactiveTrackColor: Karas.secondary,
                                              inactiveThumbColor: Karas.background,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 8,),
                                      Image.asset('assets/barcode_paint.png', width: 200),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(' Color', style: title3,),
                                        ],
                                      ),
                                      SizedBox(height: 8,),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Text('Bar Color: '),
                                              InkWell(
                                                onTap: (){
                                                  Get.dialog(
                                                    Center(
                                                      child: Obx(()=>CircleColorPicker(
                                                        onChanged: (color){
                                                          barColor.value = color;
                                                        },
                                                        size: const Size(240, 240),
                                                        strokeWidth: 4,
                                                        thumbSize: 36,
                                                        textStyle: TextStyle(color: barColor.value, fontSize: 16),
                                                      )),
                                                    ),
                                                  );
                                                },
                                                child: Obx(
                                                    ()=> Container(
                                                    height: 20,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                      color: barColor.value,
                                                      borderRadius: BorderRadius.circular(5)
                                                    )
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 20),
                                          InkWell(
                                            onTap: (){
                                              Get.dialog(
                                                Center(
                                                  child: Obx(()=>CircleColorPicker(
                                                    onChanged: (color){
                                                      backColor.value = color;
                                                      print(color);
                                                    },
                                                    size: const Size(240, 240),
                                                    strokeWidth: 4,
                                                    thumbSize: 36,
                                                    textStyle: TextStyle(color: backColor.value, fontSize: 16),
                                                  )),
                                                ),
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Text('Back Color:  '),
                                                Obx(
                                                      ()=> Container(
                                                      height: 20,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                          color: backColor.value,
                                                          borderRadius: BorderRadius.circular(5)
                                                      )
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),

                              ],
                            )
                          )
                        )
                      ],
                    ),
                  ),
                )
              );
            }, 
            icon: Icon(Icons.settings, color: Colors.white,))
      ],
      headerExpandedHeight: 0.1,
      alwaysShowLeadingAndAction: true,
      alwaysShowTitle: true,
    );
  }
}

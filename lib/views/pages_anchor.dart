import 'package:ionicons/ionicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_enhanced_barcode_scanner/flutter_enhanced_barcode_scanner.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rolade_pos/controllers/cart_controller.dart';
import 'package:rolade_pos/styles/title_styles.dart';
import 'package:rolade_pos/views/home.dart';
import 'package:rolade_pos/views/product_views/product_entry.dart';
import 'package:rolade_pos/views/settings/settings_screen.dart';
import 'package:rolade_pos/views/sign_in_views/sign_up.dart';
import 'package:rolade_pos/views/store/stock.dart';
import 'package:rolade_pos/views/store/store.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:just_audio/just_audio.dart';
import '../components/cart_item_container.dart';
import '../helpers/methods.dart';
import '../helpers/sign_up_helper.dart';
import '../styles/colors.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:decorated_icon/decorated_icon.dart';
import 'cart/cart.dart';
import 'dashboard/dashboard.dart';

class PagesAnchor extends StatefulWidget {
  const PagesAnchor({Key? key}) : super(key: key);

  @override
  State<PagesAnchor> createState() => _PagesAnchorState();
}

class _PagesAnchorState extends State<PagesAnchor> {
  final player = AudioPlayer();
  int selected = 0;

  CartController _cartController = Get.find();

  PageController _pageController = PageController();

  @override
  void initState(){
    // TODO: implement initState
    super.initState();


  }

  Methods _methods = Methods();

  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{

        if(counter<1){
          if(selected==0){
            Fluttertoast.showToast(msg: 'Click to quit', backgroundColor: Colors.black87,textColor: Colors.white,);
          }
          Future.delayed(Duration(seconds: 2), ()=>setState(()=>counter==0));
        }else{
          if(selected!=0){
            setState(() {
              selected=0;
            });
          }else{
            return true;
          }
        }
        counter++;
        return false;
      },
      child: Scaffold(
         floatingActionButton: FloatingActionButton(
             backgroundColor: Karas.primary,
             onPressed: ()async{
               String barcode = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", false, ScanMode.DEFAULT);
               if(barcode.toString().contains('-')||barcode.toString().length<10){
                 player.setAsset('assets/barcode_failed.mp3');
                 player.play();
               }else{
                 player.setAsset('assets/barcode_scanned.mp3');
                 player.play();
                 _methods.productBarcodeDialog(barcode, player);
               }
               },
             child: CircleAvatar(
               backgroundColor: Colors.white,
               child: Icon(Icons.barcode_reader, color: Karas.primary,),
             )
         ),
         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
         bottomNavigationBar: StylishBottomBar(
         borderRadius: BorderRadius.circular(20),
         backgroundColor: Karas.primary,
           option: AnimatedBarOptions(
             iconSize: 20,
             iconStyle: IconStyle.simple

           ),
           items: [
             BottomBarItem(
               icon: Icon(Ionicons.home),
               title: Text('Dashbord', style: TextStyle(fontSize: 10),),
               backgroundColor: Colors.white,
               selectedColor: Colors.orange,
               selectedIcon: DecoratedIcon(
                 Ionicons.home,
                 color: Colors.orange,
                 size: 24.0,
                 shadows: [
                   BoxShadow(
                     blurRadius: 12.0,
                     color: Colors.white,
                   ),
                 ],
               ),
             ),
             BottomBarItem(
               icon: Icon(Ionicons.storefront),
               title: const Text('Store', style: TextStyle(fontSize: 10),),
               backgroundColor: Colors.white,
               selectedColor: Colors.orange,
               selectedIcon: DecoratedIcon(
                 Ionicons.storefront,
                 color: Colors.orange,
                 size: 24.0,
                 shadows: [
                   BoxShadow(
                     blurRadius: 12.0,
                     color: Colors.white,
                   ),
                 ],
               ),
             ),
             BottomBarItem(
               icon: GetBuilder<CartController>(
                builder: (controller)=> badges.Badge(
                   child:Icon(Ionicons.cart,),
                   badgeContent: Text('${controller.cart.value.length}', style: TextStyle(color: Colors.white, fontSize: 10),),
                  showBadge: controller.cart.value.length>0?true:false,
                 ),
               ),
               title: const Text('Cart',style: TextStyle(fontSize: 10),),
               backgroundColor: Colors.white,
               selectedColor: Colors.orange,
               badgeColor: Colors.orange,
               selectedIcon: DecoratedIcon(
                 Ionicons.cart,
                 color: Colors.orange,
                 size: 24.0,
                 shadows: [
                   BoxShadow(
                     blurRadius: 42.0,
                     color:Karas.background,
                   ),
                   BoxShadow(
                     blurRadius: 12.0,
                     color: Colors.white,
                   ),
                 ],
               ),
             ),
             BottomBarItem(
               icon:  Icon(Ionicons.pricetag,),
               title: const Text('Stock',style: TextStyle(fontSize: 10),),
               backgroundColor: Colors.white,
               selectedColor: Colors.orange,
               selectedIcon: DecoratedIcon(
                 Ionicons.pricetag,
                 color: Colors.orange,
                 size: 24.0,
                 shadows: [
                   BoxShadow(
                     blurRadius: 42.0,
                     color:Karas.background,
                   ),
                   BoxShadow(
                     blurRadius: 12.0,
                     color: Colors.white,
                   ),
                 ],
               ),
             ),
           ],
           fabLocation: StylishBarFabLocation.center,
           hasNotch: true,
           currentIndex: selected,
           onTap: (index) {
             setState(() {
               selected = index;
               _pageController.animateToPage(index, duration: Duration(microseconds: 500), curve: Curves.easeIn);
               });
           },
         ),
        body: PageView(
          onPageChanged: (page)=>setState(() {
            selected = page;
          }),
          controller: _pageController,
          children: [
            Dashboard(),
            Store(),
            Cart(),
            Stock()
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:rolade_pos/components/ad_container.dart';
import 'package:rolade_pos/components/card_items.dart';
import 'package:rolade_pos/components/card_items_header.dart';
import 'package:rolade_pos/components/cover_all_image_container.dart';
import 'package:rolade_pos/components/header_avatar.dart';
import '../components/category_item.dart';
import '../components/serachbar_mock.dart';
import '../controllers/user_controller.dart';
import '../styles/colors.dart';
import '../styles/title_styles.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  UserController _userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return DraggableHome(
       leading: Container(
         margin: EdgeInsets.only(left: 20),
         child: ClipRRect(
           borderRadius: BorderRadius.circular(40),
           child: CachedNetworkImage(
             width: 20,
             height: 20,
             imageUrl: _userController.user.value.photo,
             errorWidget: (c,e,i)=>CircleAvatar(
               backgroundImage: AssetImage('assets/avatar_placeholder.jpg'),
             ),
           ),
         ),
         width: 30,
       ),
      title: Container(
        child: HeaderAvatar(),
      ),
      alwaysShowLeadingAndAction: true,
      appBarColor: Karas.primary,
      headerWidget: Container(
        padding: EdgeInsets.symmetric(horizontal: 0),
        color: Karas.primary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: HeaderAvatar(),
            ),
            SizedBox(height: 6),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
                child: SearchMock(placeholder: 'Search products')
            )
          ],
        ),
      ),
      backgroundColor: Karas.secondary,
      body: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              CardItems(
                  head: CardItemsHeader(title: 'Categories', seeallbtn: Text('See all', style: title3,),),
                  body: Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    height: 120,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: List.generate(6, (index) =>
                          Row(
                            children: [
                              index==0?SizedBox(width: 10,):Container(),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: CircleAvatar()
                              ),
                              index==5?SizedBox(width: 10,):Container(),
                            ],
                          )
                      ),
                    ),
                  ),
              ),
              SizedBox(height: 18,),
              Container(
                height: 135,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  children: [
                  /*  AdContainer(
                        image: Image.asset('assets/yoghurt.png', width: 90,),
                        backgroundColor: Karas.background,
                        title: '30% Discount',
                        details: 'Order any food from app and get the discount',
                        orderbtn: Text('Order Now', style: title3,),
                    ),
                    SizedBox(width: 18),
                    AdContainer(
                        image: Image.asset('assets/kiwi.png', width: 90,),
                        backgroundColor: Karas.orange,
                        title: '30% Discount',
                        details: 'Order any food from app and get the discount'
                    ),*/
                  ],
                ),
              ),
              SizedBox(height: 18,),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: CardItems(
            head: CardItemsHeader(title: 'Popular deals', seeallbtn: Text('See all', style: title3,),),
            body: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15),
              height: 120,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  SizedBox(width: 15,),
                  CoverAllImageContainer(image: 'assets/fruticana.jpg'),
                  SizedBox(width: 16,),
                  CoverAllImageContainer(image: 'assets/maize.jpeg'),
                  SizedBox(width: 16,),
                  CoverAllImageContainer(image: 'assets/boom.jpg'),
                  SizedBox(width: 16,),
                  CoverAllImageContainer(image: 'assets/cookingoil.webp'),
                  SizedBox(width: 15,),

                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 40)
      ],
    );
  }
}

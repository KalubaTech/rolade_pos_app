import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rolade_pos/components/category_item.dart';
import 'package:rolade_pos/controllers/user_controller.dart';
import 'package:rolade_pos/controllers/workdays_controller.dart';
import 'package:rolade_pos/styles/colors.dart';
import 'package:rolade_pos/views/home.dart';
import 'package:rolade_pos/views/intro_views/Intro.dart';
import 'package:rolade_pos/views/pages_anchor.dart';
import 'package:flutter/services.dart';
import 'package:rolade_pos/views/sign_in_views/signIn_silently.dart';
import 'package:rolade_pos/views/sign_in_views/sign_up.dart';
import 'controllers/cart_controller.dart';
import 'controllers/ordersController.dart';
import 'controllers/picked_location.dart';
import 'controllers/products_controller.dart';
import 'controllers/store_controller.dart';
import 'helpers/notifications.dart';
import 'helpers/sign_up_helper.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();

/*    FirebaseMessaging.onBackgroundMessage(NotificationsHelper().firebaseMessagingBackgroundHandler);


    if (!kIsWeb) {
      await NotificationsHelper().setupFlutterNotifications();
    }*/
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static const String name = 'Awesome Notifications - Example App';
  static const Color mainColor = Colors.deepPurple;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {

    super.initState();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Karas.primary,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light
    ));

    // Lock the screen orientation to portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);




    Get.put(UserController());
    Get.put(StoreController());
    Get.put(CartController());
    Get.put(OrdersController());
    Get.put(ProductsController());
    Get.put(PickedLocationController());
    Get.put(WorkdaysController());

    return GetMaterialApp(
      // The navigator key is necessary to allow to navigate through static methods
      navigatorKey: MyApp.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Kass POS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Karas.white),
        primaryColor: Karas.primary,
        useMaterial3: false,
      ),
      home: GetStorage().hasData('user')?SignSilently() :SignUp(),
    );
  }
}

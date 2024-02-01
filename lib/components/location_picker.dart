
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rolade_pos/controllers/picked_location.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import 'package:widget_marker_google_map/widget_marker_google_map.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';

import '../styles/colors.dart';
import 'form_components/button1.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({Key? key}) : super(key: key);

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker>{
  GoogleMapController? googleMapController;
  LatLng? storePosition;

  PickedLocationController _locationController = Get.find();

  bool loading = false;
  Future<void> getCurrentLocation() async {
    try {
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Request location permissions if not granted
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
          print("Location permission denied");
          return;
        }
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Access the latitude and longitude from the position object
      double latitude = position.latitude;
      double longitude = position.longitude;

      setState(() {
        storePosition = LatLng(latitude, longitude);
        loading = false;
        googleMapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: storePosition!, zoom: 19)));

      });

      print("Latitude: $latitude, Longitude: $longitude");
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<String> getLocalityFromCoordinates(double latitude, double longitude) async {
    try {
      // Reverse geocoding to get locality (city or town)
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      String locality = placemarks.isNotEmpty ? '${placemarks[0].locality} ${placemarks[0].subLocality}' ?? '' : '';

      return locality;
    } catch (e) {
      print("Error getting locality: $e");
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Karas.background,
        body: SafeArea(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Store Location", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                      loading?SizedBox(width: 20,height: 20,child: CircularProgressIndicator(color: Colors.green,),):TouchRippleEffect(
                        rippleColor: Colors.grey,
                        onTap: ()async{
                          setState(() {
                            loading = true;
                          });
                          getCurrentLocation();
                        },
                        borderRadius: BorderRadius.circular(5),
                        child: Icon(Icons.location_searching),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 17,),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.symmetric(vertical: BorderSide(color: Colors.grey))
                    ),
                    child: WidgetMarkerGoogleMap(
                      onMapCreated: (controller){
                        googleMapController = controller;
                      },
                      mapType: MapType.hybrid,
                      zoomControlsEnabled: false,
                      myLocationEnabled: true,
                      onLongPress: (position)async{
                        setState(() {
                          storePosition = position;
                        });

                      },
                      initialCameraPosition: CameraPosition(target: LatLng(-12.33443353, 28.54432233), zoom: 12),
                      widgetMarkers: [
                        WidgetMarker(

                            position: storePosition??LatLng(0, 0), markerId: 'houseposition', widget: storePosition==null?Container():
                        Icon(Icons.location_on, size: 70,color: Colors.red,)
                        )
                      ],

                    ),
                  ),
                ),
                SizedBox(height: 17),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                  child: Button1(label: 'Apply', tap: () {
                    _locationController.pickedLocation.value = '${storePosition!.latitude},${storePosition!.longitude}';
                    _locationController.update();
                    Get.back();
                    },),
                )

              ],
            ),
          ),
        )
    );
  }
}

import 'package:driver_app/configMaps.dart';
import 'package:driver_app/main.dart';
import 'package:driver_app/models/rideDetials.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;

import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationService
{
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  Future initialize() async
  {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
       retrieveRideRequestInfo(getRideRequestId(message));
      },

      onLaunch: (Map<String, dynamic> message) async {
        retrieveRideRequestInfo(getRideRequestId(message));

      },
      onResume: (Map<String, dynamic> message) async {
        retrieveRideRequestInfo(getRideRequestId(message));
      },
    );
  }
  Future <String> getToken()async
  {
    String token = await firebaseMessaging.getToken();
    print('this is the token ::');
    print(token);
    driversRef.child(currentFireBaseUser.uid).child('token').set(token);
    
    firebaseMessaging.subscribeToTopic('allDrivers');
    firebaseMessaging.subscribeToTopic('allUsers');
  }
  String getRideRequestId(Map<String, dynamic> message)
  {
    String rideRequestId = '';
    if(Platform.isAndroid)
      {

        rideRequestId= message['data']['ride_request_id'];

      }else
        {

          rideRequestId= message['ride_request_id'];

        }
          return rideRequestId;
  }
  void retrieveRideRequestInfo(String rideRequestId)
  {
   newRequestRef.child(rideRequestId).once().then((DataSnapshot dataSnapshot){
     if(dataSnapshot.value!=null)
       {
         double pickUpLocationLat= double.parse(dataSnapshot.value['pickUp']['latitude'].toString());
         double pickUpLocationLng= double.parse(dataSnapshot.value['pickUp']['longitude'].toString());
         String pickUpAddress= dataSnapshot.value['pickUp_address'].toString();

         double dropOffLocationLat= double.parse(dataSnapshot.value['dropOff']['latitude'].toString());
         double dropOffLocationLng= double.parse(dataSnapshot.value['dropOff']['longitude'].toString());
         String dropOffAddress= dataSnapshot.value['dropOff_address'].toString();

         String paymentMethod= dataSnapshot.value['payment_method'].toString();

         RideDetails rideDetails =RideDetails();
         rideDetails.ride_request_id = rideRequestId;
         rideDetails.pickUp_address=pickUpAddress;
         rideDetails.dropOff_address=dropOffAddress;
         rideDetails.pickUp=LatLng(pickUpLocationLat, pickUpLocationLng);
         rideDetails.dropOff=LatLng(dropOffLocationLat, dropOffLocationLng);
         rideDetails.payment_method=paymentMethod;

         print(' this is your information :::::::::::::::::');
         print("pick up address : ${rideDetails.pickUp_address}");
         print("drop off address: ${rideDetails.dropOff_address}");
       }
   });
  }
}
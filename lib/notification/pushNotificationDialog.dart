
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:driver_app/main.dart';
import 'package:driver_app/models/rideDetials.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io' show Platform;

import '../configMaps.dart';
import 'notificationdialog.dart';



class PushNotificationService
{
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  Future initialize(context) async
  {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {

        retrieveRideRequestInfo( getRideRequestId(message),context);

      },

      onLaunch: (Map<String, dynamic> message) async {
        retrieveRideRequestInfo(getRideRequestId(message),context);


      },
      onResume: (Map<String, dynamic> message) async {
         retrieveRideRequestInfo(getRideRequestId(message),context);


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
    String rideRequestId ='';
    if(Platform.isAndroid)
    {
       print('this is your ridRequstId:::::::::::::::::::::');
      rideRequestId= message['data']['ride_request_id'];
       print(rideRequestId);
    }else
    {

      rideRequestId= message['ride_request_id'];

    }
    return rideRequestId;
  }

  void retrieveRideRequestInfo(String rideRequestId,BuildContext context)
  {
    newRequestRef.child(rideRequestId).once().then((DataSnapshot dataSnapshot){


      if (dataSnapshot.value != null) {

           assetsAudioPlayer.open(Audio('sounds/alert.mp3'));
       assetsAudioPlayer.play();


        double pickUpLocationLat = double.parse(
            dataSnapshot.value['pickUp']['latitude'].toString());
        double pickUpLocationLng = double.parse(
            dataSnapshot.value['pickUp']['longitude'].toString());
        String pickUpAddress = dataSnapshot.value['pickUp_address'].toString();

        double dropOffLocationLat = double.parse(
            dataSnapshot.value['dropOff']['latitude'].toString());
        double dropOffLocationLng = double.parse(
            dataSnapshot.value['dropOff']['longitude'].toString());
        String dropOffAddress = dataSnapshot.value['dropOff_address']
            .toString();

        String paymentMethod = dataSnapshot.value['payment_method'].toString();
        String rider_name=dataSnapshot.value['rider_name'];
           String rider_phone=dataSnapshot.value['rider_phone'];

        RideDetails rideDetails = RideDetails();
        rideDetails.ride_request_id = rideRequestId;
        rideDetails.pickUp_address = pickUpAddress;
        rideDetails.dropOff_address = dropOffAddress;
        rideDetails.pickUp = LatLng(pickUpLocationLat, pickUpLocationLng);
        rideDetails.dropOff = LatLng(dropOffLocationLat, dropOffLocationLng);
        rideDetails.payment_method = paymentMethod;
        rideDetails.rider_name=rider_name;
        rideDetails.rider_phone=rider_phone;
        print(' this is your  information :::::::::::::::::   ');
        print("pick up address::::::::::::::::::::::::: ${rideDetails
            .dropOff_address}");
        print("drop off address::::::::::::::::::::::::::: ${rideDetails
            .pickUp_address}");

        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) =>
                NotificationDialog(rideDetails: rideDetails,)
       );
      }else
      {
        print("this is your information ::::::::::::::errrrrrrrrrrror ");
      }
    });
  }
}
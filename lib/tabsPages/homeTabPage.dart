import 'dart:async';

import 'package:driver_app/allScreen/registerationScreen.dart';
import 'package:driver_app/configMaps.dart';
import 'package:driver_app/main.dart';
import 'package:driver_app/notification/pushNotificationDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeTabPage extends StatefulWidget {

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  GoogleMapController newGoogleMapController;

  String driverStatusText='offline now - go online ';

  Color driverStatusTextColor=Colors.yellow[200];

  bool isDriverAvailable=false;


  @override
  void initState() {
    super.initState();
    getCurrentDriverInfo();
  }

  Position currentPosition;

  var geoLocator=Geolocator();

  void locatePosition()async
  {
    Position position=await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition=position;
    LatLng latLngPosition=LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition= CameraPosition(target: latLngPosition,zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
   // String address= await AssistantMethods.searchCoordinateAddress(position,context);
    //print('this is your address :' + address);
  }

  void getCurrentDriverInfo()async
  {
   currentFireBaseUser= await FirebaseAuth.instance.currentUser;
   PushNotificationService pushNotificationService = PushNotificationService();
   pushNotificationService.initialize(context);
   pushNotificationService.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          initialCameraPosition: HomeTabPage._kGooglePlex,
          myLocationEnabled: true,
          // zoomGesturesEnabled: true,
          // zoomControlsEnabled: true,
          onMapCreated: (GoogleMapController controller)
          {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController=controller;
            locatePosition();
          },
        ),
        // online offline driver container
        Container(
          width: double.infinity,
          height: 140,
          color: Colors.black54,
        ),
        Positioned(
          top: 60.0,left: 0.0,right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: RaisedButton(
                  onPressed: ()
                  {
                   if(isDriverAvailable != true)
                     {
                       makeDriverOnlineNow();
                       getLocationLiveUpdates();
                       setState(() {
                         driverStatusTextColor=Theme.of(context).accentColor;
                         driverStatusText='Online now';
                         isDriverAvailable=true;
                       });
                       displayToastMessage('You are online now', context);
                     }else
                       {
                         makeDriverOfflineNow();
                         setState(() {
                           driverStatusTextColor=Colors.yellow[200];
                           driverStatusText='offline now - go online';
                           isDriverAvailable=false;
                         });

                         displayToastMessage('You are offline now', context);
                       }

                  },
                  color: driverStatusTextColor,
                  child: Padding(
                    padding: EdgeInsets.all(17.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(driverStatusText,style: TextStyle(color: Colors.black,fontSize: 20.0,fontWeight: FontWeight.bold),),
                        Icon(Icons.phone_android,color: Colors.black,size: 26.0,)
                      ],
                    ),
                  ),
                )
                ,),
            ],
          )
        )
      ],
    );
  }

  void makeDriverOnlineNow()async
  {
    Position position=await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition=position;
    Geofire.initialize('availableDrivers');
    Geofire.setLocation(currentFireBaseUser.uid, currentPosition.latitude, currentPosition.longitude);
    rideRequestRef.onValue.listen((event) {

    });
  }

  void getLocationLiveUpdates()
  {
    homeTabPageStreamSubscription= Geolocator.getPositionStream().listen((Position position)
    {
      currentPosition=position;
      if(isDriverAvailable== true)
        {
          Geofire.setLocation(currentFireBaseUser.uid, position.latitude, position.longitude);
        }
      LatLng latLng= LatLng(position.latitude, position.longitude);
      newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }
  void makeDriverOfflineNow()
  {
    Geofire.removeLocation(currentFireBaseUser.uid);
    rideRequestRef.onDisconnect();
    rideRequestRef.remove();
    rideRequestRef=null;

  }
}

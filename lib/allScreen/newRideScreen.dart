import 'dart:async';


import 'package:driver_app/allWidgets/progressDialog.dart';
import 'package:driver_app/assistants/assistantMethods.dart';
import 'package:driver_app/assistants/mapsKitAssistant.dart';
import 'package:driver_app/configMaps.dart';
import 'package:driver_app/main.dart';
import 'package:driver_app/models/rideDetials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewRideScreen extends StatefulWidget {
  final RideDetails rideDetails;
  NewRideScreen({this.rideDetails});

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  _NewRideScreenState createState() => _NewRideScreenState();
}

class _NewRideScreenState extends State<NewRideScreen> {

  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  GoogleMapController newRideGoogleMapController;
  Set<Polyline> polyLineSet = Set<Polyline>();

  Set<Marker> markersSet = Set<Marker>();
  Set<Circle> circlesSet = Set<Circle>();
  List<LatLng> polyLineCorOrdinates = [];
PolylinePoints polylinePoints= PolylinePoints();
double mapPaddingFromBottom=0;
var geoLocator= Geolocator();
var locationOptions = LocationOptions(accuracy: LocationAccuracy.bestForNavigation);
BitmapDescriptor animatingMarkerIcon;
Position myPosition;
String status='accepted';
String durationRide='';
bool isRequestingDirection = false;

@override
  void initState() {
     super.initState();
     acceptRideRequest();
  }
  void getRideLiveLocationUpdates()
  {
    LatLng oldPos= LatLng(0, 0);
    rideStreamSubscription= Geolocator.getPositionStream().listen((Position position)
    {
      currentPosition=position;
     myPosition =position;
     LatLng mPostion= LatLng(position.latitude, position.longitude);

     var rot = MapKitAssistant.getMarkerLocation(oldPos.latitude, oldPos.longitude,
         mPostion.latitude  ,mPostion.longitude);

     Marker animatingMarker = Marker(
       markerId: MarkerId('animating'),
       position: mPostion,
       icon:  animatingMarkerIcon ,
       rotation: rot,
       infoWindow: InfoWindow(title: 'Current location')
     );
     setState(() {
        CameraPosition cameraPosition  =  CameraPosition(target: mPostion,zoom: 17);
        newRideGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
        markersSet.removeWhere((marker)=> marker.markerId.value == 'animating');
        markersSet.add(animatingMarker);
     });
     oldPos=mPostion;
     updateRideDetails();

      String rideRequestId = widget.rideDetails.ride_request_id;
      Map locMap =
      {
        'latitude': currentPosition.latitude.toString(),
        'longitude': currentPosition.longitude.toString()
      };
      newRequestRef.child(rideRequestId).child('driverLocation').set(locMap);
    });
  }

  @override
  Widget build(BuildContext context) {
  createIconMarker();
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPaddingFromBottom),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: NewRideScreen._kGooglePlex,
            markers: markersSet,
            circles: circlesSet,
            polylines: polyLineSet,
            myLocationEnabled: true,
            // zoomGesturesEnabled: true,
            // zoomControlsEnabled: true,
            onMapCreated: (GoogleMapController controller) async
            {
              _controllerGoogleMap.complete(controller);
              newRideGoogleMapController=controller;

            setState(() {
              mapPaddingFromBottom=265.0;
            });

                 var currentLatLng= LatLng(currentPosition.latitude, currentPosition.longitude);
                 var pickUpLatLng = widget.rideDetails.pickUp;
              await   getPlaceDirection(currentLatLng  , pickUpLatLng);
              getRideLiveLocationUpdates();
            },
          ),
          Positioned(
            right: 0.0,left: 0.0,bottom: 0.0,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38,
                        blurRadius: 16.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7)
                    )
                  ]
              ),
             height: 270.0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0,vertical: 18.0),
                child: Column(
                  children: [
                    Text(durationRide,style: TextStyle(fontSize: 14.0,fontFamily: 'bolt-semibold',color: Colors.deepPurple),),
                    SizedBox(height: 6.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Yaser aslan',style: TextStyle(fontSize: 24.0,fontFamily: 'bolt-semibold',)),
                        Padding(
                            padding: EdgeInsets.only(right: 10.0),
                        child: Icon(Icons.phone_android),),
                      ],
                    ),
                    SizedBox(height: 26.0,),
                    Row(

                      children: [
                        Image.asset('images/pickicon.png',height: 16.0,width: 16.0,),
                        SizedBox(width: 18.0,),
                        Expanded(child: Container(child: Text('istanbul',style: TextStyle(fontSize: 18.0),
                        overflow: TextOverflow.ellipsis,
                        ))),
                      ],
                    ),
                    SizedBox(height: 16.0,),
                    Row(

                      children: [
                        Image.asset('images/desticon.png',height: 16.0,width: 16.0,),
                        SizedBox(width: 18.0,),
                        Expanded(child: Container(child: Text('syria',style: TextStyle(fontSize: 18.0),
                          overflow: TextOverflow.ellipsis,
                        ))),
                      ],
                    ),
                    SizedBox(height: 26.0,),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: RaisedButton(
                        onPressed: (){

                        },
                        color: Theme.of(context).accentColor,
                        child:Padding(
                          padding: EdgeInsets.all(17.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Arrived',style: TextStyle(fontSize: 20.0,
                              fontWeight: FontWeight.bold,color: Colors.black
                              ),
                              ),
                              Icon(Icons.directions_car,color: Colors.black,size: 26.0,)
                            ],
                          ),
                        )
                    ),
                    )

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> getPlaceDirection(LatLng pickUpLatLng,LatLng dropOffLatLng) async
  {

    showDialog(
        context: context,
        builder: (BuildContext context) =>
            ProgressDialog(message: 'Please wait...',)
    );
    var details = await AssistantMethods.obtainPlaceDirectionDetails(
        pickUpLatLng, dropOffLatLng);

    Navigator.pop(context);
    print('this is encoded points :::::');
    print(details.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult = polylinePoints
        .decodePolyline(details.encodedPoints);

    polyLineCorOrdinates.clear();
    if (decodedPolyLinePointsResult.isNotEmpty) {
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        polyLineCorOrdinates.add(
            LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    polyLineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
          polylineId: PolylineId('PolyLineId'),
          color: Colors.pink,
          jointType: JointType.round,
          points: polyLineCorOrdinates,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true
      );
      polyLineSet.add(polyline);
    });
    // control by site for both pickup and dropdown
    LatLngBounds latLngBounds;
    if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
        pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    }
    else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
        northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),);
    }
    else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
        northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),);
    }
    else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }
    newRideGoogleMapController.animateCamera(
        CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpLocMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),

        position: pickUpLatLng,
        markerId: MarkerId('pickUpId'));
    Marker dropOffLocMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),

        position: dropOffLatLng,
        markerId: MarkerId('dropOffId'));

    setState(() {
      markersSet.add(pickUpLocMarker);
      markersSet.add(dropOffLocMarker);
    });

    Circle pickUpLocCircle = Circle(
        circleId: CircleId('pickUpId'),
        fillColor: Colors.blueAccent,
        center: pickUpLatLng,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.blueAccent
    );
    Circle dropOffLocCircle = Circle(
        circleId: CircleId('dropOffId'),
        fillColor: Colors.deepPurple,
        center: dropOffLatLng,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.deepPurple
    );

    setState(() {
      circlesSet.add(pickUpLocCircle);
      circlesSet.add(dropOffLocCircle);
    });
  }
   void acceptRideRequest()
   {
     String rideRequestId = widget.rideDetails.ride_request_id;
     newRequestRef.child(rideRequestId).child('status').set('accepted');
     newRequestRef.child(rideRequestId).child('driverName').set(driversInformation.name);
     newRequestRef.child(rideRequestId).child('driverPhone').set(driversInformation.phone);
     newRequestRef.child(rideRequestId).child('driverId').set(driversInformation.id);
     newRequestRef.child(rideRequestId).child('carDetails').set('${driversInformation.car_number}-${driversInformation.car_model} ');

     Map locMap =
         {
           'latitude': currentPosition.latitude.toString(),
           'longitude': currentPosition.longitude.toString()
         };
     newRequestRef.child(rideRequestId).child('driverLocation').set(locMap);

   }
  void createIconMarker()
  {
    if(animatingMarkerIcon == null)
    {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context,size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, 'images/car_android.png').
      then((value) {
        animatingMarkerIcon=value;
      });
    }
  }
  void updateRideDetails()async
  {
    if(isRequestingDirection == false )
      {
        isRequestingDirection = true;
        if(myPosition == null)
        {
          return;
        }
        var posLatLng = LatLng(myPosition.latitude, myPosition.longitude);
        LatLng destinationLatLng;
        if(status == 'accepted' )
        {
          destinationLatLng= widget.rideDetails.pickUp;
        }
        else
        {
          destinationLatLng = widget.rideDetails.dropOff;
        }
        var directionDetails= await AssistantMethods.obtainPlaceDirectionDetails(posLatLng, destinationLatLng);
        if(directionDetails != null)
        {
          setState(() {
            durationRide=directionDetails.durationText;
          });
        }
        isRequestingDirection=false;
      }

  }
}

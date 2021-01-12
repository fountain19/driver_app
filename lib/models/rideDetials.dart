import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideDetails{
  String pickUp_address;
  String dropOff_address;
  LatLng pickUp;
  LatLng dropOff;
  String ride_request_id;
  String payment_method;
  String rider_name;
  String rider_phone;


  RideDetails({this.dropOff,this.pickUp,this.dropOff_address,this.payment_method,
    this.pickUp_address,this.ride_request_id,this.rider_name,this.rider_phone,
  });

}
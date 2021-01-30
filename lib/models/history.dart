import 'package:firebase_database/firebase_database.dart';

class History {
  String paymentMethod;
  String createAt;
  String status;
  String fares;
  String dropOff;
  String pickUp;
  History({
    this.dropOff,this.paymentMethod,this.pickUp,this.status,this.createAt,this.fares
});

  History.fromSnapshot(DataSnapshot dataSnapshot)
  {
    paymentMethod = dataSnapshot.value['payment_method'];
    createAt = dataSnapshot.value['created_at'];
    status = dataSnapshot.value['status'];
    fares = dataSnapshot.value['fares'];
    dropOff = dataSnapshot.value['dropOff_address'];
    pickUp = dataSnapshot.value['pickUp_address'];
  }
}
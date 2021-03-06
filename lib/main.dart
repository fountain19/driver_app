import 'package:driver_app/allScreen/carInfoScreen.dart';
import 'package:driver_app/configMaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:driver_app/allScreen/loginScreen.dart';
import 'package:driver_app/allScreen/mainScreen.dart';
import 'package:driver_app/allScreen/registerationScreen.dart';
import 'package:driver_app/dataHandler/appData.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  currentFireBaseUser=FirebaseAuth.instance.currentUser;
  runApp(MyApp());
}

DatabaseReference usersRef = FirebaseDatabase.instance.reference().child('users');
DatabaseReference driversRef = FirebaseDatabase.instance.reference().child('drivers');
   DatabaseReference newRequestRef = FirebaseDatabase.instance.reference().child('rideRequest');
DatabaseReference rideRequestRef = FirebaseDatabase.instance.reference().child('drivers')
    .child(currentFireBaseUser.uid).child('newRide');

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=> AppData(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
               fontFamily: 'bolt-semibold',
          primarySwatch: Colors.blue,
         accentColor: Colors.yellow,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: FirebaseAuth.instance.currentUser== null?LoginScreen.idScreen:MainScreen.idScreen,
        routes:
        {
          LoginScreen.idScreen:(context)=>LoginScreen(),
          RegisterationScreen.idScreen:(context)=>RegisterationScreen(),
          MainScreen.idScreen:(context)=>MainScreen(),
          CarInfoScreen.idScreen:(context)=>CarInfoScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

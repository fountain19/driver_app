import 'package:driver_app/allScreen/loginScreen.dart';
import 'package:driver_app/configMaps.dart';
import 'package:driver_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';

class ProfileTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(driversInformation.name,
              style: TextStyle(color: Colors.white,
                  fontSize: 65.0,
                  fontWeight: FontWeight.bold,
              fontFamily: 'Signatra'
              ),),
            Text(title + ' '+'Driver' ,
              style: TextStyle(color: Colors.blueGrey[200],
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.5
              ),),
            SizedBox(
              height: 20.0,width: 200.0,
              child: Divider(
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
             InfoCard(
               text: driversInformation.phone,
               icon: Icons.phone,
               onPressed: ()async{
               },
             ),
            InfoCard(
              text: driversInformation.email,
              icon: Icons.email,
              onPressed: ()async{
              },
            ),
            InfoCard(
              text: driversInformation.car_color + ' '+driversInformation.car_model+ ' ' +
              driversInformation.car_number,
              icon: Icons.car_repair,
              onPressed: ()async{
              },
            ),
        GestureDetector(
          onTap: (){
            Geofire.removeLocation(currentFireBaseUser.uid);
            rideRequestRef.onDisconnect();
            rideRequestRef.remove();
            rideRequestRef = null;
            FirebaseAuth.instance.signOut();
            Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
          },
          child: Card(
            color: Colors.red,
            margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 110.0),
            child: ListTile(
              trailing: Icon(
                Icons.follow_the_signs_outlined,color: Colors.white,
              ),
              title: Text('Sign out',textAlign: TextAlign.center ,
                style: TextStyle(color: Colors.white,
                fontSize: 16.0,
              ),),
            ),
          ),
        )
          ],
        ) ,
      ),
    );
  }
}
 class InfoCard extends StatelessWidget {
  final String text;
  final IconData icon;
  Function onPressed;
  InfoCard({this.text,this.icon,this.onPressed});
   @override
   Widget build(BuildContext context) {
     return GestureDetector(
       onTap: onPressed,
       child: Card(
         color: Colors.white,
         margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 25.0),
         child: ListTile(
           leading: Icon(
             icon,color: Colors.black87,
           ),
           title: Text(text ,style: TextStyle(color: Colors.black87,
               fontSize: 16.0,
           ),),
         ),
       ),
     );
   }
 }

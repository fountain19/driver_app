import 'package:driver_app/assistants/assistantMethods.dart';
import 'package:driver_app/configMaps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CollectFareDialog extends StatelessWidget {
  final String paymentMethod;
  final int fareAmount;
  CollectFareDialog({this.fareAmount,this.paymentMethod});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius:  BorderRadius.circular(12.0),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 22.0,),
            Text('Trip fare ('+ rideType.toUpperCase()+ ')'),
            SizedBox(height: 22.0,),
            Divider(),
            SizedBox(height: 16.0,),
            Text('\$$fareAmount',style: TextStyle(fontSize: 55),),
            SizedBox(height: 16.0,),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text('This is the total trip amount , it has been charged to the rider',textAlign: TextAlign.center,),
            ),
            SizedBox(height: 30.0,),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 16.0),
              child: RaisedButton(
                onPressed: ()
                {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  AssistantMethods.enableHomeTabLiveLocationUpdates();
                },
                color: Colors.green[500],
                child: Padding(
                  padding: EdgeInsets.all(17.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Collect cash',style: TextStyle(color: Colors.black,fontSize: 20.0,fontWeight: FontWeight.bold),),
                      Icon(Icons.attach_money,color: Colors.black,size: 26.0,)
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.0,)
          ],
        ),
      ),
    );
  }
}

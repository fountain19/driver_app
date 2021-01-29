import 'package:driver_app/dataHandler/appData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EarningTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.black87,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 70),
            child: Column(
              children: [
                Text('Total',style: TextStyle(color: Colors.white),),
                Text('\$${Provider.of<AppData>(context,listen: false).earnings}',
                  style: TextStyle(color: Colors.white,fontSize: 50.0),)
              ],
            ),
          ),
        ),
        FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: (){},
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0,vertical: 18.0),
            child: Row(
              children: [
                Image.asset('images/uberx.png',width: 70,),
                SizedBox(width: 16,),
                Text('Total trips',style: TextStyle(fontSize: 16.0),),
                Expanded(child: Container(child: Text('5',textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 18.0
                ),),)),
              ],
            ),
          ),
        ),
        Divider(height: 2.0,thickness: 2.0,)
      ],
    );
  }
}

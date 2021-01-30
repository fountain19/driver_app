import 'package:driver_app/assistants/assistantMethods.dart';
import 'package:driver_app/models/history.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
  final History history;
  HistoryItem({this.history});
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 16.0),
    child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Row(
                children: [
                  Image.asset('images/pickicon.png',width: 16,height: 16,),
                  SizedBox(width: 18,),
                  Expanded(child: Container(
                    child: Text(
                      history.pickUp,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16.0
                      ),),),
                  ),
                  SizedBox(width: 5,),
                  Text('\$${history.fares}',style: TextStyle(
                      fontSize: 16.0,color: Colors.black87
                  ),)
                ],
              ),
            ),
            SizedBox(height: 8,),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.asset('images/desticon.png',width: 16,height: 16,),
                SizedBox(width: 15,),
                Expanded(child: Container(child: Text(history.dropOff,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 16.0),))),
              ],
            ),
            SizedBox(height: 15.0,),
            Text(AssistantMethods.formatTripDate(history.createAt),style: TextStyle(
              color: Colors.grey
            ),)
          ],
        )
      ],
    ),
    );
  }
}

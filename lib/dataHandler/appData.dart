import 'package:driver_app/models/history.dart';
import 'package:flutter/cupertino.dart';


class AppData extends ChangeNotifier
{
   String earnings ='0';
   int counterTrips= 0;
   List<String> tripHistoryKeys=[];
   List<History> tripHistoryDataList=[];

   void updateEarnings(String updatedEarnings)
   {
     earnings =updatedEarnings;
     notifyListeners();
   }

   void updateTripsCounter(int tripCounter)
   {
     counterTrips =tripCounter;
     notifyListeners();
   }

   void updateTripKeys(List<String> newKeys)
   {
     tripHistoryKeys =newKeys;
     notifyListeners();
   }

   void updateTripHistoryData(History  eachHistory)
   {
     tripHistoryDataList.add(eachHistory);
     notifyListeners();
   }
}
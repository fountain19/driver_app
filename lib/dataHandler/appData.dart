import 'package:flutter/cupertino.dart';
import 'package:driver_app/models/address.dart';


class AppData extends ChangeNotifier
{
   String earnings ='0';
   void updateEarnings(String updatedEarnings)
   {
     earnings =updatedEarnings;
     notifyListeners();
   }
}
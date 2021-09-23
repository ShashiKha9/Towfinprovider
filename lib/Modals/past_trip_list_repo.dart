import 'package:cbx_driver/Modals/AllPastTripList.dart';
import 'package:cbx_driver/Modals/AllServicesModel.dart';
import 'package:cbx_driver/Modals/AllSubServicesModel.dart';

import 'AllProvidersList.dart';

class PastTripListRespo {

  List<AllPastTripList> allPastTripList = new List();
 String error;

  PastTripListRespo.fromJson(List<dynamic> json) {

   allPastTripList =  json.map((tagJson) => AllPastTripList.fromJson(tagJson)).toList();
  }

  PastTripListRespo.withError(String errorValue)
      : error =errorValue;
}
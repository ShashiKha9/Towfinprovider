import 'package:cbx_driver/Modals/AllServicesModel.dart';
import 'package:cbx_driver/Modals/AllSubServicesModel.dart';

import 'AllProvidersList.dart';

class ProvidersListResponse {

  List<AllProvidersList> allServicesList = new List();
 String error;

  ProvidersListResponse.fromJson(List<dynamic> json) {

   allServicesList =  json.map((tagJson) => AllProvidersList.fromJson(tagJson)).toList();
  }

  ProvidersListResponse.withError(String errorValue)
      : error =errorValue;
}
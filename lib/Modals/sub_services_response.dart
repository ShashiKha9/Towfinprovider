import 'package:cbx_driver/Modals/AllSubServicesModel.dart';

class SubServiceResponse {

  List<AllSubServicesModel> allServicesList = new List();
 String error;

  SubServiceResponse.fromJson(List<dynamic> json) {

   allServicesList =  json.map((tagJson) => AllSubServicesModel.fromJson(tagJson)).toList();
  }

  SubServiceResponse.withError(String errorValue)
      : error =errorValue;
}
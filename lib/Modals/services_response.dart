import 'package:cbx_driver/Modals/AllServicesModel.dart';

class ServiceResponse {

  List<AllServicesModel> allServicesList = new List();
 String error;

  ServiceResponse.fromJson(List<dynamic> json) {

   allServicesList =  json.map((tagJson) => AllServicesModel.fromJson(tagJson)).toList();

/*
    for(int i=0;i<json.length;i++){
      allServicesList.add(json[i]);
    }
*/
    print("RESPODATA"+json.toString());
  }

  ServiceResponse.withError(String errorValue)
      : error =errorValue;
}
import 'CheckStatusData.dart';

class CheckStatusResponse{

  List<CheckStatusData> data = new List();
  String error;


  CheckStatusResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<CheckStatusData>();
      json['data'].forEach((v) {
        data.add(new CheckStatusData.fromJson(v));
      });
    }
  }
  CheckStatusResponse.withError(String errorValue)
      : error =errorValue;
}
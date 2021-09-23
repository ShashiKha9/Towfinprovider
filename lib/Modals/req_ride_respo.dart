class RequestRideModel {

 int request_id;
 String message;
 String error;
 int current_provider;
 RequestRideModel( {
  this.request_id});

 RequestRideModel.fromJson(Map<String, dynamic> json)
     :
      request_id = json['request_id'],
      message = json['message'],
      current_provider = json['current_provider'],
 error = json['error'];

 RequestRideModel.withError(String errorValue)
     : request_id = 0
     , message = errorValue
     , error = errorValue
     , current_provider = 0;
}


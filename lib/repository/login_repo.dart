import 'package:cbx_driver/Modals/CheckStatusRespone.dart';
import 'package:cbx_driver/Modals/RateYourTripRespo.dart';
import 'package:cbx_driver/Modals/approximateprice_respo.dart';
import 'package:cbx_driver/Modals/login_response.dart';
import 'package:cbx_driver/Modals/providers_list_repo.dart';
import 'package:cbx_driver/Modals/req_ride_respo.dart';
import 'package:cbx_driver/Modals/services_response.dart';
import 'package:cbx_driver/Modals/signup_response.dart';
import 'package:cbx_driver/Modals/sub_services_response.dart';
import 'package:cbx_driver/Modals/userprofile_response.dart';
import 'package:flutter/cupertino.dart';

import 'api_provider.dart';

class LoginRepository{

  ApiProvider _apiProvider = ApiProvider();

  Future<LoginResponse> getLogin(String emailId,String password,String deviceId,BuildContext context){
    return _apiProvider.loginReq(emailId,password,deviceId,context);
  }
  Future<SignUpResponse> getSignUp(String fName,String lName,String emailId,String mobileNumber,String password,String deviceId,BuildContext context){
    return _apiProvider.signupReq(fName,lName,emailId,mobileNumber,password,deviceId,context);
  }
  Future<UserProfileRespo> getUserProfile(String deviceId,BuildContext context,String accessToken){
    return _apiProvider.getUserProfile(deviceId,context,accessToken);
  }
 Future<ServiceResponse> fetchAllServicesReq(BuildContext context,String accessToken,String tokenType){
    return _apiProvider.fetchAllServicesReq(context,accessToken,tokenType);
  }
 Future<SubServiceResponse> fetchAllSubServicesReq(BuildContext context,String accessToken,String tokenType,String serviceId){
    return _apiProvider.fetchAllSubServicesReq(context,accessToken,tokenType,serviceId);
  }

 Future<ProvidersListResponse> fetchAllProviersReq(BuildContext context,String accessToken,String tokenType,String serviceId,double currentLat,double currentLng){
    return _apiProvider.fetchAllProvidersListReq(context,accessToken,tokenType,serviceId,currentLat,currentLng);
  }

 Future<ApproximatePriceRespo> getApproximatePrice(BuildContext context,String accessToken,String tokenType,String serviceId,double currentLat,double currentLng,double destinationLat,double destinationLng){
    return _apiProvider.getApproximatePrice(context,accessToken,tokenType,serviceId,currentLat,currentLng,destinationLat,destinationLng);
  }
 Future<RequestRideModel> sendRideReq(BuildContext context,String accessToken,String tokenType,String serviceId,double currentLat,double currentLng,double destinationLat,double destinationLng,String distance,String schedule_date,String schedule_time,String subdataoption,String use_wallet,String payment_mode, String card_id){
    return _apiProvider.sendRideReq(context,accessToken,tokenType,serviceId,currentLat,currentLng,destinationLat,destinationLng, distance, schedule_date, schedule_time, subdataoption, use_wallet, payment_mode,  card_id);
  }
 Future<CheckStatusResponse> reqCheckAPI(BuildContext context,String accessToken,String tokenType){
    return _apiProvider.reqCheckAPI(context,accessToken,tokenType);
  }
 Future<RateYourTripRespo> rateYourTrip(BuildContext context,String accessToken,String tokenType,String request_id,String rating){
    return _apiProvider.rateyourTrip(context,accessToken,tokenType,request_id,rating);
  }
 Future<RateYourTripRespo> cancelTrip(BuildContext context,String accessToken,String tokenType,String request_id,String rating){
    return _apiProvider.cancelTrip(context,accessToken,tokenType,request_id,rating);
  }
}
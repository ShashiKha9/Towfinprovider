import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:cbx_driver/Modals/AddCardRespo.dart';
import 'package:cbx_driver/Modals/AllPastTripList.dart';
import 'package:cbx_driver/Modals/CheckStatusRespone.dart';
import 'package:cbx_driver/Modals/RateYourTripRespo.dart';
import 'package:cbx_driver/Modals/SummaryRespo.dart';
import 'package:cbx_driver/Modals/UpdateDriverStatus.dart';
import 'package:cbx_driver/Modals/approximateprice_respo.dart';
import 'package:cbx_driver/Modals/changepass_response.dart';
import 'package:cbx_driver/Modals/forgetpass_response.dart';
import 'package:cbx_driver/Modals/login_response.dart';
import 'package:cbx_driver/Modals/past_trip_list_repo.dart';
import 'package:cbx_driver/Modals/providers_list_repo.dart';
import 'package:cbx_driver/Modals/services_response.dart';
import 'package:cbx_driver/Modals/signup_response.dart';
import 'package:cbx_driver/Modals/req_ride_respo.dart';
import 'package:cbx_driver/Modals/sub_services_response.dart';
import 'package:cbx_driver/Modals/userprofile_response.dart';
import 'package:cbx_driver/Utils/helperutils.dart';
import 'package:cbx_driver/Utils/logging_interceptor.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiProvider {

  final String _login_endpoint = "api/provider/oauth/token";
  final String _signup_endpoint = "api/provider/register";
  final String _userDetailsendpoint = "api/provider/profile";
  final String _fetchAllServices = "api/user/services";
  final String _fetchAllSubServices = "api/user/products";
  final String _fetchAllProviders = "api/user/show/providers";
  final String _getApproximatePrice = "api/user/estimated/fare";
  final String _sendRideReq = "api/user/send/request";
  final String _reqCheck = "api/user/request/check";
  final String _rateYourProvider = "api/user/rate/provider";
  final String _cancelRideReq = "api/user/cancel/request";
  final String _updateProfileReq = "api/user/update/profile";
  final String _changePasswordReq = "api/user/change/password";
  final String _pastHistoryTrip = "api/provider/requests/history";
  final String _fetchSummary = "api/provider/summary";
  final String _forgetpassword = "api/user/forgot/password";
  final String _addCard = "api/user/card";
  final String _updateDriverStatus = "api/provider/profile/available";
  final int client_id = 4;
  final String client_secret = "JRpCkB9xFYFGAo4kCmvLnElvMqfGYVYw0J76toCq";



  Dio _dio;

  ApiProvider() {
    BaseOptions options =
    BaseOptions(receiveTimeout: 5000, connectTimeout: 5000);
    // var customHeaders = {
    //   'X-Requested-With': 'XMLHttpRequest',
    //   'Authorization': tokenType+" "+accesstoken
    //   // other headers
    // };

    // if(accesstoken!="")
    // options.headers.addAll(customHeaders);

    _dio = Dio(options);
    _dio.interceptors.add(LoggingInterceptor());
  }

  Future<LoginResponse> loginReq(String emailId,String password,String deviceId,BuildContext context) async {
    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    progressDialog.show();
    try {
      var params = {
        "email": emailId,
        "password": password,
        "device_type": Platform.isAndroid?"android":"ios",
        "device_id": deviceId,
        "device_token": "android",
      };

      print(jsonEncode(params));

      Response response = await _dio.post(baseUrl + _login_endpoint, data:jsonEncode(params));

      progressDialog.dismiss();

      return LoginResponse.fromJson(response.data);

    } catch (error, stacktrace) {
      showToast("Email id or password in wrong", context);

      print("Exception occured: $error stackTrace: $stacktrace");
      progressDialog.dismiss();
      return LoginResponse.withError(_handleError(error));
    }
  }

  Future<UserProfileRespo> updateProfile(String emailId,String mobileNumber,String firstName,String lastName,BuildContext context,String accessToken,String tokenType) async {
    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    progressDialog.show();


    try {
      var params = {
        "first_name": firstName,
        "last_name": lastName,
        "email": emailId,
        "mobile": mobileNumber,
      };

      print(jsonEncode(params));
      _dio.options.headers = {"X-Requested-With":"XMLHttpRequest","Authorization" : "Bearer "+" "+accessToken};

      Response response = await _dio.post(baseUrl + _updateProfileReq, data:jsonEncode(params));



      progressDialog.dismiss();

      return UserProfileRespo.fromJson(response.data);

    } catch (error, stacktrace) {
      showToast("Email id or password in wrong", context);

      print("Exception occured: $error stackTrace: $stacktrace");
      progressDialog.dismiss();
      return UserProfileRespo.withError(_handleError(error));
    }
  }

  Future<ForgetPasswordRespo> forgetPassword(String emailId,BuildContext context,String accessToken,String tokenType) async {
    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    progressDialog.show();


    try {
      var params = {

        "email": emailId,
      };

      print(jsonEncode(params));
      _dio.options.headers = {"X-Requested-With":"XMLHttpRequest","Authorization" : "Bearer "+" "+accessToken};

      Response response = await _dio.post(baseUrl + _forgetpassword, data:jsonEncode(params));



      progressDialog.dismiss();

      return ForgetPasswordRespo.fromJson(response.data);

    } catch (error, stacktrace) {
      showToast("Email id or password in wrong", context);

      print("Exception occured: $error stackTrace: $stacktrace");
      progressDialog.dismiss();
      return ForgetPasswordRespo.withError(_handleError(error));
    }
  }

  Future<AddCardRespo> addCard(String strip_token,BuildContext context,String accessToken,String tokenType) async {
    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    progressDialog.show();


    try {
      var params = {

        "stripe_token": strip_token,
      };

      print(jsonEncode(params));
      _dio.options.headers = {"X-Requested-With":"XMLHttpRequest","Authorization" : "Bearer "+" "+accessToken};

      Response response = await _dio.post(baseUrl + _addCard, data:jsonEncode(params));

      progressDialog.dismiss();

      return AddCardRespo.fromJson(response.data);

    } catch (error, stacktrace) {
      showToast("something went wrong", context);

      print("Exception occured: $error stackTrace: $stacktrace");
      progressDialog.dismiss();
      return AddCardRespo.withError(_handleError(error));
    }
  }
  Future<UpdateDriverStatus> updateDriverStatus(BuildContext context,String accessToken,String service_status) async {
    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    progressDialog.show();


    try {
      var params = {

        "service_status": service_status,
      };

      print(jsonEncode(params)+"==STATUS");
      _dio.options.headers = {"X-Requested-With":"XMLHttpRequest","Authorization" : "Bearer "+" "+accessToken};

      Response response = await _dio.post(baseUrl + _updateDriverStatus, data:jsonEncode(params));

      progressDialog.dismiss();

      return UpdateDriverStatus.fromJson(response.data);

    } catch (error, stacktrace) {
      showToast("something went wrong", context);

      print("Exception occured: $error stackTrace: $stacktrace");
      progressDialog.dismiss();
      return UpdateDriverStatus.withError(_handleError(error));
    }
  }

  Future<ChangePasswordRespo> changePassword(String password,String password_confirmation,String old_password,BuildContext context,String accessToken,String tokenType) async {
    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    progressDialog.show();


    try {
      var params = {
        "password": password,
        "password_confirmation": password_confirmation,
        "old_password": old_password,
      };

      print(jsonEncode(params));
      _dio.options.headers = {"X-Requested-With":"XMLHttpRequest","Authorization" : "Bearer "+" "+accessToken};

      Response response = await _dio.post(baseUrl + _changePasswordReq, data:jsonEncode(params));



      progressDialog.dismiss();

      return ChangePasswordRespo.fromJson(response.data);

    } catch (error, stacktrace) {
      showToast("Something went wrong!", context);

      print("Exception occured: $error stackTrace: $stacktrace");
      progressDialog.dismiss();
      return ChangePasswordRespo.withError(_handleError(error));
    }
  }



  Future<PastTripListRespo> pastTripHistoryReq(BuildContext context,String accessToken,String tokenType) async {
    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    progressDialog.show();


    print(accessToken+" = "+tokenType);
    try {

      _dio.options.headers = {"X-Requested-With":"XMLHttpRequest","Authorization" : "Bearer "+" "+accessToken};

      Response response = await _dio.get(baseUrl + _pastHistoryTrip);



      progressDialog.dismiss();

      print(response.data.toString()+ " = MYRESPO");

      return PastTripListRespo.fromJson(response.data);

    } catch (error, stacktrace) {
      // showToast("Email id or password in wrong", context);

      print("Exception occured: $error stackTrace: $stacktrace");
      progressDialog.dismiss();
      return PastTripListRespo.withError(_handleError(error));
    }
  }
  Future<SummaryRespo> fetchProvderSummary(BuildContext context,String accessToken,String tokenType) async {
    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    progressDialog.show();


    print(accessToken+" = "+tokenType);
    try {

      _dio.options.headers = {"X-Requested-With":"XMLHttpRequest","Authorization" : "Bearer "+" "+accessToken};

      Response response = await _dio.post(baseUrl + _fetchSummary);

      print(response.toString());


      progressDialog.dismiss();


      return SummaryRespo.fromJson(response.data);

    } catch (error, stacktrace) {
      // showToast("Email id or password in wrong", context);

      print("Exception occured: $error stackTrace: $stacktrace");
      progressDialog.dismiss();
      return null;
    }
  }


  Future<SignUpResponse> signupReq(String fName,String lName,String emailId,String mobileNumber,String password,String deviceId,BuildContext context) async {
    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    progressDialog.show();

    print("PASS"+password.toString()+"FDFD");
    try {
      var params = {
        "login_by": "manual",
        // "client_id": client_id,
        // "client_secret": client_secret,
        "first_name": fName,
        "last_name": lName,
        "email": emailId,
        "mobile": mobileNumber,
        "password": password,
        "password_confirmation": password,
        "social_unique_id": "",
        "referred_by": "",
        "device_type": Platform.isAndroid?"android":"ios",
        "device_id": deviceId,
        "device_token": "android",
      };

      print(jsonEncode(params));

      Response response = await _dio.post(baseUrl + _signup_endpoint, data:jsonEncode(params));

      progressDialog.dismiss();

      return SignUpResponse.fromJson(response.data);

    } catch (error, stacktrace) {
      showToast("Email id alerady Register with us", context);

      print("Exception occured: $error stackTrace: $stacktrace");
      progressDialog.dismiss();
      return SignUpResponse.withError(_handleError(error));
    }
  }

  Future<UserProfileRespo> getUserProfile(deviceId,BuildContext context, String accessToken) async {
    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    progressDialog.show();

    try {

      String deviceTypeStr = Platform.isAndroid?"android":"ios";
      print(baseUrl + _userDetailsendpoint+"?device_type="+deviceTypeStr+"&device_id="+deviceId+"&device_token="+"android");

      _dio.options.headers = {"X-Requested-With":"XMLHttpRequest","Authorization" : "Bearer "+accessToken};

      Response response = await _dio.get(baseUrl + _userDetailsendpoint+"?device_type="+deviceTypeStr+"&device_id="+deviceId+"&device_token="+"android");

      progressDialog.dismiss();

      return UserProfileRespo.fromJson(response.data);

    } catch (error, stacktrace) {
      showToast("Email id alerady Register with us", context);

      print("Exception occured: $error stackTrace: $stacktrace");
      progressDialog.dismiss();
      return UserProfileRespo.withError(_handleError(error));
    }
  }

  Future<ServiceResponse> fetchAllServicesReq(BuildContext context, String accessToken,String tokenType) async {
    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    progressDialog.show();

    try {

      String deviceTypeStr = Platform.isAndroid?"android":"ios";

      print(tokenType.toString()+" ACCESS "+accessToken.toString());
      _dio.options.headers = {"X-Requested-With":"XMLHttpRequest","Authorization" : "Bearer " +" "+accessToken.toString()};

      Response response = await _dio.get(baseUrl + _fetchAllServices);

      print(response);
      progressDialog.dismiss();

      return ServiceResponse.fromJson(response.data);

    } catch (error, stacktrace) {
      showToast("Services Not Found", context);

      print("Exception occured: $error stackTrace: $stacktrace");
      progressDialog.dismiss();
      return ServiceResponse.withError(_handleError(error));
    }
  }
  Future<SubServiceResponse> fetchAllSubServicesReq(BuildContext context, String accessToken,String tokenType,String serviceId) async {
    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    progressDialog.show();

    try {

      String deviceTypeStr = Platform.isAndroid?"android":"ios";

      print(tokenType.toString()+" ACCESS "+accessToken.toString());
      _dio.options.headers = {"X-Requested-With":"XMLHttpRequest","Authorization" : "Bearer "+" "+accessToken.toString()};

      Response response = await _dio.get(baseUrl + _fetchAllSubServices.toString()+"/"+serviceId.toString());

      print(response);
      progressDialog.dismiss();

      return SubServiceResponse.fromJson(response.data);

    } catch (error, stacktrace) {
      showToast("Services Not Found", context);

      print("Exception occured: $error stackTrace: $stacktrace");
      progressDialog.dismiss();
      return SubServiceResponse.withError(_handleError(error));
    }
  }
  Future<ProvidersListResponse> fetchAllProvidersListReq(BuildContext context, String accessToken,String tokenType,String serviceId,double currentLat,double currentLng) async {
    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    progressDialog.show();

    try {

      String deviceTypeStr = Platform.isAndroid?"android":"ios";

      print(tokenType.toString()+" ACCESS "+accessToken.toString());
      _dio.options.headers = {"X-Requested-With":"XMLHttpRequest","Authorization" : "Bearer "+" "+accessToken.toString()};

      Response response = await _dio.get(baseUrl + _fetchAllProviders.toString()+"?"+"latitude=" + currentLat.toString() +"&longitude=" + currentLng.toString() +"&service=" + "");


      print(response);
      progressDialog.dismiss();

      return ProvidersListResponse.fromJson(response.data);

    } catch (error, stacktrace) {
      showToast("Services Not Found", context);

      print("Exception occured: $error stackTrace: $stacktrace");
      progressDialog.dismiss();
      return ProvidersListResponse.withError(_handleError(error));
    }
  }
  Future<ApproximatePriceRespo> getApproximatePrice(BuildContext context, String accessToken,String tokenType,String serviceId,double currentLat,double currentLng,double destinationLat,double destinationLng) async {
    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    progressDialog.show();

    try {

      String deviceTypeStr = Platform.isAndroid?"android":"ios";

      print(tokenType.toString()+" ACCESS "+accessToken.toString());
      _dio.options.headers = {"X-Requested-With":"XMLHttpRequest","Authorization" : "Bearer "+" "+accessToken.toString()};

      Response response = await _dio.get(baseUrl + _getApproximatePrice.toString()+"?"+"s_latitude=" + currentLat.toString() +"&s_longitude=" + currentLng.toString()+"&d_latitude=" + destinationLat.toString()+"&d_longitude=" + destinationLng.toString() +"&service_type=" + serviceId);

      print(response);
      progressDialog.dismiss();

      return ApproximatePriceRespo.fromJson(response.data);

    } catch (error, stacktrace) {
      showToast("Services Not Found", context);

      print("Exception occured: $error stackTrace: $stacktrace");
      progressDialog.dismiss();
      return ApproximatePriceRespo.withError(_handleError(error));
    }
  }
  Future<RequestRideModel> sendRideReq(BuildContext context, String accessToken,String tokenType,String serviceId,double currentLat,double currentLng,double destinationLat,double destinationLng,String distance,String schedule_date,String schedule_time,String subdataoption,String use_wallet,String payment_mode, String card_id) async {
    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    progressDialog.show();

    try {

      String deviceTypeStr = Platform.isAndroid?"android":"ios";

      print(tokenType.toString()+" ACCESS "+accessToken.toString());
      _dio.options.headers = {"X-Requested-With":"XMLHttpRequest","Authorization" : "Bearer "+" "+accessToken.toString()};

      var params = {
        "s_latitude": currentLat.toString(),
        "s_longitude": currentLng,
        "d_latitude": destinationLat,
        "d_longitude": destinationLng,
        "s_address": "DFdfsdfd",
        "d_address": "fafasfas",
        "service_type": serviceId,
        "distance": distance,
        "schedule_date": schedule_date,
        "schedule_time": schedule_time,
        "subdataoption": subdataoption,
        "use_wallet": use_wallet,
        "payment_mode": payment_mode,
        "card_id": card_id,
      };


      print(jsonEncode(params));

      Response response = await _dio.post(baseUrl + _sendRideReq.toString(),data:jsonEncode(params)
      );

      print(response);
      progressDialog.dismiss();

      return RequestRideModel.fromJson(response.data);

    } catch (error, stacktrace) {

      showToast("Services Not Found", context);

      print("Exception occured: $error stackTrace: $stacktrace");
      progressDialog.dismiss();
      return RequestRideModel.withError(_handleError(error));
    }
  }
  Future<CheckStatusResponse> reqCheckAPI(BuildContext context, String accessToken,String tokenType) async {
   /* ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));*/

    // progressDialog.show();

    try {

      String deviceTypeStr = Platform.isAndroid?"android":"ios";

      print(tokenType.toString()+" ACCESS "+accessToken.toString());
      _dio.options.headers = {"X-Requested-With":"XMLHttpRequest","Authorization" : "Bearer "+" "+accessToken.toString()};




      Response response = await _dio.get(baseUrl + _reqCheck.toString());

      print(response.toString()+"==REQCHECK");
      // progressDialog.dismiss();

      return CheckStatusResponse.fromJson(response.data);

    } catch (error, stacktrace) {

      // showToast("Services Not Found", context);

      print("Exception occured: $error stackTrace: $stacktrace");
      return CheckStatusResponse.withError(_handleError(error));
    }
  }

  Future<RateYourTripRespo> rateyourTrip(BuildContext context, String accessToken,String tokenType,String request_id,String rating) async {
    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    progressDialog.show();

    try {

      String deviceTypeStr = Platform.isAndroid?"android":"ios";

      print(tokenType.toString()+" ACCESS "+accessToken.toString());
      _dio.options.headers = {"X-Requested-With":"XMLHttpRequest","Authorization" : "Bearer "+" "+accessToken.toString()};


      var params = {
        "request_id": request_id,
        "rating": rating,
        "comment": "",
      };


      print(jsonEncode(params));


      Response response = await _dio.post(baseUrl + _rateYourProvider.toString(),data:jsonEncode(params));

      print(response);
      progressDialog.dismiss();

      return RateYourTripRespo.fromJson(response.data);

    } catch (error, stacktrace) {

      // showToast("Services Not Found", context);

      print("Exception occured: $error stackTrace: $stacktrace");
      return RateYourTripRespo.withError(_handleError(error));
    }
  }

  Future<RateYourTripRespo> cancelTrip(BuildContext context, String accessToken,String tokenType,String request_id,String cancel_reason) async {
    // ArsProgressDialog progressDialog = ArsProgressDialog(
    //     context,
    //     blur: 2,
    //     backgroundColor: Color(0x33000000),
    //     animationDuration: Duration(milliseconds: 500));

    // progressDialog.show();

  try {

      String deviceTypeStr = Platform.isAndroid?"android":"ios";

      print(tokenType.toString()+" ACCESS "+accessToken.toString());
      _dio.options.headers = {"X-Requested-With":"XMLHttpRequest","Authorization" : "Bearer "+" "+accessToken.toString()};
      var params = {
        "request_id": request_id,
        "cancel_reason": cancel_reason,
      };
      print(jsonEncode(params));
      Response response = await _dio.post(baseUrl + _cancelRideReq.toString(),data:jsonEncode(params));
      print(response);
      // progressDialog.dismiss();
      return RateYourTripRespo.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return RateYourTripRespo.withError(_handleError(error));
    }
  }

  String _handleError(Error error) {
    String errorDescription = "";
    if (error is DioError) {
      DioError dioError = error as DioError;
      switch (dioError.type) {
        case DioErrorType.cancel:
          errorDescription = "Request to API server was cancelled";
          break;
        case DioErrorType.connectTimeout:
          errorDescription = "Connection timeout with API server";
          break;
        case DioErrorType.other:
          errorDescription =
          "Connection to API server failed due to internet connection";
          break;
        case DioErrorType.receiveTimeout:
          errorDescription = "Receive timeout in connection with API server";
          break;
        case DioErrorType.response:
          errorDescription =
          "Received invalid status code: ${dioError.response.statusCode}";
          break;
        case DioErrorType.sendTimeout:
          errorDescription = "Send timeout in connection with API server";
          break;
      }
    } else {
      errorDescription = "Unexpected error occured";
    }
    return errorDescription;
  }
}
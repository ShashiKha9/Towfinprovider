import 'dart:io';

import 'package:cbx_driver/HomePage/home_screen.dart';
import 'package:cbx_driver/LoginSignup/Login/login_screen.dart';
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
import 'package:cbx_driver/Utils/helperutils.dart';
import 'package:cbx_driver/repository/login_repo.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../navigation_home_screen.dart';

class LoginBloc {
  final LoginRepository _repository = LoginRepository();
  final BehaviorSubject<LoginResponse> _subject =
      BehaviorSubject<LoginResponse>();
  final BehaviorSubject<SignUpResponse> _subjectSignup =
      BehaviorSubject<SignUpResponse>();
  final BehaviorSubject<UserProfileRespo> _subjectUserProfile =
      BehaviorSubject<UserProfileRespo>();
  final BehaviorSubject<ServiceResponse> _subjectAllServices =
      BehaviorSubject<ServiceResponse>();
  final BehaviorSubject<SubServiceResponse> _subjectAllSubServices =
      BehaviorSubject<SubServiceResponse>();
   BehaviorSubject<ProvidersListResponse> _subjectProvidersList =
      BehaviorSubject<ProvidersListResponse>();

  final BehaviorSubject<ApproximatePriceRespo> _subjectApproximatePriceList =
      BehaviorSubject<ApproximatePriceRespo>();
  final BehaviorSubject<RequestRideModel> _subjectRequestRide =
      BehaviorSubject<RequestRideModel>();
  final BehaviorSubject<CheckStatusResponse> _subjectCheckStatus =
      BehaviorSubject<CheckStatusResponse>();
  final BehaviorSubject<RateYourTripRespo> _subjectRateYourTrip =
      BehaviorSubject<RateYourTripRespo>();
  final BehaviorSubject<RateYourTripRespo> _subjectCancleTrip =
      BehaviorSubject<RateYourTripRespo>();

  loginReq(String emailId, String password, String deviceId,
      BuildContext context) async {
    LoginResponse response =
        await _repository.getLogin(emailId, password, deviceId, context);

    bloc.userProfileReq(
        await _getId(), context, response.access_token);
    _subject.sink.add(response);
  }

  signUpReq(String fName, String lName, String emailId, String mobileNumber,
      String password, String deviceId, BuildContext context) async {
    SignUpResponse response = await _repository.getSignUp(
        fName, lName, emailId, mobileNumber, password, deviceId, context);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LoginScreen();
        },
      ),
    );

    // bloc.userProfileReq(
    //     await _getId(),
    //     context,
    //     prefs.getString(SharedPrefsKeys.ACCESS_TOKEN),
    //     prefs.getString(SharedPrefsKeys.TOKEN_TYPE));

    _subjectSignup.sink.add(response);
  }

  userProfileReq(String deviceId, BuildContext context, String accessToken) async {
    UserProfileRespo response = await _repository.getUserProfile(
        deviceId, context, accessToken);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(SharedPrefsKeys.USER_ID, response.id.toString());
    prefs.setString(SharedPrefsKeys.FIRST_NAME, response.first_name);
    prefs.setString(SharedPrefsKeys.LAST_NAME, response.last_name);
    prefs.setString(SharedPrefsKeys.EMAIL_ADDRESS, response.email);
    prefs.setString(SharedPrefsKeys.ACCESS_TOKEN, accessToken);
    prefs.setString(SharedPrefsKeys.STATUS, response.status);

    print(prefs.getString(SharedPrefsKeys.STATUS).toString()+" ISTATUS");

    /* if (response.avatar.startsWith("http")) {
      prefs.setString(SharedPrefsKeys.PICTURE, response.picture);
    } else {
      prefs.setString(
          SharedPrefsKeys.PICTURE, baseUrl + "storage/" + response.picture);
    }*/
    prefs.setString(SharedPrefsKeys.GENDER, response.gender);
    prefs.setString(SharedPrefsKeys.MOBILE, response.mobile);
    prefs.setString(
        SharedPrefsKeys.WALLET_BALANCE, response.wallet_balance.toString());
    // prefs.setString(SharedPrefsKeys.PAYMENT_MODE, response.payment_mode);
    prefs.setString(SharedPrefsKeys.SOS, response.sos);
    prefs.setBool(SharedPrefsKeys.LOGEDIN, true);

    if (response.currency != "" && response.currency != null) {
      prefs.setString(SharedPrefsKeys.CURRENCY, response.currency);
    } else {
      prefs.setString(SharedPrefsKeys.CURRENCY, "\$");
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return NavigationHomeScreen();
        },
      ),
    );

    _subjectUserProfile.sink.add(response);
  }

  fetchAllServicesReq(
      BuildContext context, String accessToken, String tokenType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    ServiceResponse response = await _repository.fetchAllServicesReq(
        context,
        prefs.getString(SharedPrefsKeys.ACCESS_TOKEN),
        prefs.getString(SharedPrefsKeys.TOKEN_TYPE));

    print(response);
    _subjectAllServices.sink.add(response);
  }

  fetchAllSubServicesReq(BuildContext context, String accessToken,
      String tokenType, String serviceId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    SubServiceResponse response = await _repository.fetchAllSubServicesReq(
        context,
        prefs.getString(SharedPrefsKeys.ACCESS_TOKEN),
        prefs.getString(SharedPrefsKeys.TOKEN_TYPE),
        serviceId);

    print(response);
    _subjectAllSubServices.sink.add(response);
  }

  fetchAllproviderListReq(
      BuildContext context,
      String accessToken,
      String tokenType,
      String serviceId,
      double currentLat,
      double currentLng) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    ProvidersListResponse response = await _repository.fetchAllProviersReq(
        context,
        prefs.getString(SharedPrefsKeys.ACCESS_TOKEN),
        prefs.getString(SharedPrefsKeys.TOKEN_TYPE),
        serviceId,
        currentLat,
        currentLng);

    print(response);
    _subjectProvidersList.sink.add(response);
  }

  getApproximatePrice(
      BuildContext context,
      String accessToken,
      String tokenType,
      String serviceId,
      double currentLat,
      double currentLng,
      double destinationLat,
      double destinationLng) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    ApproximatePriceRespo response = await _repository.getApproximatePrice(
        context,
        prefs.getString(SharedPrefsKeys.ACCESS_TOKEN),
        prefs.getString(SharedPrefsKeys.TOKEN_TYPE),
        serviceId,
        currentLat,
        currentLng,
        destinationLat,
        destinationLng);

    print(response);
    _subjectApproximatePriceList.sink.add(response);
  }

  sendRideReq(
      BuildContext context,
      String accessToken,
      String tokenType,
      String serviceId,
      double currentLat,
      double currentLng,
      double destinationLat,
      double destinationLng,
      String distance,
      String schedule_date,
      String schedule_time,
      String subdataoption,
      String use_wallet,
      String payment_mode,
      String card_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    RequestRideModel response = await _repository.sendRideReq(
        context,
        prefs.getString(SharedPrefsKeys.ACCESS_TOKEN),
        prefs.getString(SharedPrefsKeys.TOKEN_TYPE),
        serviceId,
        currentLat,
        currentLng,
        destinationLat,
        destinationLng,
        distance,
        schedule_date,
        schedule_time,
        subdataoption,
        use_wallet,
        payment_mode,
        card_id);

    print(response);
    _subjectRequestRide.sink.add(response);
  }

  reqCheckAPI(
      BuildContext context, String accessToken, String tokenType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    CheckStatusResponse response = await _repository.reqCheckAPI(
        context,
        prefs.getString(SharedPrefsKeys.ACCESS_TOKEN),
        prefs.getString(SharedPrefsKeys.TOKEN_TYPE));

    print(response);
    _subjectCheckStatus.sink.add(response);
  }

  rateYourTrip(BuildContext context, String accessToken, String tokenType,
      String request_id, String rating) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    RateYourTripRespo response = await _repository.rateYourTrip(
        context,
        prefs.getString(SharedPrefsKeys.ACCESS_TOKEN),
        prefs.getString(SharedPrefsKeys.TOKEN_TYPE),
        request_id,
        rating);


    Navigator.pushAndRemoveUntil(context,
        PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
            new NavigationHomeScreen()), ModalRoute.withName('/')
    );

    print(response);
    _subjectRateYourTrip.sink.add(response);
  }

  cancelTrip(BuildContext context, String accessToken, String tokenType,
      String request_id, String rating) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    RateYourTripRespo response = await _repository.cancelTrip(
        context,
        prefs.getString(SharedPrefsKeys.ACCESS_TOKEN),
        prefs.getString(SharedPrefsKeys.TOKEN_TYPE),
        request_id,
        rating);


    Navigator.pushAndRemoveUntil(context,
        PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
            new NavigationHomeScreen()), ModalRoute.withName('/')
    );

    print(response);
    _subjectCancleTrip.sink.add(response);
  }

  dispose() {
    _subject.close();
    _subjectSignup.close();
    _subjectUserProfile.close();
    _subjectAllServices.close();
    _subjectAllSubServices.close();
    _subjectProvidersList.close();
    _subjectApproximatePriceList.close();
    _subjectRequestRide.close();
    _subjectCheckStatus.close();
    _subjectRateYourTrip.close();
    _subjectCancleTrip.close();

    print("DISPOSED");
  }

  unSubscribeEvents(){
    _subjectRequestRide.add(null);
    _subjectCheckStatus.add(null);
    _subjectProvidersList.sink.add(null);
    _subjectApproximatePriceList.add(null);
    _subjectRateYourTrip.add(null);
    _subjectCancleTrip.add(null);


  }

  BehaviorSubject<LoginResponse> get subject => _subject;

  BehaviorSubject<SignUpResponse> get subjectSignup => _subjectSignup;

  BehaviorSubject<UserProfileRespo> get subjectUserProfile =>
      _subjectUserProfile;

  BehaviorSubject<ServiceResponse> get subjectAllServices =>
      _subjectAllServices;

  BehaviorSubject<SubServiceResponse> get subjectAllSubServices =>
      _subjectAllSubServices;

  BehaviorSubject<ProvidersListResponse> get subjectProvidersList =>
      _subjectProvidersList;

  BehaviorSubject<ApproximatePriceRespo> get subjectApproximatePriceList =>
      _subjectApproximatePriceList;

  BehaviorSubject<RequestRideModel> get subjectRequestRide =>
      _subjectRequestRide;

  BehaviorSubject<CheckStatusResponse> get subjectCheckStatus =>
      _subjectCheckStatus;
BehaviorSubject<RateYourTripRespo> get subjectRateYourTrip =>
    _subjectRateYourTrip;
BehaviorSubject<RateYourTripRespo> get subjectCancleTrip =>
    _subjectCancleTrip;
}

Future<String> _getId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.androidId; // unique ID on Android
  }
}

final bloc = LoginBloc();

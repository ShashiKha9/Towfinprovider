
import 'dart:io';

import 'package:cbx_driver/HomePage/home_screen.dart';
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
import 'package:cbx_driver/repository/userProfile_repo.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../navigation_home_screen.dart';

class UserProfileBloc {
  final UserProfileRepo _userEditProfileRepository = UserProfileRepo();
  final BehaviorSubject<UserProfileRespo> _subjectEditUserProfile =
      BehaviorSubject<UserProfileRespo>();

  userProfileReq(String emailId, String firstName, String lastName,String mobileNumber,
      BuildContext context,String accessToken,String tokenType) async {
    UserProfileRespo response =
        await _userEditProfileRepository.updateUserProfile(emailId, firstName,mobileNumber, lastName, context, accessToken, tokenType);


    SharedPreferences prefs = await SharedPreferences.getInstance();

    // prefs.setString(SharedPrefsKeys.USER_ID, response.id.toString());
    prefs.setString(SharedPrefsKeys.FIRST_NAME, response.first_name);
    prefs.setString(SharedPrefsKeys.LAST_NAME, response.last_name);
    prefs.setString(SharedPrefsKeys.EMAIL_ADDRESS, response.email);

    if (response.picture.startsWith("http")) {
      prefs.setString(SharedPrefsKeys.PICTURE, response.picture);
    } else {
      prefs.setString(
          SharedPrefsKeys.PICTURE, baseUrl + "storage/" + response.picture);
    }
    prefs.setString(SharedPrefsKeys.GENDER, response.gender);
    prefs.setString(SharedPrefsKeys.MOBILE, response.mobile);


    _subjectEditUserProfile.sink.add(response);
  }


  dispose() {
    _subjectEditUserProfile.close();

    print("DISPOSED");
  }

  unSubscribeEvents(){



  }

  BehaviorSubject<UserProfileRespo> get subjectEditUserProfile => _subjectEditUserProfile;

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

final bloc = UserProfileBloc();


import 'dart:io';

import 'package:cbx_driver/HomePage/home_screen.dart';
import 'package:cbx_driver/Modals/AllPastTripList.dart';
import 'package:cbx_driver/Modals/CheckStatusRespone.dart';
import 'package:cbx_driver/Modals/RateYourTripRespo.dart';
import 'package:cbx_driver/Modals/SummaryRespo.dart';
import 'package:cbx_driver/Modals/approximateprice_respo.dart';
import 'package:cbx_driver/Modals/login_response.dart';
import 'package:cbx_driver/Modals/past_trip_list_repo.dart';
import 'package:cbx_driver/Modals/providers_list_repo.dart';
import 'package:cbx_driver/Modals/req_ride_respo.dart';
import 'package:cbx_driver/Modals/services_response.dart';
import 'package:cbx_driver/Modals/signup_response.dart';
import 'package:cbx_driver/Modals/sub_services_response.dart';
import 'package:cbx_driver/Modals/userprofile_response.dart';
import 'package:cbx_driver/Utils/helperutils.dart';
import 'package:cbx_driver/repository/login_repo.dart';
import 'package:cbx_driver/repository/past_history_repo.dart';
import 'package:cbx_driver/repository/provider_sunmary_repo.dart';
import 'package:cbx_driver/repository/userProfile_repo.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../navigation_home_screen.dart';

class ProviderSummaryBloc {
  final ProviderSummary _pastHistoryRepo = ProviderSummary();
  final BehaviorSubject<SummaryRespo> _subjectProviderSummary =
      BehaviorSubject<SummaryRespo>();

  providerSummaryReq(BuildContext context,String accessToken,String tokenType) async {
    SummaryRespo response =
        await _pastHistoryRepo.fetchProviderSummary(context, accessToken, tokenType);


    SharedPreferences prefs = await SharedPreferences.getInstance();


    _subjectProviderSummary.sink.add(response);
  }


  dispose() {
    _subjectProviderSummary.close();

    print("DISPOSED");
  }

  unSubscribeEvents(){



  }

  BehaviorSubject<SummaryRespo> get subjectProviderSummary => _subjectProviderSummary;

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

final bloc = ProviderSummaryBloc();

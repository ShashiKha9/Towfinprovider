
import 'dart:io';
import 'package:cbx_driver/Modals/UpdateDriverStatus.dart';
import 'package:cbx_driver/Utils/helperutils.dart';
import 'package:cbx_driver/repository/driverstatusupdate_repo.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateDriverStatusBloc {
  final DriverStatusUpdate _addCardRepository = DriverStatusUpdate();
  final BehaviorSubject<UpdateDriverStatus> _subjectAddcard = BehaviorSubject<UpdateDriverStatus>();

  updateDriverStatus(
      BuildContext context,String accessToken,String driver_status) async {
    UpdateDriverStatus response =
        await _addCardRepository.updateDriverStatus(context, accessToken, driver_status);

    showToast(response.login_by, context);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(SharedPrefsKeys.STATUS, response.service.status.toString());

    _subjectAddcard.sink.add(response);
  }


  dispose() {
    _subjectAddcard.close();
  }

  unSubscribeEvents(){

    // {message: Password Updated}

  }

  BehaviorSubject<UpdateDriverStatus> get subjectAddcard => _subjectAddcard;

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

final bloc = UpdateDriverStatusBloc();

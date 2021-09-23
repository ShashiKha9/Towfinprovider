
import 'dart:io';

import 'package:cbx_driver/Modals/changepass_response.dart';
import 'package:cbx_driver/Utils/helperutils.dart';
import 'package:cbx_driver/repository/changepassword_repo.dart';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ChangePasswordBloc {
  final ChangePasswordRepo _userChangePasswordRepository = ChangePasswordRepo();
  final BehaviorSubject<ChangePasswordRespo> _subjectChangePassword = BehaviorSubject<ChangePasswordRespo>();

  changePasswordReq(String password, String password_confirmation, String old_password,
      BuildContext context,String accessToken,String tokenType) async {
    ChangePasswordRespo response =
        await _userChangePasswordRepository.changePasswordReq(password, password_confirmation,old_password, context, accessToken, tokenType);

    showToast(response.message, context);

    _subjectChangePassword.sink.add(response);
  }


  dispose() {
    _subjectChangePassword.close();
  }

  unSubscribeEvents(){

    // {message: Password Updated}

  }

  BehaviorSubject<ChangePasswordRespo> get subjectChangePassword => _subjectChangePassword;

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

final bloc = ChangePasswordBloc();

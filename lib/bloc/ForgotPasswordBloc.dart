
import 'dart:io';

import 'package:cbx_driver/Modals/changepass_response.dart';
import 'package:cbx_driver/Modals/forgetpass_response.dart';
import 'package:cbx_driver/Utils/helperutils.dart';
import 'package:cbx_driver/repository/changepassword_repo.dart';
import 'package:cbx_driver/repository/forgetpassword_repo.dart';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ForgotPasswordBloc {
  final ForgetPasswordRepo _userForgetPasswordRepository = ForgetPasswordRepo();
  final BehaviorSubject<ForgetPasswordRespo> _subjectForgetPassword = BehaviorSubject<ForgetPasswordRespo>();

  forgetPasswordReq(String email,
      BuildContext context,String accessToken,String tokenType) async {
    ForgetPasswordRespo response =
        await _userForgetPasswordRepository.forgetPasswordReq(email, context, accessToken, tokenType);

    showToast(response.message, context);

    _subjectForgetPassword.sink.add(response);
  }


  dispose() {
    _subjectForgetPassword.close();
  }

  unSubscribeEvents(){

    // {message: Password Updated}

  }

  BehaviorSubject<ForgetPasswordRespo> get subjectForgetPassword => _subjectForgetPassword;

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

final bloc = ForgotPasswordBloc();

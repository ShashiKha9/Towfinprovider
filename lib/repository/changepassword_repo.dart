import 'package:cbx_driver/Modals/CheckStatusRespone.dart';
import 'package:cbx_driver/Modals/RateYourTripRespo.dart';
import 'package:cbx_driver/Modals/changepass_response.dart';
import 'package:cbx_driver/Modals/login_response.dart';
import 'package:cbx_driver/Modals/providers_list_repo.dart';
import 'package:cbx_driver/Modals/req_ride_respo.dart';
import 'package:cbx_driver/Modals/services_response.dart';
import 'package:cbx_driver/Modals/signup_response.dart';
import 'package:cbx_driver/Modals/sub_services_response.dart';
import 'package:cbx_driver/Modals/userprofile_response.dart';
import 'package:flutter/cupertino.dart';

import 'api_provider.dart';

class ChangePasswordRepo{

  ApiProvider _apiProvider = ApiProvider();

  Future<ChangePasswordRespo> changePasswordReq(String password, String password_confirmation, String old_password,
      BuildContext context,String accessToken,String tokenType){
    return _apiProvider.changePassword(password, password_confirmation,old_password, context, accessToken, tokenType);
  }

}
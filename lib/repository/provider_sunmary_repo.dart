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
import 'package:flutter/cupertino.dart';

import 'api_provider.dart';

class ProviderSummary{

  ApiProvider _apiProvider = ApiProvider();

  Future<SummaryRespo> fetchProviderSummary(BuildContext context,String accessToken,String tokenType){
    return _apiProvider.fetchProvderSummary(context, accessToken, tokenType);
  }

}
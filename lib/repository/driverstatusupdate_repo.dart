import 'package:cbx_driver/Modals/UpdateDriverStatus.dart';
import 'package:flutter/cupertino.dart';

import 'api_provider.dart';

class DriverStatusUpdate{

  ApiProvider _apiProvider = ApiProvider();

  Future<UpdateDriverStatus> updateDriverStatus(
      BuildContext context,String accessToken,String serviceStatus){
    return _apiProvider.updateDriverStatus(context, accessToken,serviceStatus);
  }

}
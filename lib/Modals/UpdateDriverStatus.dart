import 'package:cbx_driver/Modals/Service.dart';

import 'User.dart';

class UpdateDriverStatus {
  final String login_by;
  final Service service;



  UpdateDriverStatus(
      this.login_by,
      this.service,
      );

  UpdateDriverStatus.fromJson(Map<String, dynamic> json)
      :
        login_by=json["login_by"],
        service = json['service']!=null?Service.fromJson(json['service']):null;





  UpdateDriverStatus.withError(String errorValue)
      : login_by = errorValue,
       service = null;
}

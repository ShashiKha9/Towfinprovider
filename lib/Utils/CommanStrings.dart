import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

String BASE_URL = "https://roadrunnersclub.net/";
String ASSET_URL = "http://lgemarrakech.com/";
String PAYSTACKKEY = "pk_live_993e4d50be323b3b8dbeeb84c6398ffa95e7adac";

String getStatusUrl = "api/provider/trip?";
String changeBookingStatusUrl = "api/provider/trip/";
String cancelRideUrl = "api/provider/cancel";


class SharedPrefKey {
  static String ISLOGEDIN = "ISLOGEDIN";
  static String USERID = "USERID";
  static String EMAILID = "EMAILID";
  static String FULLNAME = "FULLNAME";
  static String LASTNAME = "LASTNAME";
  static String MOBILENO = "MOBILENO";
  static String PROFILEPIC = "PROFILEPIC";
  static String MAKEBOOKINGVALUES = "MAKEBOOKINGVALUES";
  static String SAVEMOVETYPE = "SAVEMOVETYPE";
  static String SAVEPICKUPDELIVERY = "SAVEPICKUPDELIVERY";
  static String SAVEBOOKINGPHOTOS = "SAVEBOOKINGPHOTOS";
  static String SAVEVEHICLETYPE = "SAVEVEHICLETYPE";
  static String SAVECHOOSEMOOFER = "SAVECHOOSEMOOFER";

  static String CREDITCARDNUMBER = "CREDITCARDNUMBER";
  static String EXPIRY = "EXPIRY";
  static String CVV = "CVV";

  static read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    // return json.decode(prefs.getString(key));
  }
}

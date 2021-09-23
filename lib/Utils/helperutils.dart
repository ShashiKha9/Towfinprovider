import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

final String baseUrl = "https://roadrunnersclub.net/";



class SharedPrefsKeys{
  static final String ACCESS_TOKEN = "access_token";
  static final String REFRESH_TOKEN = "refresh_token";
  static final String CURRENCY = "currency";
  static final String STATUS = "status";
  static final String TOKEN_TYPE = "status";
  static final String ISONLINEORNOT = "isonlineornot";

  // User Basic SharedPreferences Details
  static final String USER_ID = "user_id";
  static final String FIRST_NAME = "first_name";
  static final String LAST_NAME = "last_name";
  static final String EMAIL_ADDRESS = "email";
  static final String PICTURE = "picture";
  static final String GENDER = "gender";
  static final String MOBILE = "mobile";
  static final String WALLET_BALANCE = "wallet_balance";
  static final String PAYMENT_MODE = "payment_mode";
  static final String SOS = "sos";
  static final String LOGEDIN = "loggedIn";
}
void showToast(String msg,BuildContext context){
  Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);

}

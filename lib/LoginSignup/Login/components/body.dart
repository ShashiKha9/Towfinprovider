import 'dart:io';

import 'package:cbx_driver/LoginSignup/Signup/signup_screen.dart';
import 'package:cbx_driver/Modals/login_response.dart';
import 'package:cbx_driver/Utils/helperutils.dart';
import 'package:cbx_driver/bloc/LoginBloc.dart';
import 'package:cbx_driver/components/already_have_an_account_acheck.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app_theme.dart';
import 'background.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  SharedPreferences prefs;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: size.height / 3,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                    top: 0,
                    left: 0,
                    child: Stack(
                      children: [
                        Container(
                            height: size.height * 0.33,
                            width: size.width,
                            decoration: new BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomRight,
                                  end: Alignment.centerLeft,
                                  colors: [
                                    AppTheme.colorPrimary,
                                    AppTheme.colorPrimaryDark
                                  ]),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.lerp(Radius.circular(50),
                                      Radius.circular(60), 5),
                                  bottomRight: Radius.lerp(Radius.circular(50),
                                      Radius.circular(50), 5)),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/dotsbg.png",
                                  width: 200,
                                  height: 200,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(
                                        'Welcome Back!',
                                        style: TextStyle(
                                            color: AppTheme.white,
                                            fontFamily: AppTheme.fontName,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 35),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        'Let\'s get you a ride!',
                                        style: TextStyle(
                                            color: AppTheme.white,
                                            fontFamily: AppTheme.fontName,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            )),
                      ],
                    )),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.03),
          SizedBox(height: size.height * 0.03),
          Padding(
              padding: EdgeInsets.only(left: 55, right: 55),
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    // inputFormatters:<TextInputFormatter>[formater],
                    cursorColor: AppTheme.nearlyBlack,

                    decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: new TextStyle(
                            color: AppTheme.darkerText,
                            fontFamily: AppTheme.fontName,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                        labelStyle: new TextStyle(
                            color: const Color(0xFF424242),
                            fontFamily: AppTheme.fontName,
                            fontSize: 15),
                        border: new UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.red))),
                  ),
                  SizedBox(height: size.height * 0.03),
                  TextField(
                    controller: _passwordController,
                    keyboardType: TextInputType.text,
                    // inputFormatters:<TextInputFormatter>[formater],
                    obscureText: true,
                    cursorColor: AppTheme.nearlyBlack,
                    decoration: InputDecoration(
                        hintStyle: new TextStyle(
                            color: AppTheme.darkerText,
                            fontFamily: AppTheme.fontName,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                        hintText: "Password",
                        labelStyle: new TextStyle(
                            color: const Color(0xFF424242),
                            fontFamily: AppTheme.fontName,
                            fontSize: 12),
                        border: new UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.red))),
                  ),
                ],
              )),
          SizedBox(height: size.height * 0.03),
          submitButton(_emailController.text.toString(),
              _passwordController.text.toString()),
          SizedBox(height: size.height * 0.03),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget submitButton(String emailId, String password) =>
      StreamBuilder<LoginResponse>(
          stream: bloc.subject.stream,
          builder: (context, snap) {
            return Column(
              children: <Widget>[
                ElevatedButton(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 110, right: 110, top: 15, bottom: 15),
                    child: Text("Login", style: TextStyle(fontSize: 14)),
                  ),
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          AppTheme.colorPrimary),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(color: AppTheme.colorPrimary)))),
                  onPressed: () async => {
                    if (_emailController.text.toString().isEmpty)
                      {
                        showAlertDialog(
                            context: context,
                            title: "Require Email",
                            content: "Please Enter Email Id",
                            defaultActionText: "OK")
                      }
                    else if (_passwordController.text.toString().isEmpty)
                      {
                        showAlertDialog(
                            context: context,
                            title: "Require Password",
                            content: "Please Enter Password",
                            defaultActionText: "OK")
                      }else{
                         bloc.loginReq(emailId, password, await _getId(),context),

                          prefs.setString(SharedPrefsKeys.ACCESS_TOKEN, snap.data.access_token),
                          prefs.setString(SharedPrefsKeys.CURRENCY, snap.data.currency),
                          // prefs.setString(SharedPrefsKeys.TOKEN_TYPE, snap.data.token_type),


                      }
                  },
                ),
              ],
            );
          });

  @override
  void initState() {
    super.initState();
    initState();
  }
  Future<void> initPrefs() async {
     prefs = await SharedPreferences.getInstance();

  }



  Widget _buildLoadingWidget() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Loading data from API...",
            style: Theme.of(context).textTheme.subtitle),
        Padding(
          padding: EdgeInsets.only(top: 5),
        ),
        CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
        )
      ],
    ));
  }

  Widget _buildErrorWidget(String error) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Error occured: $error",
            style: Theme.of(context).textTheme.subtitle),
      ],
    ));
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

  Widget _buildUserWidget(LoginResponse data) {
    LoginResponse loginResponse = data;
    print(loginResponse);
    _buildLoadingWidget();
  }
}

Future<bool> showAlertDialog({
  @required BuildContext context,
  @required String title,
  @required String content,
  String cancelActionText,
  @required String defaultActionText,
}) async {
  if (!Platform.isIOS) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          if (cancelActionText != null)
            FlatButton(
              child: Text(cancelActionText),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          FlatButton(
            child: Text(defaultActionText),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }

  // todo : showDialog for ios
  return showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        if (cancelActionText != null)
          CupertinoDialogAction(
            child: Text(cancelActionText),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        CupertinoDialogAction(
          child: Text(defaultActionText),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );
}

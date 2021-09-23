import 'dart:io';

import 'package:cbx_driver/LoginSignup/Login/login_screen.dart';
import 'package:cbx_driver/Modals/login_response.dart';
import 'package:cbx_driver/Modals/signup_response.dart';
import 'package:cbx_driver/Modals/userprofile_response.dart';
import 'package:cbx_driver/Utils/helperutils.dart';
import 'package:cbx_driver/bloc/LoginBloc.dart';
import 'package:cbx_driver/components/already_have_an_account_acheck.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_theme.dart';
import 'components/body.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _fNameControllre = TextEditingController();
  final _lNameControllre = TextEditingController();
  final _mobileNoControllre = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  SharedPreferences prefs;
  bool _showPassword = false;
  void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
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
                                        'Sign Up!',
                                        style: TextStyle(
                                            color: AppTheme.white,
                                            fontFamily: AppTheme.fontName,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 35),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Center(
                                      child: Text(
                                        'Please fill the details below to\ncomplete your account',
                                        style: TextStyle(
                                            color: AppTheme.white,
                                            fontFamily: AppTheme.fontName,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16),
                                        textAlign: TextAlign.center,
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
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(left: 55, right: 5, top: 30),
                  child: TextField(
                    controller: _fNameControllre,
                    keyboardType: TextInputType.name,
                    // inputFormatters:<TextInputFormatter>[formater],
                    cursorColor: AppTheme.nearlyBlack,

                    decoration: InputDecoration(
                        hintText: "First Name",
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
                ),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(left: 5, right: 55, top: 30),
                  child: TextField(
                    controller: _lNameControllre,
                    keyboardType: TextInputType.name,
                    // inputFormatters:<TextInputFormatter>[formater],
                    cursorColor: AppTheme.nearlyBlack,

                    decoration: InputDecoration(
                        hintText: "Last Name",
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
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 55, right: 55, top: 20),
            child: TextField(
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
          ),
          Padding(
              padding: EdgeInsets.only(left: 55, right: 55, top: 20),
              child: Column(
                children: [
                  TextField(
                    controller: _mobileNoControllre,
                    keyboardType: TextInputType.number,
                    // inputFormatters:<TextInputFormatter>[formater],
                    cursorColor: AppTheme.nearlyBlack,

                    decoration: InputDecoration(
                        hintText: "Mobile Number",
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
                    obscureText: !_showPassword,
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
                            borderSide: new BorderSide(color: Colors.red)),
                        suffixIcon: GestureDetector(
                        onTap: () {
                  _togglevisibility();
                  },
                    child: Icon(
                      _showPassword ? Icons.visibility : Icons
                          .visibility_off, color: Colors.red,),
                  ),

          ),

                  ),
                ],
              )),
          SizedBox(height: size.height * 0.03),
          submitButton(
              _fNameControllre.text.toString(),
              _lNameControllre.text.toString(),
              _emailController.text.toString(),
              _mobileNoControllre.text.toString(),
              _passwordController.text.toString()),
          SizedBox(height: size.height * 0.03),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    ));
  }

  Widget submitButton(String fName, String lName, String emailId,
          String mobileNum, String password) =>
      StreamBuilder<SignUpResponse>(
          stream: bloc.subjectSignup.stream,
          builder: (context, snap) {
            return Column(
              children: <Widget>[
                ElevatedButton(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 110, right: 110, top: 15, bottom: 15),
                    child: Text("Sign Up", style: TextStyle(fontSize: 14)),
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
                    if (_fNameControllre.text.toString().isEmpty)
                      {
                        showAlertDialog(
                            context: context,
                            title: "Require First Name",
                            content: "Please Enter First Name",
                            defaultActionText: "OK")
                      }
                    else if (_lNameControllre.text.toString().isEmpty)
                      {
                        showAlertDialog(
                            context: context,
                            title: "Require Last Name",
                            content: "Please Enter Last Name",
                            defaultActionText: "OK")
                      }
                    else if (_emailController.text.toString().isEmpty)
                      {
                        showAlertDialog(
                            context: context,
                            title: "Require Email",
                            content: "Please Enter Email Id",
                            defaultActionText: "OK")
                      }
                    else if (_mobileNoControllre.text.toString().isEmpty)
                      {
                        showAlertDialog(
                            context: context,
                            title: "Require Mobile Number",
                            content: "Please Enter Mobile Number",
                            defaultActionText: "OK")
                      }
                    else if (_passwordController.text.toString().isEmpty)
                      {
                        showAlertDialog(
                            context: context,
                            title: "Require Password",
                            content: "Please Enter Password",
                            defaultActionText: "OK")
                      }
                    else
                      {
                        bloc.signUpReq(fName,lName, emailId,mobileNum, password, await _getId(), context),
                      // prefs = await SharedPreferences.getInstance(),

                      }
                  },
                ),
              ],
            );
          });

  Future<dynamic> _getPrefs() async {
    return prefs;
  }
  getProfile(){
    StreamBuilder<UserProfileRespo>(
        stream: bloc.subjectUserProfile.stream,
        // ignore: missing_return
        builder: (context, snap) {


          prefs.setString(SharedPrefsKeys.USER_ID, snap.data.id.toString());
          prefs.setString(SharedPrefsKeys.FIRST_NAME, snap.data.first_name);
          prefs.setString(SharedPrefsKeys.LAST_NAME, snap.data.last_name);
          prefs.setString(SharedPrefsKeys.EMAIL_ADDRESS, snap.data.email);
          if(snap.data.picture.startsWith("http")){
            prefs.setString(SharedPrefsKeys.PICTURE, snap.data.picture);
          }else{
            prefs.setString(SharedPrefsKeys.PICTURE, baseUrl+"storage/"+snap.data.picture);
          }
          prefs.setString(SharedPrefsKeys.GENDER, snap.data.gender);
          prefs.setString(SharedPrefsKeys.MOBILE, snap.data.mobile);
          prefs.setString(SharedPrefsKeys.WALLET_BALANCE, snap.data.wallet_balance.toString());
          prefs.setString(SharedPrefsKeys.PAYMENT_MODE, snap.data.payment_mode);
          prefs.setString(SharedPrefsKeys.SOS, snap.data.sos);
          prefs.setBool(SharedPrefsKeys.LOGEDIN, true);

          if(snap.data.currency !="" && snap.data.currency!=null){
            prefs.setString(SharedPrefsKeys.CURRENCY, snap.data.currency);
          }else{
            prefs.setString(SharedPrefsKeys.CURRENCY, "\$");
          }

/*          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return SignUpScreen();
              },
            ),
          );*/

        });


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

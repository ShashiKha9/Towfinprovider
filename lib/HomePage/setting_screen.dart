import 'dart:convert';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:cbx_driver/HomePage/change_password.dart';
import 'package:cbx_driver/Utils/helperutils.dart';
import 'package:cbx_driver/bloc/UserProfileBloc.dart';
import 'package:cbx_driver/components/rounded_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_theme.dart';
import '../main.dart';
import 'edit_account.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  _SettingsScreenState();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileNumController = TextEditingController();
  final _emailaddressController = TextEditingController();
  SharedPreferences prefs;
  @override
  void initState() {
    super.initState();

    initPreferences();

    _mobileNumController.addListener(_printLatestValue);
  }

  Future<void> initPreferences() async {
    prefs = await SharedPreferences.getInstance();
    _firstNameController.text = prefs.getString(SharedPrefsKeys.FIRST_NAME);
    _lastNameController.text = prefs.getString(SharedPrefsKeys.LAST_NAME);
    _mobileNumController.text = prefs.getString(SharedPrefsKeys.MOBILE);
    _emailaddressController.text =
        prefs.getString(SharedPrefsKeys.EMAIL_ADDRESS);

    setState(() {});
  }

  _printLatestValue() {
    print("Second text field: ${_mobileNumController.text}");

    // });
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  @override
  void dispose() {
    _mobileNumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.white,

      appBar: AppBar(brightness: Brightness.light, backgroundColor: AppTheme.white,elevation: 0,

        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 22,
            color: AppTheme.darkText,
            fontWeight: FontWeight.w700,
          ),
        ),

      ),
      body: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: 20,),
                Padding(padding: EdgeInsets.only(left: 20,right:20),
                child:Divider(
                  color: Colors.grey,
                  height: 1,
                ),

                ),


                Padding(padding: EdgeInsets.all(20),
                child:
                    InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return EditAccount();
                            },
                          ),
                        );
                      },
                      child:   Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Row(
                              children: <Widget>[
                                Image.asset("assets/images/profile.png",height: 25,color: Colors.grey,),
                                SizedBox(width: 15,),
                                Text("Personal Info",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ]
                          ),
                          Icon(Icons.keyboard_arrow_right_outlined,color: Colors.grey,),
                        ],
                      ),

                    )
                  ),

                Padding(padding: EdgeInsets.only(left: 20,right:20),
                  child:Divider(
                    color: Colors.grey,
                    height: 1,
                  ),

                ),

                Padding(padding: EdgeInsets.all(20),
                child:
                    InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ChangePassword();
                            },
                          ),
                        );
                      },
                      child:   Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Row(
                              children: <Widget>[
                                Image.asset("assets/images/pin-code.png",height: 25,color: Colors.grey,),
                                SizedBox(width: 15,),
                                Text("Change Password",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ]
                          ),
                          Icon(Icons.keyboard_arrow_right_outlined,color: Colors.grey,),
                        ],
                      ),

                    )
                  ),
                Padding(padding: EdgeInsets.only(left: 20,right:20),
                  child:Divider(
                    color: AppTheme.grey,
                    height: 1,
                  ),

                ),

                Padding(padding: EdgeInsets.all(20),
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Row(
                          children: <Widget>[
                            Image.asset("assets/images/start.png",height: 25,color: Colors.grey,),
                            SizedBox(width: 15,),
                            Text("Rate This App!",
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: AppTheme.fontName,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ]
                      ),
                      Icon(Icons.keyboard_arrow_right_outlined,color: Colors.grey,),
                    ],
                  ),
                ),

                 Padding(padding: EdgeInsets.only(left: 20,right:20),
                  child:Divider(
                    color: AppTheme.grey,
                    height: 1,
                  ),

                ),

                Padding(padding: EdgeInsets.all(20),
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Row(
                          children: <Widget>[
                            Image.asset("assets/images/terms.png",height: 25,color: Colors.grey,),
                            SizedBox(width: 15,),
                            Text("Terms and Conditions",
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: AppTheme.fontName,

                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ]
                      ),
                      Icon(Icons.keyboard_arrow_right_outlined,color: Colors.grey,),
                    ],
                  ),
                ),

                Padding(padding: EdgeInsets.only(left: 20,right:20),
                  child:Divider(
                    color: AppTheme.grey,
                    height: 1,
                  ),

                ),
                Padding(padding: EdgeInsets.all(20),
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Row(
                          children: <Widget>[
                            Image.asset("assets/images/shield.png",height: 25,color: Colors.grey,),
                            SizedBox(width: 15,),
                            Text("Privacy Policy",
                              style: TextStyle(
                                fontFamily: AppTheme.fontName,

                                fontSize: 18,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ]
                      ),
                      Icon(Icons.keyboard_arrow_right_outlined,color: Colors.grey,),
                    ],
                  ),
                ),

                Padding(padding: EdgeInsets.only(left: 20,right:20),
                  child:Divider(
                    color: AppTheme.grey,
                    height: 1,
                  ),

                ),



              ],
            ));
          }
        },
      ),
    );
  }

  void _showMyDialog(
    BuildContext context,
    String msg,
    String header,
  ) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(header),
            content: Padding(
              padding: EdgeInsets.all(10),
              child: Text(msg),
            ),
            actions: <Widget>[
              /*CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text("Cancel")
          ),*/
              CupertinoDialogAction(
                  textStyle: TextStyle(
                      color: Colors.red, fontFamily: AppTheme.fontName),
                  isDefaultAction: true,
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Okay",
                    style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        color: AppTheme.colorPrimaryDark),
                  )),
            ],
          );
        });
  }
}

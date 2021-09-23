import 'dart:convert';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:cbx_driver/Utils/helperutils.dart';
import 'package:cbx_driver/bloc/ChnagePasswordBloc.dart';
import 'package:cbx_driver/components/rounded_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_theme.dart';
import '../main.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({
    Key key}) : super(key: key);


  @override
  _ChangePasswordState createState() =>
      _ChangePasswordState(

      );
}

class _ChangePasswordState extends State<ChangePassword>
    with TickerProviderStateMixin {
  _ChangePasswordState();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showPassword = false;
  bool _showNewPassword = false;
  bool _showCPassword = false;
  void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }
  void _toggleNewPassvisibility() {
    setState(() {
      _showNewPassword = !_showNewPassword;
    });
  }
 void _toggleCPassvisibility() {
    setState(() {
      _showCPassword = !_showCPassword;
    });
  }



  @override
  void initState() {

    super.initState();


    initPreferences();

    // _mobileNumController.addListener(_printLatestValue);


  }

  Future<void> initPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {

    });

  }


  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
 
    return Scaffold(
      key:_scaffoldKey,
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: IconThemeData(
          color: AppTheme.white, //change your color here
        ),

        title: Column(
          children: [
            Text(
              'Change Password',
              style: TextStyle(
                fontSize: 20,
                color: AppTheme.white,
                fontWeight: FontWeight.w400,
              ),
            ),

          ],
        ),
        elevation: 0,
        backgroundColor: AppTheme.colorPrimary,
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
                Padding(
                  padding: EdgeInsets.only(left: 25, right: 25,top:25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Old Password",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.darkerText,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppTheme.fontName)),

                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 25, right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: size.width * 0.8,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: new TextField(
                          controller: _oldPasswordController,
                          keyboardType: TextInputType.text,
                          obscureText: !_showPassword,

                          decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            hintText: 'Old Password',
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
                      ),

                    ],
                  ),
                ),



                Padding(
                  padding: EdgeInsets.only(left: 25, right: 25,top:25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("New Password",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.darkerText,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppTheme.fontName)),

                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 25, right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: size.width * 0.8,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: new TextField(
                          controller: _newPasswordController,
                          keyboardType: TextInputType.text,
                          obscureText: !_showNewPassword,
                          decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.grey),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                            ),
                            hintText: 'New Password',
                            suffixIcon: GestureDetector(
                              onTap: () {
                                _toggleNewPassvisibility();
                              },
                              child: Icon(
                                _showNewPassword ? Icons.visibility : Icons
                                    .visibility_off, color: Colors.red,),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 30, left: 25, right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Confirm Password",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.darkerText,
                              fontWeight: FontWeight.w600,
                              fontFamily: "WorkSans")),

                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 25, right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: size.width * 0.8,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(10),

                        ),

                        child:
                        new TextField(
                          autofocus: true,
                          keyboardType: TextInputType.text,
                          obscureText: !_showCPassword,
                          controller: _confirmPasswordController,


                          decoration: new InputDecoration(

                            border: new OutlineInputBorder(
                              borderSide:
                              new BorderSide(color: Colors.grey),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                            ),
                            hintText: 'Confirm Password',
                            suffixIcon: GestureDetector(
                              onTap: () {
                                _toggleCPassvisibility();
                              },
                              child: Icon(
                                _showCPassword ? Icons.visibility : Icons
                                    .visibility_off, color: Colors.red,),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),


                Divider(
                  height: 50,
                  thickness: 15,
                  color: AppTheme.chipBackground,
                ),

                SizedBox(
                  height: 15,
                ),

              ],
            ));
          }
        },
      ),
      bottomNavigationBar: Visibility(
          visible: true,
          child: Container(
            alignment: Alignment.center,
            height: size.height * 0.12,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RoundedButton(
                  color: AppTheme.colorPrimary,
                  text: "Change Password",
                  press: () async {
                    if (_oldPasswordController.text.toString().isEmpty) {
                      _showMyDialog(
                          context, "Please enter old password.","Error");

                    }else if (_newPasswordController.text.toString().isEmpty) {
                      _showMyDialog(
                          context, "Please enter new password.","Error");

                    }else if (_confirmPasswordController.text.toString().isEmpty) {
                      _showMyDialog(
                          context, "Please enter password again.","Error");
                    }else if (_newPasswordController.text.toString()!=_confirmPasswordController.text.toString()) {
                      _showMyDialog(
                          context, "Password not match please recheck.","Error");
                    }  else{

                      SharedPreferences  prefs = await SharedPreferences.getInstance();


                      showCupertinoDialog(
                        context: _scaffoldKey.currentContext,
                        builder: (context) =>
                            CupertinoAlertDialog(
                              content: Text(
                                  "Are you sure you want to update?"),
                              actions: <Widget>[

                                CupertinoDialogAction(
                                    child: Text("Yes"),
                                    onPressed: () =>
                                    {
                                      Navigator.of(context).pop(false),
                                      bloc.changePasswordReq(_newPasswordController.text.toString()
                                          ,_confirmPasswordController.text.toString()
                                          ,_oldPasswordController.text.toString()
                                          ,_scaffoldKey.currentContext,
                                          
                                      prefs.getString(SharedPrefsKeys.ACCESS_TOKEN)
                                          ,prefs.getString(SharedPrefsKeys.TOKEN_TYPE)
                                      )
                                    }
                                ),
                                CupertinoDialogAction(
                                  child: Text("No"),
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                ),
                              ],
                            ),
                      );

                    }

                  },
                ),
              ],
            ),
          )),
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
                textStyle:
                    TextStyle(color: Colors.red, fontFamily: AppTheme.fontName),
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
        );});
  }





}



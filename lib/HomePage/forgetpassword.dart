import 'dart:convert';


import 'package:cbx_driver/bloc/ForgotPasswordBloc.dart';
import 'package:cbx_driver/components/rounded_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_theme.dart';
import '../main.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({
    Key key}) : super(key: key);


  @override
  _ForgetPasswordState createState() =>
      _ForgetPasswordState(

      );
}

class _ForgetPasswordState extends State<ForgetPassword>
    with TickerProviderStateMixin {
  _ForgetPasswordState();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  final _emailaddressController = TextEditingController();




  @override
  void initState() {

    super.initState();


    initPreferences();



  }

  Future<void> initPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {

    });

  }

  _printLatestValue() {



    // });
  }
  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  @override
  void dispose() {
    super.dispose();
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
              'Forget Password',
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
                Visibility(
                  visible: true,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 20, bottom: 20),
                    child: Text("Enter your mail ID for recovery",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 20,
                            color: AppTheme.darkerText,
                            fontWeight: FontWeight.w800,
                            fontFamily: "WorkSans")),
                  ),
                ),


                Padding(
                  padding: EdgeInsets.only(top: 30, left: 25, right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Email Address",
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
                        child: new TextField(
                          keyboardType: TextInputType.emailAddress,

                          controller: _emailaddressController,
                          decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            hintText: 'Email Address',
                          ),
                        ),
                      ),

                    ],
                  ),
                ),



                SizedBox(
                  height: 15,
                ),

                Visibility(
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
                            text: "Submit",
                            press: () async {
                            if (_emailaddressController.text.toString().isEmpty) {
                                _showMyDialog(
                                    context, "Please enter email address.","Error");

                              }  else{


                              bloc.forgetPasswordReq(
                                  _emailaddressController.text.toString()
                                  ,_scaffoldKey.currentContext,

                                  ""
                                  ,""
                              );

                              }

                            },
                          ),
                        ],
                      ),
                    )),



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



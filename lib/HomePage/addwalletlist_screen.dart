import 'dart:convert';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
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

class AddWalletListScreen extends StatefulWidget {
  const AddWalletListScreen({Key key}) : super(key: key);

  @override
  _AddWalletListScreenState createState() => _AddWalletListScreenState();
}

class _AddWalletListScreenState extends State<AddWalletListScreen>
    with TickerProviderStateMixin {
  _AddWalletListScreenState();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  SharedPreferences prefs;
  @override
  void initState() {
    super.initState();

    initPreferences();

  }

  Future<void> initPreferences() async {
    prefs = await SharedPreferences.getInstance();


    setState(() {});
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
      key: _scaffoldKey,

      backgroundColor: AppTheme.white,


      appBar: AppBar(brightness: Brightness.light, backgroundColor: AppTheme.white,elevation: 0,
        leading: BackButton(
            color: Colors.black
        ),
        automaticallyImplyLeading: true,
        title:
        Text(
          'Add Amount',
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
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [



                Card(
                  margin: EdgeInsets.all(5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  color: AppTheme.white,
                  elevation: 3,
                  child: Container(
                      height: size.height * 0.17,
                      width: size.width*0.85,
                      decoration: new BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            end: Alignment.centerLeft,
                            colors: [
                              AppTheme.colorPrimary,
                              AppTheme.colorPrimaryDark
                            ]),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.lerp(
                                Radius.circular(20), Radius.circular(20), 5),
                            topLeft: Radius.lerp(
                                Radius.circular(20), Radius.circular(20), 5),
                            topRight: Radius.lerp(
                                Radius.circular(20), Radius.circular(20), 5),
                            bottomRight: Radius.lerp(
                                Radius.circular(20), Radius.circular(20), 5)),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  'Available Balance',
                                  style: TextStyle(
                                      color: AppTheme.white,
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Text(
                                    prefs.getString(SharedPrefsKeys.CURRENCY)+" "+prefs.getString(SharedPrefsKeys.WALLET_BALANCE),
                                  style: TextStyle(
                                      color: AppTheme.white,
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 26),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          )
                        ],
                      )),
                ),

                Padding(padding: EdgeInsets.only(left: 20,right:20,top: 20),
                child:                 Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text('Choose Amount',
                    style: TextStyle(fontSize: 15,fontFamily: AppTheme.fontName,),)

                  ],
                )

                ),
                Divider(
                  thickness: 1,
                  color: AppTheme.greyF5,
                ),
                Padding(padding: EdgeInsets.all(20),
                    child:
                    InkWell(
                      onTap: (){
/*
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ChangePassword();
                            },
                          ),
                        );
*/
                      },
                      child:   Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Row(
                              children: <Widget>[
                                Text("USD 10",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
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
                    InkWell(
                      onTap: (){
/*
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ChangePassword();
                            },
                          ),
                        );
*/
                      },
                      child:   Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Row(
                              children: <Widget>[
                                Text("USD 20",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
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
                    InkWell(
                      onTap: (){
/*
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ChangePassword();
                            },
                          ),
                        );
*/
                      },
                      child:   Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Row(
                              children: <Widget>[
                                Text("USD 50",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
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
                    InkWell(
                      onTap: (){
/*
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ChangePassword();
                            },
                          ),
                        );
*/
                      },
                      child:   Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Row(
                              children: <Widget>[
                                Text("USD 100",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
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
                    InkWell(
                      onTap: (){
/*
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ChangePassword();
                            },
                          ),
                        );
*/
                      },
                      child:   Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Row(
                              children: <Widget>[
                                Text("USD 200",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
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
                    InkWell(
                      onTap: (){
/*
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ChangePassword();
                            },
                          ),
                        );
*/
                      },
                      child:   Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Row(
                              children: <Widget>[
                                Text("Enter Amount",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
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

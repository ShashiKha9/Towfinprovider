import 'dart:convert';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';

import 'package:cbx_driver/HomePage/addwalletlist_screen.dart';
import 'package:cbx_driver/Utils/helperutils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_theme.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with TickerProviderStateMixin {
  _WalletScreenState();

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
      appBar:
      AppBar(
        brightness: Brightness.light,
        backgroundColor: AppTheme.white,
        elevation: 0,
        title: Text(
          'Wallet',
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
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  color: AppTheme.white,
                  elevation: 3,
                  child: Container(
                      height: size.height * 0.17,
                      width: size.width * 0.85,
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
                                  prefs.getString(SharedPrefsKeys.CURRENCY) +
                                      " " +
                                      prefs.getString(
                                          SharedPrefsKeys.WALLET_BALANCE),
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
                Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) =>
                                    AddWalletListScreen(),
                              ),
                            );
                          },
                          child: Card(
                            margin: EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            color: AppTheme.white,
                            elevation: 3,
                            child: Container(
                                height: size.height * 0.13,
                                width: size.height * 0.16,
                                decoration: new BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.bottomRight,
                                      end: Alignment.centerLeft,
                                      colors: [AppTheme.white, AppTheme.white]),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.lerp(
                                          Radius.circular(20),
                                          Radius.circular(20),
                                          5),
                                      topLeft: Radius.lerp(Radius.circular(20),
                                          Radius.circular(20), 5),
                                      topRight: Radius.lerp(Radius.circular(20),
                                          Radius.circular(20), 5),
                                      bottomRight: Radius.lerp(
                                          Radius.circular(20),
                                          Radius.circular(20),
                                          5)),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Image.asset(
                                            'assets/images/addwallet.png',
                                            width: 40,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Center(
                                          child: Text(
                                            'Add Amount',
                                            style: TextStyle(
                                                color: AppTheme.nearlyBlack,
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
                          ),
                        ),
                        Card(
                          margin: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          color: AppTheme.white,
                          elevation: 3,
                          child: Container(
                              height: size.height * 0.13,
                              width: size.height * 0.16,
                              decoration: new BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.bottomRight,
                                    end: Alignment.centerLeft,
                                    colors: [AppTheme.white, AppTheme.white]),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.lerp(Radius.circular(20),
                                        Radius.circular(20), 5),
                                    topLeft: Radius.lerp(Radius.circular(20),
                                        Radius.circular(20), 5),
                                    topRight: Radius.lerp(Radius.circular(20),
                                        Radius.circular(20), 5),
                                    bottomRight: Radius.lerp(
                                        Radius.circular(20),
                                        Radius.circular(20),
                                        5)),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Image.asset(
                                          'assets/images/addwallet.png',
                                          width: 40,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                        child: Text(
                                          'Wallet History',
                                          style: TextStyle(
                                              color: AppTheme.nearlyBlack,
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
                        ),
                      ],
                    )),

                SizedBox(height: 20,),
                Text('Payment Methods',style: TextStyle(fontFamily: AppTheme.fontName,fontSize: 16,fontWeight: FontWeight.w400,color: Colors.black),),


                  Card(
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    color: AppTheme.nearlyBlack,
                    elevation: 3,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25.0),

                      onTap: () {
/*
                        Navigator.push<dynamic>(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => AddCard(),
                          ),
                        );*/

                      },
                      child:

                      Container(
                      height: size.height * 0.07,
                      width: size.width * 0.75,
                      decoration: new BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            end: Alignment.centerLeft,
                            colors: [AppTheme.white, AppTheme.white]),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.lerp(
                                Radius.circular(25), Radius.circular(25), 5),
                            topLeft: Radius.lerp(
                                Radius.circular(25), Radius.circular(25), 5),
                            topRight: Radius.lerp(
                                Radius.circular(25), Radius.circular(25), 5),
                            bottomRight: Radius.lerp(
                                Radius.circular(25), Radius.circular(25), 5)),
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(20),
                          child:Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: <Widget>[
                                Text(
                                  "Add Card",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ]),
                              Icon(
                                Icons.add,
                                color: Colors.grey,
                              ),
                            ],
                          ),),
                    ),
                  ),
                )
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

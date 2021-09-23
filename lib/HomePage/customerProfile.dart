import 'dart:convert';

import 'package:cbx_driver/Utils/helperutils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_theme.dart';
import '../main.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key key}) : super(key: key);


  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<UserProfile> {

  _UserProfileState();
  SharedPreferences prefs;

  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    initprefs();
    super.initState();

  }

  Future<void> initprefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var height = MediaQuery
        .of(context)
        .size
        .height;
    var width = MediaQuery
        .of(context)
        .size
        .width;
    Size size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: IconThemeData(
          color: AppTheme.white, //change your color here
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 20,
            color: AppTheme.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppTheme.colorPrimary,
      ),
      body:
      FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return
              Container(child:
              CustomScrollView(
                  slivers: <Widget>[
              SliverList(
              delegate: SliverChildListDelegate(
                  [
                    Padding(padding: EdgeInsets.all(20)
                    ,child:  Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize
                                .max,
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 20,),
                              prefs.getString(SharedPrefsKeys.PICTURE)!= null ?
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    //                   <--- border color
                                    width: 1.0,
                                  ),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(color: AppTheme.grey.withOpacity(0.6),
                                        offset: const Offset(2.0, 4.0),
                                        blurRadius: 8),
                                  ],
                                ),
                                child:
                                ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(60.0),),
                                    child: new FadeInImage.assetNetwork(
                                      placeholder: 'assets/images/userImage.png',
                                      image: prefs.getString(SharedPrefsKeys.PICTURE),
                                      width: width * 0.25,
                                      height: height * 0.12,
                                      fit: BoxFit.cover,
                                    )
                                ),
                              ) :
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    //                   <--- border color
                                    width: 1.0,
                                  ),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(color: AppTheme.grey.withOpacity(0.6),
                                        offset: const Offset(2.0, 4.0),
                                        blurRadius: 8),
                                  ],
                                ),

                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(60.0),),
                                  child: Image.asset(
                                    'assets/images/userImage.png', height: 50,
                                    width: 50,

                                  ),
                                ),
                              ),

                              Padding(padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    prefs.getString(SharedPrefsKeys.FIRST_NAME)+" "+prefs.getString(SharedPrefsKeys.LAST_NAME),

                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight:
                                      FontWeight.w600,
                                      fontFamily:
                                      AppTheme.fontName,
                                      color: AppTheme.nearlyBlack,
                                    ),
                                  )

                              )




                            ],


                          ),


                        ],

                      ),

                    )


          ],
          ),
          ),


          ]

          )
          );


        }
        },
      ),

    );
  }


  @override
  bool get wantKeepAlive => true;
}






import 'package:cbx_driver/LoginSignup/Login/login_screen.dart';
import 'package:cbx_driver/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'T2Extension.dart';
import 'dots_indicator/src/dots_decorator.dart';
import 'dots_indicator/src/dots_indicator.dart';

class T2WalkThrough extends StatefulWidget {
  static var tag = "/T2WalkThrough";

  @override
  T2WalkThroughState createState() => T2WalkThroughState();
}

class T2WalkThroughState extends State<T2WalkThrough> {
  int currentIndexPage = 0;
  int pageLength;



  @override
  void initState() {
    currentIndexPage = 0;
    pageLength = 3;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // changeStatusColor(Colors.transparent);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // StackFit.expand fixes the issue

        children: <Widget>[
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.centerRight,
                    colors: [AppTheme.colorPrimary, AppTheme.colorPrimaryDark])),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child:              PageView(
              children: <Widget>[
                WalkThrough(textContent: "assets/images/setdestination.png",currentIndex:currentIndexPage),
                WalkThrough(textContent: "assets/images/mobile.png",currentIndex:currentIndexPage),
                WalkThrough(textContent: "assets/images/enjoytrip.png",currentIndex:currentIndexPage),
              ],
              onPageChanged: (value) {
                setState(() => currentIndexPage = value);
              },
            ),

          ),

          Positioned(

            bottom: -80,
            left: size.height/8,
            child: Image.asset(
              "assets/images/dotsbg.png",
              width: 200,
              height: 200,
            ),
          ),

        ],
      ),


    );
  }
}

class WalkThrough extends StatelessWidget {
  final String textContent;
  final int currentIndex;
  var titles = [
    "Set Destination",
    "Request Help",
    "Work Done"
  ];

  var subTitles = [
    "Get your nearest booking request from your location.",
    "Detailed problem snip before accepting or rejecting job",
    "You're all set. Great, get your funds transferred to your own waller and request for withdrawal whenever you want."
  ];
  WalkThrough({Key key, @required this.textContent,this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child:    SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(child:               Image.asset(textContent,
                fit: BoxFit.fill,
                width:150.0,

              ),
                  ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 20),
                      Text(titles[currentIndex],
                          style: TextStyle(

                              fontFamily: AppTheme.fontName,
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.white)),
                      SizedBox(height: 10),
                      Center(
                          child: Text(subTitles[currentIndex],
                              style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontSize: 18,
                                  color: AppTheme.white),
                              textAlign: TextAlign.center)),
                      //SizedBox(height: 50),
                    ],
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height*0.10,),

              Visibility(

                  visible: currentIndex==2,
                  child:
                  ElevatedButton(
                child: Padding(
                  padding:
                  EdgeInsets.only(
                      left: 100,
                      right: 100,
                      top: 15,
                      bottom: 15),
                  child: Text(
                      "Get Started",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors
                              .black,
                          fontFamily: AppTheme
                              .fontName)),
                ),
                style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty
                        .all<Color>(
                        Colors.white),
                    backgroundColor:
                    MaterialStateProperty
                        .all<Color>(
                        AppTheme
                            .white),
                    shape: MaterialStateProperty
                        .all<
                        RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius
                                .circular(
                                25),
                            side: BorderSide(
                                color: AppTheme
                                    .white)))),
                onPressed: () async =>
                {

                Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => LoginScreen()),
                )

                },
              )
              ),

              SizedBox(height: MediaQuery.of(context).size.height*0.10,),

              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: Align(
                  alignment: Alignment.center,
                  child: new DotsIndicator(
                    dotsCount: 3,
                    position: currentIndex,
                    decorator: DotsDecorator(
                        color: Color(0xFFFFFFFF).withOpacity(0.3), activeColor: Color(0xFFFFFFFF).withOpacity(1)),
                  ),
                ),
              ),

            ],
          )),

    );
  }
}

import 'package:cbx_driver/LoginSignup/Login/login_screen.dart';
import 'package:cbx_driver/components/already_have_an_account_acheck.dart';
import 'package:cbx_driver/components/rounded_button.dart';
import 'package:cbx_driver/components/rounded_input_field.dart';
import 'package:cbx_driver/components/rounded_password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app_theme.dart';
import 'background.dart';
import 'or_divider.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return
      SingleChildScrollView(
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
                  padding: EdgeInsets.only(left: 55, right: 5,top: 30),
                  child: TextField(
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
                  padding: EdgeInsets.only(left: 5, right: 55,top:30),
                  child: TextField(
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
            padding: EdgeInsets.only(left: 55, right: 55,top:20),
            child: TextField(
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
              padding: EdgeInsets.only(left: 55, right: 55,top:20),
              child: Column(
                children: [
                  TextField(
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
          ElevatedButton(
              child: Padding(
                padding:
                    EdgeInsets.only(left: 110, right: 110, top: 15, bottom: 15),
                child: Text("Sign Up", style: TextStyle(fontSize: 14)),
              ),
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppTheme.colorPrimary),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: BorderSide(color: AppTheme.colorPrimary)))),
              onPressed: () => null),
          SizedBox(height: size.height * 0.03),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Body();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}



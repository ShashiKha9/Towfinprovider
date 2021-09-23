import 'package:cbx_driver/LoginSignup/Signup/components/social_icon.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function press;

  const AlreadyHaveAnAccountCheck({
    Key key,
    this.login = true,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              login ? "Don’t have an Account ? " : "Already have an Account ? ",
              style: TextStyle(color: Colors.black),
            ),
            GestureDetector(
              onTap: press,
              child: Text(
                login ? "Sign Up" : "Sign In",
                style: TextStyle(
                  color: AppTheme.colorPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "or",
          style: TextStyle(
              color: Color(0xFFBDBDBD),
              fontSize: 15,
              fontFamily: AppTheme.fontName,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Continue With",
          style: TextStyle(
              color: Color(0xFF616161),
              fontSize: 15,
              fontFamily: AppTheme.fontName,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SocalIcon(
              iconSrc: "assets/images/facebook.png",
              press: () {},
            ),

            SocalIcon(
              iconSrc: "assets/images/google.png",
              press: () {},
            ),
          ],
        )
      ],
    );
  }
}

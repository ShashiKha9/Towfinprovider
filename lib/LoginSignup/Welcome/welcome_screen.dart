import 'package:cbx_driver/Utils/helperutils.dart';
import 'package:cbx_driver/navigation_home_screen.dart';
import 'package:cbx_driver/walkthrough/T2Walkthrough.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/body.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }


  @override
  void initState() {
    super.initState();

    initPrefs();

  }

  Future<void> initPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    new Future.delayed(const Duration(seconds: 3), () {

      if(prefs.getBool(SharedPrefsKeys.LOGEDIN)!=null){
        if(prefs.getBool(SharedPrefsKeys.LOGEDIN)){

          Navigator.pushReplacement(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) =>
                  NavigationHomeScreen(),
            ),
          );
        }else{
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) =>
                  T2WalkThrough(),
            ),
          );
        }
      }else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) =>
                T2WalkThrough(),
          ),
        );
      }



    });


  }

}

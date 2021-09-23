import 'package:cbx_driver/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'background.dart';

class Body extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
      child: SingleChildScrollView(
        child: Center(
            child: Container(
              height: size.height,

            child:         Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(

                    child:
                    Image.asset("assets/images/cbxlogo.png",
                      fit: BoxFit.contain,
                      height: 100,
                      width: 300,
                      alignment: Alignment.center,

                    )
                ),
                SizedBox(height: size.height * 0.05),
                /*SvgPicture.asset(
              "assets/icons/chat.svg",
              height: size.height * 0.45,
            ),*/

                SizedBox(height: size.height * 0.05),
              ],
            ),

            )

        )

      ),
    );
  }

}



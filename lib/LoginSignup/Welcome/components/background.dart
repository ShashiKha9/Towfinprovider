import 'package:cbx_driver/app_theme.dart';
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return
      Container(
      height: size.height,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.centerRight,
              colors: [AppTheme.colorPrimary, AppTheme.colorPrimaryDark])),

      child: Stack(

        alignment: Alignment.center,
        children: <Widget>[


          Positioned(

            bottom: -80,
            left: size.height/8,
            child: Image.asset(
              "assets/images/dotsbg.png",
              width: 200,
              height: 200,
            ),
          ),

          child,
        ],
      ),
    );
  }
}

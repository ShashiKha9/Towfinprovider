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
      width: double.infinity,
      height: size.height,
      child: Stack(

        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Stack(
                  children: [
                    Container(
                      height: size.height*0.33,
                      width: size.width,

                      decoration: new BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              end: Alignment.centerLeft,
                              colors: [AppTheme.colorPrimary, AppTheme.colorPrimaryDark])
                          ,borderRadius: BorderRadius.only(
                            bottomLeft: Radius.lerp(Radius.circular(50),Radius.circular(60),5),
                            bottomRight: Radius.lerp(Radius.circular(50),Radius.circular(50),5)

                        ),
                      ),
                      child:
                          Stack(
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
                                    child: Text('Welcome Back!',style: TextStyle(color: AppTheme.white,fontFamily: AppTheme.fontName,fontWeight:FontWeight.w800,fontSize: 35),),

                                  ),
                                  Center(
                                    child: Text('Let\'s get you a ride!',style: TextStyle(color: AppTheme.white,fontFamily: AppTheme.fontName,fontWeight:FontWeight.w400,fontSize: 18),),

                                  )


                                ],
                              )


                            ],
                          )

                    ),
                  ],
                )

          ),
          child,
        ],
      ),
    );
  }
}

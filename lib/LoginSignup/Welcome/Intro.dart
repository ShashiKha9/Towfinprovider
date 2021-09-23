import 'package:cbx_driver/LoginSignup/Login/login_screen.dart';
import 'package:cbx_driver/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';


class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardingPage(),
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }




  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('$assetName', width: 250.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 16.0,color: AppTheme.white,fontFamily: AppTheme.fontName);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w600,color: AppTheme.white,fontFamily: AppTheme.fontName),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: AppTheme.colorPrimaryDark,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Set Destination",
          body: "Get your nearest booking request from your location.",
          image: _buildImage('assets/images/setdestination.png'),
          decoration: pageDecoration,

        ),
        PageViewModel(
          title: "Request help",
          body:
          "Detailed problem snip before accepting or rejecting job.",
          image: _buildImage('assets/images/mobile.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Work Done",
          body:
          "You're all set. Great, get your funds transferred to your own waller and request for withdrawal whenever you want.",
          image: _buildImage('assets/images/enjoytrip.png'),
          decoration: pageDecoration,
        ),

      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip',style: TextStyle(color:AppTheme.white,fontWeight: FontWeight.w400)),
      next: const Icon(Icons.keyboard_arrow_right,color: AppTheme.white, size: 50,),
      done: const Text('Get Started', style: TextStyle(color:AppTheme.white,fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
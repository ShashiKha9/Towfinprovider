import 'package:cbx_driver/HomePage/customerProfile.dart';
import 'package:cbx_driver/HomePage/edit_account.dart';
import 'package:cbx_driver/LoginSignup/Welcome/welcome_screen.dart';
import 'package:cbx_driver/Utils/helperutils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_theme.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key key, this.screenIndex, this.iconAnimationController, this.callBackIndex}) : super(key: key);

  final AnimationController iconAnimationController;
  final DrawerIndex screenIndex;
  final Function(DrawerIndex) callBackIndex;


  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<DrawerList> drawerList;
  SharedPreferences prefs;
  @override
  void initState() {
    setDrawerListArray();
    super.initState();
    initprefs();
  }

  Future<void> initprefs() async {
     prefs = await SharedPreferences.getInstance();
  }

  void setDrawerListArray() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.HOME,
        labelName: 'Home',
        icon: Icon(Icons.home),
      ),
      /*DrawerList(
        index: DrawerIndex.Payment,
        labelName: 'Payment',
        icon: Icon(CupertinoIcons.creditcard),
      ),*/
      DrawerList(
        index: DrawerIndex.YourServices,
        labelName: 'Your Services',
        icon: Icon(Icons.select_all_rounded),
      ),
      DrawerList(
        index: DrawerIndex.Wallet,
        labelName: 'Wallet',
        icon: Icon(Icons.account_balance_wallet_outlined),
      ),
      DrawerList(
        index: DrawerIndex.Earning,
        labelName: 'Earning',
        icon: Icon(CupertinoIcons.money_dollar),
      ),
      DrawerList(
        index: DrawerIndex.Summary,
        labelName: 'Summary',
        icon: Icon(CupertinoIcons.rectangle_on_rectangle),
      ),
      DrawerList(
        index: DrawerIndex.Settings,
        labelName: 'Settings',
        icon: Icon(CupertinoIcons.settings),
      ),
      DrawerList(
        index: DrawerIndex.Help,
        labelName: 'Help',
        icon: Icon(CupertinoIcons.info),
      ),
      DrawerList(
        index: DrawerIndex.Refer,
        labelName: 'Refer',
        icon: Icon(CupertinoIcons.share),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.notWhite.withOpacity(0.5),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topRight,
                colors: [AppTheme.colorPrimaryDark, AppTheme.colorPrimary])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 40.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child:
                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return EditAccount();
                        },
                      ),
                    );
                  },
                  child:
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      AnimatedBuilder(
                        animation: widget.iconAnimationController,
                        builder: (BuildContext context, Widget child) {
                          return ScaleTransition(
                            scale: AlwaysStoppedAnimation<double>(1.0 - (widget.iconAnimationController.value) * 0.2),
                            child: RotationTransition(
                              turns: AlwaysStoppedAnimation<double>(Tween<double>(begin: 0.0, end: 24.0)
                                  .animate(CurvedAnimation(parent: widget.iconAnimationController, curve: Curves.fastOutSlowIn))
                                  .value /
                                  360),
                              child: prefs.getString(SharedPrefsKeys.PICTURE)!=null?
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(color: AppTheme.grey.withOpacity(0.6), offset: const Offset(2.0, 4.0), blurRadius: 8),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(60.0)),

                                  child: FadeInImage.assetNetwork(
                                    image: prefs.getString(SharedPrefsKeys.PICTURE), placeholder: 'assets/images/userImage.png', height: 50,width: 50,

                                  ),
                                ),
                              ):
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(color: AppTheme.grey.withOpacity(0.6), offset: const Offset(2.0, 4.0), blurRadius: 8),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(60.0)),

                                  child: Image.asset('assets/images/userImage.png', height: 50,width: 50,

                                  ),
                                ),
                              )
                            ),
                          );
                        },
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 10),
                            child: Text(
                              prefs!=null?prefs.getString(SharedPrefsKeys.FIRST_NAME)+" "+prefs.getString(SharedPrefsKeys.LAST_NAME):'',

                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2, left: 10),
                            child: Text(
                                prefs.getString(SharedPrefsKeys.EMAIL_ADDRESS)!=null?prefs.getString(SharedPrefsKeys.EMAIL_ADDRESS):"",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: AppTheme.white,
                                fontSize: 12,
                              ),
                            ),
                          ),

                        ],
                      )
                    ],
                  )
                ),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Divider(
              height: 1,
              color: AppTheme.white.withOpacity(0.3),
            ),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(0.0),
                itemCount: drawerList.length,
                itemBuilder: (BuildContext context, int index) {
                  return inkwell(drawerList[index]);
                },
              ),
            ),
            Divider(
              height: 1,
              color: AppTheme.grey.withOpacity(0.6),
            ),
            Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Sign Out',
                    style: TextStyle(
                      fontFamily: AppTheme.fontName,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppTheme.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  trailing: Icon(
                    Icons.power_settings_new,
                    color: Colors.white,
                  ),
                  onTap: () {
                    
                  _logoutDialog();
                    
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                )
              ],
            ),
          ],
        ),


      )
    );
  }
  Future<void> _logoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('Yes'),
              onPressed: () async {
                Navigator.of(context).pop();

                SharedPreferences prefs = await SharedPreferences.getInstance();

                prefs.remove(SharedPrefsKeys.USER_ID);
                prefs.remove(SharedPrefsKeys.LAST_NAME);
                prefs.remove(SharedPrefsKeys.FIRST_NAME);
                prefs.remove(SharedPrefsKeys.EMAIL_ADDRESS);
                prefs.remove(SharedPrefsKeys.ACCESS_TOKEN);
                prefs.remove(SharedPrefsKeys.TOKEN_TYPE);
                prefs.remove(SharedPrefsKeys.LOGEDIN);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return WelcomeScreen();
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }


  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                    // decoration: BoxDecoration(
                    //   color: widget.screenIndex == listData.index
                    //       ? Colors.blue
                    //       : Colors.transparent,
                    //   borderRadius: new BorderRadius.only(
                    //     topLeft: Radius.circular(0),
                    //     topRight: Radius.circular(16),
                    //     bottomLeft: Radius.circular(0),
                    //     bottomRight: Radius.circular(16),
                    //   ),
                    // ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                          width: 24,
                          height: 24,
                          child: Image.asset(listData.imageName, color: widget.screenIndex == listData.index ? Colors.white : AppTheme.white),
                        )
                      : Icon(listData.icon.icon, color: widget.screenIndex == listData.index ? Colors.white : AppTheme.white),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index ? Colors.white : AppTheme.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                            (MediaQuery.of(context).size.width * 0.75 - 64) * (1.0 - widget.iconAnimationController.value - 1.0), 0.0, 0.0),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.75 - 64,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex(indexScreen);
  }
}

enum DrawerIndex {
  HOME,
  // Payment,
  YourServices,
  Wallet,
  Earning,
  Summary,
  Settings,
  Help,
  Refer,
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });

  String labelName;
  Icon icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex index;
}

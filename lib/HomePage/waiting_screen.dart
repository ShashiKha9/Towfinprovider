import 'package:cbx_driver/HomePage/location_type_screen.dart';
import 'package:cbx_driver/HomePage/tyrecarselect_screen.dart';
import 'package:cbx_driver/LoginSignup/Welcome/welcome_screen.dart';
import 'package:cbx_driver/Modals/AllServicesModel.dart';
import 'package:cbx_driver/Modals/AllSubServicesModel.dart';
import 'package:cbx_driver/Modals/categorieslist.dart';
import 'package:cbx_driver/Modals/services_response.dart';
import 'package:cbx_driver/Modals/sub_services_response.dart';
import 'package:cbx_driver/Utils/helperutils.dart';
import 'package:cbx_driver/bloc/LoginBloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_theme.dart';

class WaitingScreen extends StatefulWidget {
  WaitingScreen({Key key, this.serviceName, this.serviceId, this.subServiceId,this.serviceImg})
      : super(key: key);

  final serviceName;
  final serviceId;
  final subServiceId;
  final serviceImg;

  @override
  _WaitingScreenState createState() =>
      _WaitingScreenState(this.serviceName, this.serviceId, this.subServiceId,this.serviceImg);
}

class _WaitingScreenState extends State<WaitingScreen> with TickerProviderStateMixin {
  _WaitingScreenState(this.serviceName, this.serviceId, this.subServiceId,this.serviceImg);

  AnimationController animationController;
  bool multiple = true;

  String serviceId;
  String subServiceId;
  String serviceImg;
  String serviceName;
  bool _isTowService = false;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();

    initPreferences();
  }

  Future<void> initPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // bloc.fetchAllSubServicesReq(context,prefs.getString(SharedPrefsKeys.ACCESS_TOKEN),prefs.getString(SharedPrefsKeys.TOKEN_TYPE),serviceId);
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
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: AppTheme.white,
        body:Stack(
          children: [
            Container(
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.centerRight,
                      colors: [AppTheme.colorPrimary, AppTheme.colorPrimaryDark])),

              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text("Waiting for Approval",style: TextStyle(fontSize: 25,fontFamily: AppTheme.fontName,color: AppTheme.white,fontWeight: FontWeight.w800),textAlign: TextAlign.center,),
                  Padding(padding: EdgeInsets.only(left:20,right: 20,top:5),
                      child:               Text("Your account is not approved by admin please wait for approval",style: TextStyle(fontSize: 15,fontFamily: AppTheme.fontName,color: AppTheme.white,fontWeight: FontWeight.w400),textAlign: TextAlign.center,)
                  )

                ],

              ),
            ),

            SafeArea(

                child: Align(
                  alignment: Alignment.bottomCenter,
                child:
                new Container(
                    margin: const EdgeInsets.only(bottom: 15.0),
                child:ElevatedButton(

                  child: Padding(
                    padding:
                    EdgeInsets.only(
                        left: 100,
                        right: 100,
                        top: 15,
                        bottom: 15),
                    child: Text(
                        "Logout",
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

                    _logoutDialog()
                  },
                )

                )
                )
            )


          ],
        )

            );
  }

  Widget appBar() {
    return SizedBox(
      height: AppBar().preferredSize.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Container(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'CBD',
                  style: TextStyle(
                    fontSize: 22,
                    color: AppTheme.darkText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 8),
            child: Container(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
              color: Colors.white,
/*
              child: Material(
                color: Colors.transparent,
                child:
                InkWell(
                  borderRadius:
                      BorderRadius.circular(AppBar().preferredSize.height),
                  child:
                  Icon(
                    multiple ? Icons.dashboard : Icons.view_agenda,
                    color: AppTheme.dark_grey,
                  ),
                  onTap: () {
                    setState(() {
                      multiple = !multiple;
                    });
                  },
                ),
              ),
*/
            ),
          ),
        ],
      ),
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
}

class RadioGroup extends StatefulWidget {
  const RadioGroup({
    Key key,
    this.onRadioSelect,
  }) : super(key: key);
  final RadioGroupValueCallback onRadioSelect;

  @override
  RadioGroupWidget createState() => RadioGroupWidget(this.onRadioSelect);
}

typedef RadioGroupValueCallback = void Function(String color);

class FruitsList {
  String name;
  int index;

  FruitsList({this.name, this.index});
}

class RadioGroupWidget extends State {
  // Default Radio Button Item
  String radioItem = 'Mango';

  RadioGroupWidget(this.callback);

  RadioGroupValueCallback callback;

  // Group Value for Radio Button.
  int id = 1;

  List<FruitsList> fList = [
    FruitsList(
      index: 1,
      name: "Yes",
    ),
    FruitsList(
      index: 2,
      name: "No",
    ),
  ];

  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        /* Padding(
            padding : EdgeInsets.all(14.0),
            child: Text('$radioItem', style: TextStyle(fontSize: 23))
        ),*/

        Expanded(
            child: Container(
          child: Column(
            children: fList
                .map((data) => RadioListTile(
                      title: Text("${data.name}"),
                      groupValue: id,
                      value: data.index,
                      onChanged: (val) {
                        setState(() {
                          radioItem = data.name;
                          id = data.index;
                        });

                        print(id.toString());
                        callback(id.toString());
                      },
                    ))
                .toList(),
          ),
        )),
      ],
    );
  }
}

class RadioGroupOil extends StatefulWidget {
  const RadioGroupOil({
    Key key,
    this.onRadioSelect,
  }) : super(key: key);
  final RadioGroupOilValueCallback onRadioSelect;

  @override
  RadioGroupWidget createState() => RadioGroupWidget(this.onRadioSelect);
}

typedef RadioGroupOilValueCallback = void Function(String color);

class OilOptnList {
  String name;
  int index;

  OilOptnList({this.name, this.index});
}

class RadioGroupOilWidget extends State {
  // Default Radio Button Item
  String radioItem = 'Mango';

  RadioGroupOilWidget(this.callback);

  RadioGroupOilValueCallback callback;

  // Group Value for Radio Button.
  int id = 1;

  List<OilOptnList> fOilList = [
    OilOptnList(
      index: 1,
      name: "Less than 1 Ltr.",
    ),
    OilOptnList(
      index: 2,
      name: "More than 1 Ltr.",
    ),
  ];

  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        /* Padding(
            padding : EdgeInsets.all(14.0),
            child: Text('$radioItem', style: TextStyle(fontSize: 23))
        ),*/

        Expanded(
            child: Container(
          child: Column(
            children: fOilList
                .map((data) => RadioListTile(
                      title: Text("${data.name}"),
                      groupValue: id,
                      value: data.index,
                      onChanged: (val) {
                        setState(() {
                          radioItem = data.name;
                          id = data.index;
                        });

                        print(id.toString());
                        callback(id.toString());
                      },
                    ))
                .toList(),
          ),
        )),
      ],
    );
  }
}

class RadioGroupMobileOil extends StatefulWidget {
  const RadioGroupMobileOil({
    Key key,
    this.onRadioSelect,
  }) : super(key: key);
  final RadioGroupMobileOilValueCallback onRadioSelect;

  @override
  RadioGroupWidget createState() => RadioGroupWidget(this.onRadioSelect);
}

typedef RadioGroupMobileOilValueCallback = void Function(String color);

class MobileOilOptnList {
  String name;
  int index;

  MobileOilOptnList({this.name, this.index});
}

class RadioGroupMobileOilWidget extends State {
  // Default Radio Button Item
  String radioItem = 'Mango';

  RadioGroupMobileOilWidget(this.callback);

  RadioGroupMobileOilValueCallback callback;

  // Group Value for Radio Button.
  int id = 1;

  List<MobileOilOptnList> fList = [
    MobileOilOptnList(
      index: 1,
      name: "Yes",
    ),
    MobileOilOptnList(
      index: 2,
      name: "No",
    ),
  ];

  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        /* Padding(
            padding : EdgeInsets.all(14.0),
            child: Text('$radioItem', style: TextStyle(fontSize: 23))
        ),*/

        Expanded(
            child: Container(
          height: 350.0,
          child: Column(
            children: fList
                .map((data) => RadioListTile(
                      title: Text("${data.name}"),
                      groupValue: id,
                      value: data.index,
                      onChanged: (val) {
                        setState(() {
                          radioItem = data.name;
                          id = data.index;
                        });

                        print(id.toString());
                        callback(id.toString());
                      },
                    ))
                .toList(),
          ),
        )),
      ],
    );
  }
}

class NoDataFound extends StatelessWidget {
  const NoDataFound({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          height: 100,
          width: size.width,
          child: Padding(
              padding: EdgeInsets.all(5),
              child: Icon(
                Icons.not_interested_outlined,
                color: AppTheme.colorPrimary,
                size: 80,
              )),
        ),
        Text("Services Not Found",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                color: AppTheme.nearlyBlack,
                fontWeight: FontWeight.w500,
                fontFamily: AppTheme.fontName)),
      ],
    );
  }
}

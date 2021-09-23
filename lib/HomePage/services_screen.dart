import 'dart:convert';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:cbx_driver/Modals/AllPastTripList.dart';
import 'package:cbx_driver/Modals/past_trip_list_repo.dart';
import 'package:cbx_driver/Utils/helperutils.dart';
import 'package:cbx_driver/bloc/PastTripHistoryBloc.dart';
import 'package:cbx_driver/components/rounded_button.dart';
import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_theme.dart';
import '../main.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key key}) : super(key: key);

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen>
    with TickerProviderStateMixin {
  _ServicesScreenState();

  AnimationController animationController;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileNumController = TextEditingController();
  final _emailaddressController = TextEditingController();
  SharedPreferences prefs;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();

    initPreferences();

    _mobileNumController.addListener(_printLatestValue);
  }

  Future<void> initPreferences() async {
    prefs = await SharedPreferences.getInstance();
    /*_firstNameController.text = prefs.getString(SharedPrefsKeys.FIRST_NAME);
    _lastNameController.text = prefs.getString(SharedPrefsKeys.LAST_NAME);
    _mobileNumController.text = prefs.getString(SharedPrefsKeys.MOBILE);
    _emailaddressController.text =
        prefs.getString(SharedPrefsKeys.EMAIL_ADDRESS);*/

    bloc.pastHistoryReq(context, prefs.getString(SharedPrefsKeys.ACCESS_TOKEN),
        prefs.getString(SharedPrefsKeys.TOKEN_TYPE));
    setState(() {});
  }

  _printLatestValue() {
    print("Second text field: ${_mobileNumController.text}");

    // });
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  @override
  void dispose() {
    _mobileNumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        // shape: Border(
        //     bottom: BorderSide(color: AppTheme.colorPrimary, width: 2)),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Your Services',
          style: TextStyle(
            fontSize: 22,
            color: AppTheme.darkText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body:
      StreamBuilder<PastTripListRespo>(
          stream: bloc.subjectPastHistory.stream,
          builder: (context, snap) {
            return snap.data != null
                ? snap.data.allPastTripList.length > 0
                ? FutureBuilder<bool>(
              future: getData(),
              builder: (BuildContext context,
                  AsyncSnapshot<bool> snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                } else {
                  return Padding(
                    padding: EdgeInsets.only(
                        top:
                        MediaQuery.of(context).padding.top),
                    child: FutureBuilder<bool>(
                      future: getData(),
                      builder: (BuildContext context,
                          AsyncSnapshot<bool> snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox();
                        } else {
                          return ListView.builder(
                              reverse: false,
                              itemCount: snap.data != null
                                  ? snap.data.allPastTripList
                                  .length
                                  : 0,
                              itemBuilder: (context, index) {
                                final item = snap.data
                                    .allPastTripList[index];
                                final int count = snap.data
                                    .allPastTripList.length;

                                final Animation<double>
                                animation = Tween<double>(
                                    begin: 0.0,
                                    end: 1.0)
                                    .animate(
                                  CurvedAnimation(
                                    parent: animationController,
                                    curve: Interval(
                                        (1 / count) * index,
                                        1.0,
                                        curve: Curves
                                            .fastOutSlowIn),
                                  ),
                                );

                                return HomeListView(
                                  animation: animation,
                                  index: index,
                                  animationController:
                                  animationController,
                                  categoriesListData: snap.data
                                      .allPastTripList[index],
                                  callBack: () {
                                    /*  Navigator.push<dynamic>(
                                                context,
                                                MaterialPageRoute<dynamic>(
                                                  builder: (BuildContext context) =>
                                                      SubServicePage(
                                                        serviceName: snap.data.allServicesList[index].name,
                                                        serviceImg: snap.data.allServicesList[index].image,
                                                        serviceId: snap.data.allServicesList[index].id.toString(),

                                                      ),
                                                ),
                                              );*/
                                  },
                                );
                              });
                        }
                      },
                    ),
                  );
                }
              },
            )
                : NoDataFound()
                : Text('');
          }),

    )
    ;
  }

  void _showMyDialog(
    BuildContext context,
    String msg,
    String header,
  ) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(header),
            content: Padding(
              padding: EdgeInsets.all(10),
              child: Text(msg),
            ),
            actions: <Widget>[
              /*CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text("Cancel")
          ),*/
              CupertinoDialogAction(
                  textStyle: TextStyle(
                      color: Colors.red, fontFamily: AppTheme.fontName),
                  isDefaultAction: true,
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Okay",
                    style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        color: AppTheme.colorPrimaryDark),
                  )),
            ],
          );
        });
  }
}

class HomeListView extends StatelessWidget {
  const HomeListView(
      {Key key,
      this.categoriesListData,
      this.index,
      this.callBack,
      this.animationController,
      this.animation})
      : super(key: key);

  final AllPastTripList categoriesListData;
  final VoidCallback callBack;
  final index;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(categoriesListData.assigned_at);

    var outputFormat = DateFormat('MMM, dd yyyy hh:mm a');
    var outputDate = outputFormat.format(tempDate);

    print(outputDate+" ==DATE");

    return Container(
        color: (index % 2 == 0) ? Colors.white : AppTheme.greyF5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
                padding:
                    EdgeInsets.only(left: 25, right: 25, bottom: 5, top: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(outputDate,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            color: AppTheme.nearlyBlack,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppTheme.fontName)),
                    Text("\$" + categoriesListData.payment.total,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            color: AppTheme.textColor,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppTheme.fontName)),
                  ],
                )),
            Padding(
                padding:
                    EdgeInsets.only(left: 25, right: 25, bottom: 5, top: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/location.png",
                      color: AppTheme.colorPrimaryDark,
                      width: 15,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Text(categoriesListData.s_address,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
                          style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.grey61,
                              fontWeight: FontWeight.w400,
                              fontFamily: AppTheme.fontName)),
                    )
                  ],
                )),
            Padding(
                padding:
                    EdgeInsets.only(left: 25, right: 25, bottom: 5, top: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/locationfilled.png",
                      color: AppTheme.colorPrimaryDark,
                      width: 15,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Text(categoriesListData.d_address,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
                          style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.grey61,
                              fontWeight: FontWeight.w400,
                              fontFamily: AppTheme.fontName)),
                    )
                  ],
                )),
            Padding(
                padding:
                    EdgeInsets.only(left: 25, right: 25, bottom: 5, top: 5),
                child: Divider(
                  height: 5,
                  color: AppTheme.grey61,
                )),
            Padding(
                padding:
                    EdgeInsets.only(left: 25, right: 25, bottom: 5, top: 0),
                child: ExpandablePanel(
                  theme: ExpandableThemeData(iconColor: AppTheme.grey61),
                  header: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        "Details",
                        style: TextStyle(
                            fontFamily: AppTheme.fontName, fontSize: 12),
                        textAlign: TextAlign.start,
                      )),
                  expanded: Padding(
                    padding: EdgeInsets.only(top: 2, bottom: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: size.width,
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 15, top: 15, bottom: 15),
                                      child: Text(
                                        'Booking Id: ${categoriesListData.booking_id}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: AppTheme.fontName,
                                          color: AppTheme.grey61,
                                        ),
                                      )),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 15, top: 5, bottom: 15),
                                          child: Text(
                                            'Base Fare',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: AppTheme.fontName,
                                              color: AppTheme.grey61,
                                            ),
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              right: 15, top: 5, bottom: 15),
                                          child: Text(
                                            categoriesListData.payment.fixed.toString()!=null?'\$'+categoriesListData.payment.fixed:'',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: AppTheme.fontName,
                                              color: AppTheme.nearlyBlack,
                                            ),
                                          )),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 15, top: 5, bottom: 15),
                                          child: Text(
                                            'Distance Fare',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: AppTheme.fontName,
                                              color: AppTheme.grey61,
                                            ),
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              right: 15, top: 5, bottom: 15),
                                          child: Text(
                                            '\$'+categoriesListData.payment.distance,/*categoriesListData.payment.distance*/
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: AppTheme.fontName,
                                              color: AppTheme.nearlyBlack,
                                            ),
                                          )),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 15, top: 5, bottom: 15),
                                          child: Text(
                                            'Extra Service Charege',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: AppTheme.fontName,
                                              color: AppTheme.grey61,
                                            ),
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              right: 15, top: 5, bottom: 15),
                                          child: Text(
                                            '\$${categoriesListData.payment.tax}',/*${categoriesListData.payment.tax}*/
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: AppTheme.fontName,
                                              color: AppTheme.nearlyBlack,
                                            ),
                                          )),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 15, top: 5, bottom: 15),
                                          child: Text(
                                            'Total',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: AppTheme.fontName,
                                              color: AppTheme.grey61,
                                            ),
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              right: 15, top: 5, bottom: 15),
                                          child: Text(
                                            '\$${categoriesListData.payment.total}',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: AppTheme.fontName,
                                              color: AppTheme.nearlyBlack,
                                            ),
                                          )),
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.white24,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 15, top: 5, bottom: 15),
                                          child: Text(
                                            'Amount you paid',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: AppTheme.fontName,
                                              color: AppTheme.grey61,
                                            ),
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              right: 15, top: 5, bottom: 15),
                                          child: Text(
                                            '\$${categoriesListData.payment.payable}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: AppTheme.fontName,
                                              color: AppTheme.nearlyBlack,
                                            ),
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            )),

                          new FadeInImage.assetNetwork(
                          placeholder: 'assets/images/userImage.png',
                          image: categoriesListData.static_map,
                          width: size.width * 15,
                          height: size.height * 0.15,
                          fit: BoxFit.contain,
                          )


                      ],
                    ),
                  ),
                  collapsed: null,
                )),
          ],
        ));
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

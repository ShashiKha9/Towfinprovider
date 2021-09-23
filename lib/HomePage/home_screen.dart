import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cbx_driver/Api/BaseApi.dart';
import 'package:cbx_driver/HomePage/subscervice_screen.dart';
import 'package:cbx_driver/HomePage/waiting_screen.dart';
import 'package:cbx_driver/Modals/AllServicesModel.dart';
import 'package:cbx_driver/Modals/CheckStatusModel.dart';
import 'package:cbx_driver/Modals/UpdateDriverStatus.dart';
import 'package:cbx_driver/Modals/categorieslist.dart';
import 'package:cbx_driver/Modals/services_response.dart';
import 'package:cbx_driver/Utils/CommanStrings.dart';
import 'package:cbx_driver/Utils/CommonLogic.dart';
import 'package:cbx_driver/Utils/helperutils.dart';
import 'package:cbx_driver/bloc/driverstatusupdateBloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_theme.dart';
import 'map_locationpicker.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  List<CategoriesList> categoriesList = CategoriesList.categoriesList;
  AnimationController animationController;
  bool multiple = true;
  Timer timer;
  AudioCache _audioCache = null;

  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  GoogleMapController mapController;
  Position _currentPosition;
  var on_off_Status = "OFFLINE";
  SharedPreferences prefs;
  CountdownTimerController controller;
  var showmaterialModel = null;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _ratingformKey = GlobalKey<FormState>();
  var isAudioPlayed = false;
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _tripCommentController = TextEditingController();
  User user;
  Request request;
  List<Requests> requests = List();
  String request_id = "";
  AudioPlayer audioPlayer = AudioPlayer(playerId: Random().nextInt(100000).toString(),mode: PlayerMode.LOW_LATENCY);

  static AudioCache player;


  int endTime = 0;

  int _tripRating = 1;

  var locationType = "";
  var vechileNo = "";
  var vinNumber = "";
  var modalYear = "";
  var subServiceName = "";

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 5000), vsync: this);
    super.initState();
    timer =
        Timer.periodic(Duration(seconds: 2), (Timer t) => checkStatus(context));

    // _getCurrentLocation();
    initPreferences();


      player = new AudioCache(prefix: "assets/images/", fixedPlayer: audioPlayer);


    // player.play('images/alert_tone.mp3');

// _determinePosition();
  }

  void onEnd() {
    print('onEnd');
  }

  playLocal() async {
    int result = await audioPlayer.play("assets/images/alert_tone.mp3", isLocal: true);
  }

  @override
  void dispose() {
    if (controller != null)
      controller.dispose();
    animationController.dispose();
    timer?.cancel();

    super.dispose();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  // Method for retrieving the current location
  _getCurrentLocation() async {
    var permission = await Geolocator.checkPermission();

    permission = await Geolocator.requestPermission();
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium)
        .then((Position position) async {
      print("LOCATION");
      // if (mounted) {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');

        if (mapController != null) {
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 18.0,
              ),
            ),
          );
        };
      });
      // }
      // await _getAddress();

      //   timer = Timer.periodic(
      //       Duration(seconds: 2), (Timer t) => bloc.reqCheckAPI(_scaffoldKey.currentContext, "", ""));
      // }).catchError((e) {
      //   print(e);
    });
  }

  Future<void> initPreferences() async {
    prefs = await SharedPreferences.getInstance();
    // bloc.fetchAllServicesReq(context,prefs.getString(SharedPrefsKeys.ACCESS_TOKEN),prefs.getString(SharedPrefsKeys.TOKEN_TYPE));
    // if (response.optString("account_status").equals("new") || response.optString("account_status").equals("onboarding")) {

    print(prefs.getString(SharedPrefsKeys.STATUS).toString() + " STATUS");

    if (prefs.getString(SharedPrefsKeys.STATUS) == 'new' ||
        prefs.getString(SharedPrefsKeys.STATUS) == 'onboarding') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return WaitingScreen();
          },
        ),
      );
    } else if (prefs.getString(SharedPrefsKeys.STATUS) == 'offline') {
      setState(() {
        on_off_Status = "OFFLINE";
      });
    } else {
      on_off_Status = "ONLINE";
    }
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      /*   appBar: AppBar(brightness: Brightness.light, backgroundColor: AppTheme.chipBackground,elevation: 0,

      title: Text(
        'CBX',
        style: TextStyle(
          fontSize: 22,
          color: AppTheme.darkText,
          fontWeight: FontWeight.w700,
        ),
      ),

      ),*/

      // backgroundColor: AppTheme.chipBackground,
      body: Stack(
        children: [
          GoogleMap(
/*
            markers: markers != null ? Set<Marker>.from(markers) : null,
*/
            gestureRecognizers: Set()
              ..add(Factory<PanGestureRecognizer>(() =>
                  PanGestureRecognizer()))..add(
                  Factory<VerticalDragGestureRecognizer>(
                          () => VerticalDragGestureRecognizer())),
            initialCameraPosition: _initialLocation,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
/*
            polylines: Set<Polyline>.of(polylines.values),
*/
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              mapController.setMapStyle(Utils.mapStyles);
              _getCurrentLocation();
            },
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                child: ClipOval(
                    child: Material(
                      color: AppTheme.colorPrimary, // button color
                      child: InkWell(
                        splashColor: AppTheme.colorPrimary, // inkwell color
                        child: SizedBox(
                          width: 36,
                          height: 36,
                          child: Icon(
                            Icons.my_location,
                            color: AppTheme.white,
                          ),
                        ),
                        onTap: () {
                          mapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(
                                  _currentPosition.latitude,
                                  _currentPosition.longitude,
                                ),
                                zoom: 18.0,
                              ),
                            ),
                          );

                          // checkStatus(context);
                        },
                      ),
                    )),
              ),
            ),
          ),
          SafeArea(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: StreamBuilder<UpdateDriverStatus>(
                      stream: bloc.subjectAddcard.stream,
                      builder: (context, snap) {
                        return

                          Stack(

                            alignment: Alignment.bottomCenter,
                            children: [

                              offlineStatus(snap.data),


                              new Container(
                                  margin: const EdgeInsets.only(bottom: 15.0),
                                  child: ElevatedButton(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 100,
                                          right: 100,
                                          top: 15,
                                          bottom: 15),
                                      child: Text(
                                          snap.data != null
                                              ? snap.data.service.status != null
                                              ? snap.data.service.status ==
                                              'active'
                                              ? "GO OFFLINE"
                                              : "GO ONLINE"
                                              : prefs.getString(
                                              SharedPrefsKeys.STATUS) !=
                                              null
                                              ? prefs.getString(SharedPrefsKeys
                                              .STATUS) ==
                                              "offline"
                                              ? "GO ONLINE"
                                              : "GO OFFLINE"
                                              : "GO OFFLINE"
                                              : "GO OFFLINE",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontFamily: AppTheme.fontName)),
                                    ),
                                    style: ButtonStyle(
                                        foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            AppTheme.colorPrimaryDark),
                                        backgroundColor:
                                        snap.data != null
                                            ? snap.data.service.status != null
                                            ? snap.data.service.status ==
                                            'active'
                                            ? MaterialStateProperty.all<Color>(AppTheme.colorPrimaryDark)
                                            : MaterialStateProperty.all<Color>(Colors.green)
                                            : prefs.getString(
                                            SharedPrefsKeys.STATUS) !=
                                            null
                                            ? prefs.getString(SharedPrefsKeys
                                            .STATUS) ==
                                            "offline"
                                            ? MaterialStateProperty.all<Color>(Colors.green)
                                            : MaterialStateProperty.all<Color>(Colors.green)
                                            : MaterialStateProperty.all<Color>(Colors.green)
                                            : MaterialStateProperty.all<Color>(Colors.green),
                        /*MaterialStateProperty.all<Color>(AppTheme.colorPrimaryDark),*/
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(25),
                                                side: BorderSide(
                                                    color:
                                                    snap.data != null
                                                        ? snap.data.service.status != null
                                                        ? snap.data.service.status ==
                                                        'active'
                                                        ? AppTheme.colorPrimaryDark
                                                        : Colors.green
                                                        : prefs.getString(
                                                        SharedPrefsKeys.STATUS) !=
                                                        null
                                                        ? prefs.getString(SharedPrefsKeys
                                                        .STATUS) ==
                                                        "offline"
                                                        ? Colors.green
                                                        : Colors.green
                                                        : Colors.green
                                                        : Colors.green,)))),
                                    onPressed: () async =>
                                    {
                                      if (prefs.getString(
                                          SharedPrefsKeys.STATUS) ==
                                          "offline")
                                        {
                                          bloc.updateDriverStatus(
                                              context,
                                              prefs.getString(
                                                  SharedPrefsKeys.ACCESS_TOKEN),
                                              "active")
                                        }
                                      else
                                        {
                                          bloc.updateDriverStatus(
                                              context,
                                              prefs.getString(
                                                  SharedPrefsKeys.ACCESS_TOKEN),
                                              "offline")
                                        }
                                    },
                                  ))

                            ],
                          );
                      }))),

          request != null && requests.isNotEmpty ?
          SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      color: AppTheme.white,
                      shape: BoxShape.rectangle,
                    ),
                    height: size.height * 0.48,
                    child:

                    Stack(

                      children: [

                        request != null ? request.status == "COMPLETED" ?

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),

                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 20),
                              child: Text(
                                'Rate your service with ' + user.firstName +
                                    " " +
                                    user.lastName,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: AppTheme.nearlyBlack,
                                    fontFamily: AppTheme.fontName),
                              ),
                            ),

                            SizedBox(height: 10,),

                            Container(
                                margin: EdgeInsets.all(10),
                                width: 70,
                                height: 70,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.cover,
                                        image: new NetworkImage(
                                            user != null
                                                ? user.picture == ""
                                                ? "https://secure.gravatar.com/avatar/ea4a232b2a8c2b116ef27574d8c0abb7?s=400&d=mm&r=g"
                                                : user.picture
                                                : "https://secure.gravatar.com/avatar/ea4a232b2a8c2b116ef27574d8c0abb7?s=400&d=mm&r=g")))),

                            RatingBar(
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemSize: 45.0,
                              itemCount: 5,
                              minRating: 1,

                              ratingWidget: RatingWidget(
                                full: Image.asset(
                                  'assets/images/star-filled.png',
                                  color: Colors.amber,),
                                empty: Image.asset('assets/images/start.png',
                                    color: Colors.amber),
                              ),
                              itemPadding: EdgeInsets.symmetric(
                                  horizontal: 4.0),
                              onRatingUpdate: (rating) {
                                if (mounted) {
                                  setState(() {
                                    _tripRating = rating.toInt();
                                  });
                                }
                                print(rating);
                              },
                            ),

                            Padding(
                              padding: EdgeInsets.only(
                                  top: 10, left: 25, right: 25),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Form(
                                    key: _ratingformKey,

                                    child: Container(
                                      width: size.width * 0.8,
                                      height: size.height * 0.25,
                                      decoration: BoxDecoration(
                                        color: AppTheme.white,
                                        borderRadius: BorderRadius.circular(10),

                                      ),

                                      child:
                                      new TextFormField(
                                        maxLines: 4,
                                        autofocus: false,

                                        controller: _tripCommentController,

                                        validator: (value) {
                                          return value.isNotEmpty
                                              ? null
                                              : "Please write comment";
                                        },
                                        keyboardType: TextInputType.text,
                                        decoration: new InputDecoration(

                                          border: new OutlineInputBorder(
                                            borderSide:
                                            new BorderSide(color: Colors.grey),
                                            borderRadius:
                                            BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                          hintText: 'Write Your Comments',
                                        ),
                                      ),
                                    ),

                                  )

                                ],
                              ),
                            ),


                          ],
                        ) :
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            Align(

                              alignment: Alignment.center,
                              child: Visibility(
                                visible: request != null ? request.status ==
                                    'SEARCHING'
                                    ? true
                                    : false : false,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(50),
                                        bottomRight: Radius.circular(50)),
                                    color: Colors.grey,
                                    shape: BoxShape.rectangle,
                                  ),
                                  height: size.height * 0.07,
                                  width: size.width * 0.25,
                                  child: CountdownTimer(
                                    onEnd: onEnd,
                                    endTime: endTime,
                                    widgetBuilder: (_,
                                        CurrentRemainingTime time) {
                                      if (time == null) {
                                        return Text('Game over');
                                      }
                                      return Text(
                                        '${time.sec}',

                                        style: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 18,
                                            color: AppTheme.white),);
                                    },


                                  ),

                                ),


                              ),

                            ),


                            SizedBox(height: 10,),
                            Row(
                              children: [
                                new Container(
                                    margin: EdgeInsets.all(10),
                                    width: 70,
                                    height: 70,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                            fit: BoxFit.cover,
                                            image: new NetworkImage(
                                                user != null
                                                    ? user.picture == ""
                                                    ? "https://secure.gravatar.com/avatar/ea4a232b2a8c2b116ef27574d8c0abb7?s=400&d=mm&r=g"
                                                    : user.picture
                                                    : "https://secure.gravatar.com/avatar/ea4a232b2a8c2b116ef27574d8c0abb7?s=400&d=mm&r=g")))),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 0, right: 20),
                                      child: Text(
                                        user != null ? user.firstName + " " +
                                            user.lastName : '',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            color: AppTheme.nearlyBlack,
                                            fontFamily: AppTheme.fontName),
                                      ),
                                    ),
                                    RatingBarIndicator(
                                      rating: user != null ? user.rating != null
                                          ? double.parse(user.rating)
                                          : 0 : 0,
                                      itemBuilder: (context,
                                          index) =>
                                          Icon(
                                            Icons.star,
                                            color: Colors
                                                .amber,
                                          ),
                                      itemCount: 5,
                                      itemSize: 20.0,
                                      direction: Axis
                                          .horizontal,
                                    ),


                                  ],
                                ),

                                SizedBox(width: 50,),
                                Visibility(
                                    visible: request != null ? request.status ==
                                        'SEARCHING' ? false : true : false,
                                    child: Image.asset(
                                      "assets/images/call.png", height: 40,
                                      width: 40,
                                      color: AppTheme.colorPrimary,))


                              ],
                            ),


                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [


                                Padding(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Text(
                                    'Service Detail',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18,
                                        color: AppTheme.nearlyBlack,
                                        fontFamily: AppTheme.fontName),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Text(


                                      "Location Type: " + locationType  + "\n" +
                                        "Vehicle Number: " + vechileNo + "\n" +
                                        // "VIN Number: " + vinNumber + "\n" +
                                        "Model Year: " + modalYear + "\n" +
                                        " Service Type: " + subServiceName
                                    ,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        color: AppTheme.nearlyBlack,
                                        fontFamily: AppTheme.fontName),
                                  ),
                                ),



                                // DETAIL
                                Visibility(

                                  visible: request != null ? request.status ==
                                      "DROPPED"
                                      ? true
                                      : false : false,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 20, right: 20,top:30),
                                    child: Text(
                                      'Have you got payment ? If not please ask for cash payment from the customer',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          color: AppTheme.nearlyBlack,
                                          fontFamily: AppTheme.fontName),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),)

                              ],)


                          ],
                        ) :
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            Align(

                              alignment: Alignment.center,
                              child:
                              Visibility(
                                  visible: request != null ? request.status ==
                                      'SEARCHING'
                                      ? true
                                      : false : false,
                                  child:

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                      Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(50),
                                              bottomRight: Radius.circular(50)),
                                          color: Colors.grey,
                                          shape: BoxShape.rectangle,
                                        ),
                                        height: size.height * 0.07,
                                        width: size.width * 0.25,
                                        child: CountdownTimer(
                                          onEnd: onEnd,
                                          endTime: endTime,
                                          widgetBuilder: (_,
                                              CurrentRemainingTime time) {
                                            if (time == null) {
                                              return Text('Game over');
                                            }
                                            return Text(
                                              '${time.sec}',

                                              style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 18,
                                                  color: AppTheme.white),);
                                          },


                                        ),

                                      ),

                                    ],)

                              ),
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                new Container(
                                    margin: EdgeInsets.all(10),
                                    width: 70,
                                    height: 70,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                            fit: BoxFit.cover,
                                            image: new NetworkImage(
                                                user != null
                                                    ? user.picture == ""
                                                    ? "https://secure.gravatar.com/avatar/ea4a232b2a8c2b116ef27574d8c0abb7?s=400&d=mm&r=g"
                                                    : user.picture
                                                    : "https://secure.gravatar.com/avatar/ea4a232b2a8c2b116ef27574d8c0abb7?s=400&d=mm&r=g")))),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 0, right: 20),
                                      child: Text(
                                        user != null ? user.firstName + " " +
                                            user
                                                .lastName : '',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            color: AppTheme.nearlyBlack,
                                            fontFamily: AppTheme.fontName),
                                      ),
                                    ),
                                    RatingBarIndicator(
                                      rating: user != null ? user.rating != null
                                          ? double
                                          .parse(user.rating)
                                          : 0 : 0,
                                      itemBuilder: (context,
                                          index) =>
                                          Icon(
                                            Icons.star,
                                            color: Colors
                                                .amber,
                                          ),
                                      itemCount: 5,
                                      itemSize: 20.0,
                                      direction: Axis
                                          .horizontal,
                                    ),


                                  ],
                                ),

                                SizedBox(width: 50,),
                                Visibility(
                                    visible: request != null ? request.status ==
                                        'SEARCHING' ? false : true : false,
                                    child: Image.asset(
                                      "assets/images/call.png", height: 40,
                                      width: 40,
                                      color: AppTheme.colorPrimary,))


                              ],
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,

                              children: [

                                Padding(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Text(
                                    'Service Detail',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18,
                                        color: AppTheme.nearlyBlack,
                                        fontFamily: AppTheme.fontName),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 0, right: 20),
                                  child: Text(

                                    "Location Type: " + locationType + "\n" +
                                        "Vehicle Number: " + vechileNo + "\n" +
                                        // "VIN Number: " + vinNumber + "\n" +
                                        "Model Year: " + modalYear + "\n" +
                                        " Service Type: " + subServiceName
                                    ,


                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        color: AppTheme.nearlyBlack,
                                        fontFamily: AppTheme.fontName),
                                  ),
                                ),



                                // DETAIL
                                Visibility(

                                    visible: request != null ? request.status ==
                                        "DROPPED"
                                        ? true
                                        : false : false,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 20, right: 20,top:30),
                                      child: Text(
                                        'Have you got payment ? If not please ask for cash payment from the customer',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                            color: AppTheme.nearlyBlack,
                                            fontFamily: AppTheme.fontName),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),)


                              ],
                            )


                          ],
                        ),


                        Visibility(

                            visible: request != null ? request.status ==
                                "SEARCHING"
                                ? true
                                : false : false,
                            child: Padding(


                                padding: EdgeInsets.only(bottom: 20),

                                child:
                                new Align(


                                    alignment: FractionalOffset.bottomCenter,
                                    child:
                                    Row(


                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceAround,
                                      children: [

                                        ElevatedButton(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 30,
                                                right: 30,
                                                top: 15,
                                                bottom: 15),
                                            child: Text("Accept",
                                                style: TextStyle(fontSize: 14)),
                                          ),
                                          style: ButtonStyle(
                                              foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors
                                                      .white),
                                              backgroundColor: MaterialStateProperty
                                                  .all<
                                                  Color>(Colors.green),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(
                                                          15),
                                                      side: BorderSide(
                                                          color: Colors
                                                              .green)))),
                                          onPressed: () async =>
                                          {

                                            changeBookingStatus(context,
                                                request_id, "Accept")
                                          },
                                        ),
                                        ElevatedButton(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 30,
                                                right: 30,
                                                top: 15,
                                                bottom: 15),
                                            child: Text("Reject",
                                                style: TextStyle(fontSize: 14)),
                                          ),
                                          style: ButtonStyle(
                                              foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors
                                                      .white),
                                              backgroundColor: MaterialStateProperty
                                                  .all<
                                                  Color>(Colors.red),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(
                                                          15),
                                                      side: BorderSide(
                                                          color: Colors.red)))),
                                          onPressed: () async =>
                                          {
                                            changeBookingStatus(context,
                                                request_id, "Reject")
                                          },
                                        ),


                                      ],
                                    )
                                )

                            )),
                        Visibility(

                            visible: request != null ? request.status ==
                                "STARTED"
                                ? true
                                : false : false,
                            child: Padding(


                                padding: EdgeInsets.only(bottom: 20),

                                child:
                                new Align(


                                    alignment: FractionalOffset.bottomCenter,
                                    child:
                                    Row(


                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceAround,
                                      children: [

                                        ElevatedButton(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 30,
                                                right: 30,
                                                top: 15,
                                                bottom: 15),
                                            child: Text("Cancel",
                                                style: TextStyle(fontSize: 14)),
                                          ),
                                          style: ButtonStyle(
                                              foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors
                                                      .white),
                                              backgroundColor: MaterialStateProperty
                                                  .all<
                                                  Color>(
                                                  Colors.red),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(
                                                          15),
                                                      side: BorderSide(
                                                          color: Colors.red)))),
                                          onPressed: () async =>
                                          {

                                            showInformationDialog()
                                          },
                                        ),
                                        ElevatedButton(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 30,
                                                right: 30,
                                                top: 15,
                                                bottom: 15),
                                            child: Text("On Duty",
                                                style: TextStyle(fontSize: 14)),
                                          ),
                                          style: ButtonStyle(
                                              foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors
                                                      .white),
                                              backgroundColor: MaterialStateProperty
                                                  .all<
                                                  Color>(
                                                  Colors.green),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(
                                                          15),
                                                      side: BorderSide(
                                                          color: Colors
                                                              .green)))),
                                          onPressed: () async =>
                                          {

                                            changeBookingStatus(
                                                context, request_id,
                                                "ARRIVED")
                                          },
                                        ),


                                      ],
                                    )
                                )

                            )),
                        Visibility(

                            visible: request != null ? request.status ==
                                "ARRIVED"
                                ? true
                                : false : false,
                            child: Padding(


                                padding: EdgeInsets.only(bottom: 20),

                                child:
                                new Align(


                                    alignment: FractionalOffset.bottomCenter,
                                    child:
                                    Row(


                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceAround,
                                      children: [

                                        ElevatedButton(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 30,
                                                right: 30,
                                                top: 15,
                                                bottom: 15),
                                            child: Text("Cancel",
                                                style: TextStyle(fontSize: 14)),
                                          ),
                                          style: ButtonStyle(
                                              foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors
                                                      .white),
                                              backgroundColor: MaterialStateProperty
                                                  .all<
                                                  Color>(
                                                  Colors.red),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(
                                                          15),
                                                      side: BorderSide(
                                                          color: Colors.red)))),
                                          onPressed: () async =>
                                          {
                                          },
                                        ),
                                        ElevatedButton(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 30,
                                                right: 30,
                                                top: 15,
                                                bottom: 15),
                                            child: Text("Started Work",
                                                style: TextStyle(fontSize: 14)),
                                          ),
                                          style: ButtonStyle(
                                              foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors
                                                      .white),
                                              backgroundColor: MaterialStateProperty
                                                  .all<
                                                  Color>(
                                                  Colors.green),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(
                                                          15),
                                                      side: BorderSide(
                                                          color: Colors
                                                              .green)))),
                                          onPressed: () async =>
                                          {


                                            changeBookingStatus(
                                                context, request_id,
                                                "PICKEDUP")
                                          },
                                        ),


                                      ],
                                    )
                                )

                            )),
                        Visibility(

                            visible: request != null ? request.status ==
                                "PICKEDUP"
                                ? true
                                : false : false,
                            child: Padding(


                                padding: EdgeInsets.only(bottom: 20),

                                child:
                                new Align(


                                    alignment: FractionalOffset.bottomCenter,
                                    child:
                                    Row(


                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceAround,
                                      children: [
                                        ElevatedButton(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 30,
                                                right: 30,
                                                top: 15,
                                                bottom: 15),
                                            child: Text("Tap when job done",
                                                style: TextStyle(fontSize: 14)),
                                          ),
                                          style: ButtonStyle(
                                              foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors
                                                      .white),
                                              backgroundColor: MaterialStateProperty
                                                  .all<
                                                  Color>(
                                                  Colors.green),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(
                                                          15),
                                                      side: BorderSide(
                                                          color: Colors
                                                              .green)))),
                                          onPressed: () async =>
                                          {

                                            changeBookingStatus(
                                                context, request_id,
                                                "DROPPED")
                                          },
                                        ),


                                      ],
                                    )
                                )

                            )),
                        Visibility(

                            visible: request != null ? request.status ==
                                "DROPPED"
                                ? true
                                : false : false,
                            child: Padding(


                                padding: EdgeInsets.only(bottom: 20),

                                child:
                                new Align(


                                    alignment: FractionalOffset.bottomCenter,
                                    child:
                                    Row(


                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceAround,
                                      children: [
                                        ElevatedButton(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 30,
                                                right: 30,
                                                top: 15,
                                                bottom: 15),
                                            child: Text("Confirm Payment",
                                                style: TextStyle(fontSize: 14)),
                                          ),
                                          style: ButtonStyle(
                                              foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors
                                                      .white),
                                              backgroundColor: MaterialStateProperty
                                                  .all<
                                                  Color>(
                                                  Colors.green),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(
                                                          15),
                                                      side: BorderSide(
                                                          color: Colors
                                                              .green)))),
                                          onPressed: () async =>
                                          {

                                            changeBookingStatus(
                                                context, request_id,
                                                "COMPLETED")
                                          },
                                        ),



                                      ],
                                    )
                                )

                            )),
                        Visibility(

                            visible: request != null ? request.status ==
                                "COMPLETED"
                                ? true
                                : false : false,
                            child: Padding(


                                padding: EdgeInsets.only(bottom: 20),

                                child:
                                new Align(


                                    alignment: FractionalOffset.bottomCenter,
                                    child:
                                    Row(


                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceAround,
                                      children: [
                                        ElevatedButton(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 30,
                                                right: 30,
                                                top: 15,
                                                bottom: 15),
                                            child: Text("Submit",
                                                style: TextStyle(fontSize: 14)),
                                          ),
                                          style: ButtonStyle(
                                              foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                              backgroundColor: MaterialStateProperty
                                                  .all<Color>(
                                                  Colors.green),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(15),
                                                      side: BorderSide(
                                                          color: Colors
                                                              .green)))),
                                          onPressed: () async =>
                                          {

                                            if (_ratingformKey.currentState
                                                .validate())
                                              {
                                                giveRating(
                                                    context, request_id, "RATE",
                                                    _tripRating.toString(),
                                                    _tripCommentController.text
                                                        .toString())
                                              }
                                          },
                                        ),


                                      ],
                                    )
                                )

                            ))


                      ],
                    )


                ),


              )) : Text(''),


        ],
      ),
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

  Future<Response> checkStatus(BuildContext context) async {
    bool isDeviceOnline = true;
    // bool isDeviceOnline = await checkConnection();
    if (isDeviceOnline) {
/*
      ArsProgressDialog progressDialog = ArsProgressDialog(context,
          blur: 2,
          backgroundColor: Color(0x33000000),
          animationDuration: Duration(milliseconds: 500));

      progressDialog.show();
*/


    // try{
        var dio = Dio();

        BaseApi baseApi = new BaseApi(dio);
        var body = json.encode({
          "service_id": "",
        });

        String url = getStatusUrl +
            "latitude=" +
            _currentPosition.latitude.toString() +
            "&longitude=" +
            _currentPosition.longitude.toString();

        print(url + "=URL");

        baseApi.dio.options.headers = {
          "X-Requested-With": "XMLHttpRequest",
          "Authorization":
          "Bearer " + prefs.getString(SharedPrefsKeys.ACCESS_TOKEN)
        };

        Response response = await baseApi.dio.get(url);
        // print(        response.request.baseUrl+"=URL");
        // baseApi.dio.options.headers = {"X-Requested-With":"XMLHttpRequest","Authorization" : "Bearer ${prefs.getString(SharedPrefsKeys.ACCESS_TOKEN)};

        final parsed = json.decode(response.toString());


        print(parsed.toString()+" -----------------W"
            "ALL");


        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);
          // progressDialog.dismiss();

          final parsed = json.decode(response.toString());

          var checkstatusModel = CheckStatusModel.fromJson(parsed);


          // print(parsed.toString()+" =VALL");
          // progressDialog.dismiss();


          setState(() {
            if (checkstatusModel.requests.length > 0) {
              user = checkstatusModel.requests[0].request.user;
              request = checkstatusModel.requests[0].request;
              requests = checkstatusModel.requests;
              request_id = checkstatusModel.requests[0].requestId;
              Size size = MediaQuery
                  .of(context)
                  .size;
              // endTime = DateTime.now().millisecondsSinceEpoch + 1000 * checkstatusModel.requests[0].timeLeftToRespond;
              // controller = CountdownTimerController(endTime: endTime, onEnd: onEnd);

              endTime = DateTime
                  .now()
                  .millisecondsSinceEpoch +
                  1000 * checkstatusModel.requests[0].timeLeftToRespond;

              print(request_id.toString()+"REQUESTID");
              if (request.status == "SEARCHING" && !isAudioPlayed) {
                isAudioPlayed = true;
                player.play("alert_tone.mp3");

                print("LONGAUDIO");

              }

              // String optionsStr = request.options;

              if(request.options.isNotEmpty){

 var optionsValue = json.decode(request.options);
                print(optionsValue.toString() + "RES");

                OptionsData values = OptionsData.fromJson(optionsValue);


                locationType = values.locationType;
                vechileNo = values.vechileNo;
                // vinNumber = values.vinNumber;
                modalYear = values.make;
                subServiceName = values.subServiceName;

                print(locationType+"="+vechileNo+"="+modalYear+"="+subServiceName+" = SERVICESS");

              }
            } else {
              requests.clear();
            }
          });
        }

        return response;
    /*  } catch (e) {
        print("RESPOONSE:" + e.toString());


        // progressDialog.dismiss();

        // displayToast("Something went wrong", context);
        return null;
      }*/
    } else {
      displayToast("Please connect to internet", context);
      return null;
    }
  }

  Widget offlineStatus(UpdateDriverStatus snapData){
var widget = null;
    if(snapData != null){
      if(snapData.service.status!='active'){
        widget =  Container(
          color: AppTheme.white,
          alignment: Alignment.center,
          child: Image.asset("assets/images/offline.png",width: 250,height: 250,),
        );
      }else{
        return SizedBox();

      }

    }else{
      return SizedBox();
    }


    return widget;


  }

  Future<Response> changeBookingStatus(BuildContext context, String trip_id,
      String bookingStatus) async {
    bool isDeviceOnline = true;
    // bool isDeviceOnline = await checkConnection();
    if (isDeviceOnline) {
      ArsProgressDialog progressDialog = ArsProgressDialog(context,
          blur: 2,
          backgroundColor: Color(0x33000000),
          animationDuration: Duration(milliseconds: 500));

      progressDialog.show();

      try {
        var dio = Dio();

        BaseApi baseApi = new BaseApi(dio);

        String url = changeBookingStatusUrl + trip_id.toString();

        print(url + "=URL");

        baseApi.dio.options.headers = {
          "X-Requested-With": "XMLHttpRequest",
          "Authorization":
          "Bearer " + prefs.getString(SharedPrefsKeys.ACCESS_TOKEN)
        };
        Response response;

        if (bookingStatus == "Accept") {
          response = await baseApi.dio.post(url);
        } else if (bookingStatus == "Reject") {
          await baseApi.dio.delete(url);
        } else {
          var body = json.encode({
            "_method": "PATCH",
            "status": bookingStatus,
          });

          response = await baseApi.dio.post(url, data: body);
        }
        // response = bookingStatus=='Accept'?await baseApi.dio.post(url):await baseApi.dio.delete(url);
        // print(        response.request.baseUrl+"=URL");
        // baseApi.dio.options.headers = {"X-Requested-With":"XMLHttpRequest","Authorization" : "Bearer ${prefs.getString(SharedPrefsKeys.ACCESS_TOKEN)};

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);
          progressDialog.dismiss();

          final parsed = json.decode(response.toString());

          // var checkstatusModel = CheckStatusModel.fromJson(parsed);


          setState(() {
            isAudioPlayed =false;

          });

          audioPlayer.stop();

          print(parsed);
          progressDialog.dismiss();

          checkStatus(context);
        }

        return response;
      } catch (e) {
        print("RESPOONSE:" + e.toString());
        progressDialog.dismiss();
        setState(() {
          isAudioPlayed =false;

        });
        // displayToast("Something went wrong", context);
        return null;
      }
    } else {
      displayToast("Please connect to internet", context);
      return null;
    }
  }

  Future<Response> giveRating(BuildContext context, String trip_id,
      String bookingStatus, String rating, String comment) async {
    bool isDeviceOnline = true;
    // bool isDeviceOnline = await checkConnection();
    if (isDeviceOnline) {
      ArsProgressDialog progressDialog = ArsProgressDialog(context,
          blur: 2,
          backgroundColor: Color(0x33000000),
          animationDuration: Duration(milliseconds: 500));

      progressDialog.show();

      try {
        var dio = Dio();

        BaseApi baseApi = new BaseApi(dio);

        String url = changeBookingStatusUrl + trip_id.toString() + "/rate";

        print(url + "=URL");

        baseApi.dio.options.headers = {
          "X-Requested-With": "XMLHttpRequest",
          "Authorization":
          "Bearer " + prefs.getString(SharedPrefsKeys.ACCESS_TOKEN)
        };
        Response response;


        var body = json.encode({
          "rating": rating,
          "comment": comment,
        });

        response = await baseApi.dio.post(url, data: body);


        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);
          progressDialog.dismiss();

          final parsed = json.decode(response.toString());

          // var checkstatusModel = CheckStatusModel.fromJson(parsed);


          print(parsed);
          progressDialog.dismiss();

          checkStatus(context);
        }

        return response;
      } catch (e) {
        print("RESPOONSE:" + e.toString());
        progressDialog.dismiss();

        displayToast("Something went wrong", context);
        return null;
      }
    } else {
      displayToast("Please connect to internet", context);
      return null;
    }
  }

  Future<Response> rejectBooking(String id,
      String cancel_reason,) async {
    bool isDeviceOnline = true;
    // bool isDeviceOnline = await checkConnection();
    if (isDeviceOnline) {
      ArsProgressDialog progressDialog = ArsProgressDialog(context,
          blur: 2,
          backgroundColor: Color(0x33000000),
          animationDuration: Duration(milliseconds: 500));

      progressDialog.show();

      try {
        var dio = Dio();

        BaseApi baseApi = new BaseApi(dio);


        baseApi.dio.options.headers = {
          "X-Requested-With": "XMLHttpRequest",
          "Authorization":
          "Bearer " + prefs.getString(SharedPrefsKeys.ACCESS_TOKEN)
        };
        Response response;


        var body = json.encode({
          "id": id,
          "cancel_reason": cancel_reason,
        });

        response = await baseApi.dio.post(cancelRideUrl, data: body);


        // response = bookingStatus=='Accept'?await baseApi.dio.post(url):await baseApi.dio.delete(url);
        // print(        response.request.baseUrl+"=URL");
        // baseApi.dio.options.headers = {"X-Requested-With":"XMLHttpRequest","Authorization" : "Bearer ${prefs.getString(SharedPrefsKeys.ACCESS_TOKEN)};

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);
          progressDialog.dismiss();

          final parsed = json.decode(response.toString());

          // var checkstatusModel = CheckStatusModel.fromJson(parsed);


          print(parsed);
          progressDialog.dismiss();

          checkStatus(context);
        }

        return response;
      } catch (e) {
        print("RESPOONSE:" + e.toString());
        progressDialog.dismiss();

        displayToast("Something went wrong", context);
        return null;
      }
    } else {
      displayToast("Please connect to internet", context);
      return null;
    }
  }

  Future<void> showInformationDialog() async {
    return await showDialog(
        context: context,
        builder: (context) {
          bool isChecked = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        maxLines: 3,

                        controller: _textEditingController,
                        validator: (value) {
                          return value.isNotEmpty
                              ? null
                              : "Please enter cancellation reason";
                        },
                        decoration:
                        InputDecoration(hintText: "Enter cancellation reason"),
                      ),
                    ],
                  )),
              title: Text('Cancellation Reason'),
              actions: <Widget>[
                InkWell(
                  child: Text('Submit   '),
                  onTap: () {
                    if (_formKey.currentState.validate()) {
                      // Do something like updating SharedPreferences or User Settings etc.
                      Navigator.of(context).pop();

                      rejectBooking(request.id.toString(),
                          _textEditingController.text.toString());
                    }
                  },
                ),
              ],
            );
          });
        });
  }


}


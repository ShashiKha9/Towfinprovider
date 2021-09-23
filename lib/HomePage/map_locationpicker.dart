import 'dart:async';
import 'dart:ui';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:cbx_driver/Modals/AllProvidersList.dart';
import 'package:cbx_driver/Modals/CheckStatusData.dart';
import 'package:cbx_driver/Modals/CheckStatusRespone.dart';
import 'package:cbx_driver/Modals/approximateprice_respo.dart';
import 'package:cbx_driver/Modals/providers_list_repo.dart';
import 'package:cbx_driver/Utils/helperutils.dart';
import 'package:cbx_driver/app_theme.dart';
import 'package:cbx_driver/bloc/LoginBloc.dart';
import 'package:cbx_driver/components/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:math' show cos, sqrt, asin;

import 'package:shared_preferences/shared_preferences.dart';

const double CAMERA_ZOOM = 12;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(22.9734229, 78.6568942);
const LatLng DEST_LOCATION = LatLng(26.2047902, 78.1823709);

class MapView extends StatefulWidget {
  MapView({Key key,
    this.serviceName,
    this.serviceId,
    this.subServiceId,
    this.subServiceName,
    this.serviceImg,
    this.locationType})
      : super(key: key);
  final serviceName;
  final serviceId;
  final subServiceId;
  final subServiceName;
  final locationType;
  final serviceImg;


  @override
  _MapViewState createState() =>
      _MapViewState(
          this.serviceName,
          this.serviceId,
          this.subServiceId,
          this.subServiceName,
          this.locationType,
          this.serviceImg);
}

class _MapViewState extends State<MapView> {
  _MapViewState(this.serviceName, this.serviceId, this.subServiceId,
      this.subServiceName, this.locationType, this.serviceImg);

  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  GoogleMapController mapController;

  String serviceName;
  String serviceId;
  String subServiceId;
  String subServiceName;
  String locationType;
  String serviceImg;
  Timer timer;

  var _locationFetched=false;
  String _selectedDriverKmAway = '';
  Position _currentPosition;
  String _currentAddress;
  String _time;
  int selectedIndex = -1;
  int _selectedDriverid = -1;
  double _driverSourceLat = 0;
  double _driverSourceLng = 0;
  double _estimatedFare = 0;
  double _taxPrice = 0;
  int _approximatePrice = 0;
  int _walletBalance = 0;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var _tripRating = 1;
  bool isShowProviders = false;
  List<AllProvidersList> allProviderList = List<AllProvidersList>();
  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  final startAddressFocusNode = FocusNode();
  final desrinationAddressFocusNode = FocusNode();

  String _startAddress = '';
  String _destinationAddress = '';
  String _placeDistance;
  SharedPreferences prefs;
  Set<Marker> markers = {};

  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];


  Widget _textField({
    TextEditingController controller,
    FocusNode focusNode,
    String label,
    String hint,
    double width,
    Icon prefixIcon,
    Widget suffixIcon,
    Function(String) locationCallback,
  }) {
    return Container(
      width: width * 0.7,
      child: TextField(
        readOnly: true,
        onChanged: (value) {
          locationCallback(value);
        },
        style: TextStyle(fontSize: 12.0, color: Colors.black),
        maxLines: 2,
        controller: controller,
        // focusNode: focusNode,
        decoration: new InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: false,
          fillColor: Colors.white,
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50.0),
            ),
            borderSide: BorderSide(
              color: Colors.white,
              width: 0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50.0),
            ),
            borderSide: BorderSide(
              color: Colors.white,
              width: 0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50.0),
            ),
            borderSide: BorderSide(
              color: Colors.white,
              width: 0,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
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

    print("fsdfdss");



    // _determinePosition();



    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) async {


          print("LOCATION");
          // if (mounted) {
            setState(() {
              _currentPosition = position;
              print('CURRENT POS: $_currentPosition');
              mapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(position.latitude, position.longitude),
                    zoom: 18.0,
                  ),
                ),
              );
            });
          // }
      await _getAddress();

/*      timer = Timer.periodic(
        Duration(seconds: 2), (Timer t) => bloc.reqCheckAPI(_scaffoldKey.currentContext, "", ""));*/
    }).catchError((e) {
      print(e);
    });
  }

  // Method for retrieving the address
  _getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];
      if (mounted) {
        setState(() {
          _currentAddress =
          "${place.name}, ${place.locality}, ${place.postalCode}, ${place
              .country}";
          startAddressController.text = _currentAddress;
          _startAddress = _currentAddress;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  // Method for calculating the distance between two places
  Future<bool> _calculateDistance(Position startCoordinate,
      Position destinationCoordinate) async {
    try {
      // Retrieving placemarks from addresses
      /*    List<Location> startPlacemark = await locationFromAddress(_startAddress);
      List<Location> destinationPlacemark =
          await locationFromAddress(_destinationAddress);

      if (startPlacemark != null && destinationPlacemark != null) {
        // Use the retrieved coordinates of the current position,
        // instead of the address if the start position is user's
        // current position, as it results in better accuracy.
        Position startCoordinates = _startAddress == _currentAddress
            ? Position(
                latitude: _currentPosition.latitude,
                longitude: _currentPosition.longitude)
            : Position(
                latitude: startPlacemark[0].latitude,
                longitude: startPlacemark[0].longitude);
        Position destinationCoordinates = Position(
            latitude: destinationPlacemark[0].latitude,
            longitude: destinationPlacemark[0].longitude);
  */ // Start Location Marker



      BitmapDescriptor destiantionIcon;

      if (destiantionIcon == null) {
        ImageConfiguration configuration =
        createLocalImageConfiguration(context);

        BitmapDescriptor.fromAssetImage(
            configuration, 'assets/images/driving_pin.png')
            .then((icon) {
          if (mounted) {
            setState(() {
              destiantionIcon = icon;
            });
          }
        });
      }


      /*BitmapDescriptor sourceIcon;

      if (sourceIcon == null) {
        ImageConfiguration configuration =
        createLocalImageConfiguration(context);

        BitmapDescriptor.fromAssetImage(
            configuration, 'assets/images/destination_map_marker.png')
            .then((icon) {
          if (mounted) {
            setState(() {
              sourceIcon = icon;
            });
          }
        });
      }*/
      BitmapDescriptor customIcon;

      // make sure to initialize before map loading
      BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
          'assets/images/destination_map_marker.png')
          .then((d) {
        customIcon = d;
      });

      final icon_dest = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(24, 24)), 'destination_map_marker.png');
final icon_Source = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(24, 24)), 'driving_pin.png.png');


      Marker startMarker = Marker(
        markerId: MarkerId('$startCoordinate'),
        position: LatLng(
          startCoordinate.latitude,
          startCoordinate.longitude,
        ),

        icon: icon_dest,
      );
      // Destination Location Marker
      Marker destinationMarker = Marker(
        markerId: MarkerId('$destinationCoordinate'),
        position: LatLng(
          destinationCoordinate.latitude,
          destinationCoordinate.longitude,
        ),
       /* infoWindow: InfoWindow(
          title: 'Destination',
          snippet: _destinationAddress,
        ),*/
        icon: icon_Source,
      );

      // Adding the markers to the list
      markers.add(startMarker);
      markers.add(destinationMarker);

      print('START COORDINATES: $startCoordinate');
      print('DESTINATION COORDINATES: $destinationCoordinate');

      Position _northeastCoordinates;
      Position _southwestCoordinates;

      // Calculating to check that the position relative
      // to the frame, and pan & zoom the camera accordingly.
      double miny =
      (destinationCoordinate.latitude <= destinationCoordinate.latitude)
          ? startCoordinate.latitude
          : destinationCoordinate.latitude;
      double minx =
      (startCoordinate.longitude <= destinationCoordinate.longitude)
          ? startCoordinate.longitude
          : destinationCoordinate.longitude;
      double maxy = (startCoordinate.latitude <= destinationCoordinate.latitude)
          ? destinationCoordinate.latitude
          : startCoordinate.latitude;
      double maxx =
      (startCoordinate.longitude <= destinationCoordinate.longitude)
          ? destinationCoordinate.longitude
          : startCoordinate.longitude;

      _southwestCoordinates = Position(latitude: miny, longitude: minx);
      _northeastCoordinates = Position(latitude: maxy, longitude: maxx);

      // Accommodate the two locations within the
      // camera view of the map
      mapController.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            northeast: LatLng(
              _northeastCoordinates.latitude,
              _northeastCoordinates.longitude,
            ),
            southwest: LatLng(
              _southwestCoordinates.latitude,
              _southwestCoordinates.longitude,
            ),
          ),
          100.0,
        ),
      );

      // Calculating the distance between the start and the end positions
      // with a straight path, without considering any route
      // double distanceInMeters = await Geolocator().bearingBetween(
      //   startCoordinates.latitude,
      //   startCoordinates.longitude,
      //   destinationCoordinates.latitude,
      //   destinationCoordinates.longitude,
      // );

      await _createPolylines(startCoordinate, destinationCoordinate);

      double totalDistance = 0.0;

      // Calculating the total distance by adding the distance
      // between small segments
      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += _coordinateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }
      if (mounted) {
        setState(() {
          _placeDistance = totalDistance.toStringAsFixed(2);

          _selectedDriverKmAway = _placeDistance.toString();
          print('DISTANCE: $_placeDistance km');
        });
      }
      return true;
      // }
    } catch (e) {
      print(e);
    }
    return false;
  }

  // Formula for calculating distance between two coordinates
  // https://stackoverflow.com/a/54138876/11910277
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  // Create the polylines for showing the route between two places
  _createPolylines(Position start, Position destination) async {
    polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyBEoFApISEGJA8uKdm-1Z6nQmLj5d16ZPw", // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.transit,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.clear();
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');

    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 2,
    );

    polylines[id] = polyline;

    print("RUNINSG THIS");
  }

  @override
  Future<void> initState() {
    super.initState();
    _getCurrentLocation();

// getlocation();

  }

  getlocation() async {

    try{
      print( "EXCEPTIONTRY");

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best,forceAndroidLocationManager: true);

      print(position.latitude.toString()+" = "+position.longitude.toString()+" LOC");

    }catch(e){
print(e.toString()+ "EXCEPTION");
    }

  }


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery
        .of(context)
        .size
        .height;
    var width = MediaQuery
        .of(context)
        .size
        .width;
    return Container(
      height: height,
      width: width,
      child: Scaffold(
        key: _scaffoldKey,
        body:
        Stack(
          children: <Widget>[
            // Map View
            GoogleMap(
              markers: markers != null ? Set<Marker>.from(markers) : null,
              initialCameraPosition: _initialLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              polylines: Set<Polyline>.of(polylines.values),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
                mapController.setMapStyle(Utils.mapStyles);
              },
            ),

            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(50.0),
                      ),
                    ),
                    width: width * 0.7,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
/*
                          Text(
                            'Places',
                            style: TextStyle(fontSize: 20.0),
                          ),
*/
                          _textField(
                              hint: 'Choose starting point',
                              prefixIcon: Icon(Icons.pin_drop_outlined),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.my_location),
                                onPressed: () {
                                  startAddressController.text = _currentAddress;
                                  _startAddress = _currentAddress;
                                },
                              ),
                              controller: startAddressController,
                              focusNode: startAddressFocusNode,
                              width: width,
                              locationCallback: (String value) {
                                if (mounted) {
                                  setState(() {
                                    _startAddress = value;
                                  });
                                }
                              }),
                          // SizedBox(height: 10),
                          /* _textField(
                              label: 'Destination',
                              hint: 'Choose destination',
                              prefixIcon: Icon(Icons.looks_two),
                              controller: destinationAddressController,
                              focusNode: desrinationAddressFocusNode,
                              width: width,
                              locationCallback: (String value) {
                                setState(() {
                                  _destinationAddress = value;
                                });
                              }),*/
                          // SizedBox(height: 10),
                          /*
                          Visibility(
                            visible: _placeDistance == null ? false : true,
                            child: Text(
                              'DISTANCE: $_placeDistance km',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
*/
                          /*   SizedBox(height: 5),
                          RaisedButton(
                            onPressed: (_startAddress != '' && _destinationAddress != '')
                                ? () async {
                              startAddressFocusNode.unfocus();
                              desrinationAddressFocusNode.unfocus();
                              setState(() {
                                if (markers.isNotEmpty) markers.clear();
                                if (polylines.isNotEmpty) polylines.clear();
                                if (polylineCoordinates.isNotEmpty)
                                  polylineCoordinates.clear();
                                _placeDistance = null;
                              });

                              _calculateDistance().then((isCalculated) {
                                if (isCalculated) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Distance Calculated Sucessfully'),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error Calculating Distance'),
                                    ),
                                  );
                                }
                              });
                            }
                                : null,
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Show Route'.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Show current location button
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
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // width * 0.25

            Visibility(
              visible: _currentPosition==null?true:false,
              child: Container(
                color: AppTheme.white,
                height: height,
              width: width,
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10,),
                  Text('Getting Location Please Wait...',style: TextStyle(fontFamily: AppTheme.fontName,fontSize:15 ),)

                ],
              ),

            ),



            ),

            // ---------------------- Logic start from here --------------------------


            StreamBuilder<CheckStatusResponse>(
                stream: bloc.subjectCheckStatus,
                builder: (buildContext, snapCheckStatus) {
                  return StreamBuilder<ProvidersListResponse>(
                      stream: bloc.subjectProvidersList.stream!=null?bloc.subjectProvidersList.stream:'',
                      builder: (buildContext, snapProvider) {
                        return StreamBuilder<ApproximatePriceRespo>(

                            stream: bloc.subjectApproximatePriceList.stream,
                            builder: (context, snap) {
                              return

                                snapCheckStatus.hasData &&
                                    snapCheckStatus.data.data.length > 0
                                    ? statusWiseWidget(
                                    snapCheckStatus.data.data[0].status,
                                    snapCheckStatus.data.data[0])
                                    : !snapProvider.hasData ?
                                Visibility(
                                    visible: true,
                                    child:
                                    Positioned(
                                      /*Show Service Description*/
                                      bottom: 0,
                                      child: Container(
                                        color: Color.fromRGBO(
                                            255, 255, 255, 0.0),
                                        width: width,
                                        height: height * 0.35,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                                bottom: 0,
                                                child: Container(
                                                    width: width,
                                                    height: height * 0.20,
                                                    padding: const EdgeInsets
                                                        .all(
                                                        20.0),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .only(
                                                            topRight: Radius
                                                                .circular(
                                                                25.0),
                                                            topLeft: Radius
                                                                .circular(
                                                                25.0)),
                                                        gradient: LinearGradient(
                                                            begin: FractionalOffset.topCenter,
                                                            end: FractionalOffset.centerRight,
                                                            colors: [AppTheme.colorPrimaryDark, AppTheme.colorPrimary]),
                                                        color: AppTheme
                                                            .colorPrimaryDark),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .center,
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .end,
                                                      children: [
                                                        ElevatedButton(
                                                          child: Padding(
                                                            padding:
                                                            EdgeInsets.only(
                                                                left: 100,
                                                                right: 100,
                                                                top: 25,
                                                                bottom: 25),
                                                            child: Text(
                                                                "Continue",
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
                                                            prefs =
                                                            await SharedPreferences
                                                                .getInstance(),
                                                            bloc
                                                                .fetchAllproviderListReq(
                                                                context,
                                                                prefs.getString(
                                                                    SharedPrefsKeys
                                                                        .ACCESS_TOKEN),
                                                                prefs.getString(
                                                                    SharedPrefsKeys
                                                                        .TOKEN_TYPE),
                                                                serviceId,
                                                                _currentPosition
                                                                    .latitude,
                                                                _currentPosition
                                                                    .longitude),

                                                            // if(snapProvider.data
                                                            //     .allServicesList
                                                            //     .length > 0){
                                                            //   // setState(() {
                                                            //   isShowProviders =
                                                            //   true
                                                            //
                                                            //   // }),
                                                            // }
                                                          },
                                                        )
                                                      ],
                                                    ))),
                                            Positioned(
                                              child: Container(
                                                width: width,
                                                child: Card(
                                                    margin: EdgeInsets.only(
                                                        left: 30,
                                                        right: 30,
                                                        bottom: 20),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .all(
                                                            Radius.circular(
                                                                30))),
                                                    color: AppTheme.white,
                                                    elevation: 3,
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                          15),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize
                                                            .max,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                              mainAxisSize: MainAxisSize
                                                                  .max,
                                                              children: [
                                                                new FadeInImage
                                                                    .assetNetwork(
                                                                  placeholder:
                                                                  'assets/images/car.png',
                                                                  image: serviceImg,
                                                                  width: width *
                                                                      0.15,
                                                                  height: height *
                                                                      0.08,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        SizedBox(
                                                                          width: width *
                                                                              0.500,
                                                                          child: Padding(
                                                                              padding:
                                                                              EdgeInsets
                                                                                  .only(
                                                                                  left: 15),
                                                                              child: Text(
                                                                                serviceName,
                                                                                style: TextStyle(
                                                                                  fontSize: 15,
                                                                                  fontWeight:
                                                                                  FontWeight
                                                                                      .w800,
                                                                                  fontFamily:
                                                                                  AppTheme
                                                                                      .fontName,
                                                                                  color: AppTheme
                                                                                      .grey,
                                                                                ),
                                                                              )),
                                                                        ),
                                                                        // width * 0.20
                                                                        Padding(
                                                                          padding:
                                                                          EdgeInsets
                                                                              .only(
                                                                              left: 0),
                                                                          child: Text(
                                                                            snap
                                                                                .data ==
                                                                                null
                                                                                ? ''
                                                                                : "\$ " +
                                                                                snap
                                                                                    .data
                                                                                    .basePrice
                                                                                    .toString(),
                                                                            style: TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .w800,
                                                                              fontFamily: AppTheme
                                                                                  .fontName,
                                                                              color:
                                                                              AppTheme
                                                                                  .grey,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Padding(
                                                                        padding: EdgeInsets
                                                                            .only(
                                                                            left: 15),
                                                                        child: Text(
                                                                          subServiceName ==
                                                                              null
                                                                              ? "null"
                                                                              : subServiceName,
                                                                          style: TextStyle(
                                                                            fontSize: 12,
                                                                            fontFamily:
                                                                            AppTheme
                                                                                .fontName,
                                                                            color: AppTheme
                                                                                .grey,
                                                                          ),
                                                                        ))
                                                                  ],
                                                                ),
                                                              ])
                                                        ],
                                                      ),
                                                    )),
                                              ),
                                              bottom: height * 0.10,
                                            )
                                          ],
                                        ),
                                      ),
                                    )) :


                                Visibility(
                                    visible: snapProvider.hasData,
                                    child: !snap.hasData ?
                                    // show Providers Selection
                                    Positioned(
/*
                              Show Provider List
*/
                                      bottom: 0,
                                      child: Container(
                                        color: Color.fromRGBO(
                                            255, 255, 255, 0.0),
                                        width: width,
                                        height: height * 0.65,
                                        child: Stack(
                                          alignment: Alignment.bottomLeft,
                                          children: [
                                            Positioned(
                                                bottom: 0,
                                                child: Container(
                                                    width: width,
                                                    height: height * 0.20,
                                                    padding: const EdgeInsets
                                                        .all(
                                                        20.0),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .only(
                                                            topRight: Radius
                                                                .circular(
                                                                25.0),
                                                            topLeft: Radius
                                                                .circular(
                                                                25.0)),
                                                        gradient: LinearGradient(
                                                            begin: FractionalOffset.topCenter,
                                                            end: FractionalOffset.centerRight,
                                                            colors: [AppTheme.colorPrimaryDark, AppTheme.colorPrimary]),
                                                        color: AppTheme
                                                            .colorPrimaryDark),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .end,
                                                      children: [

                                                        ElevatedButton(
                                                          child: Padding(
                                                            padding:
                                                            EdgeInsets.only(
                                                                left: 20,
                                                                right: 20,
                                                                top: 15,
                                                                bottom: 15),
                                                            child: Text(
                                                                "Continue",
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

                                                            if(_driverSourceLat !=
                                                                0 &&
                                                                _driverSourceLng !=
                                                                    0){

                                                              prefs =
                                                              await SharedPreferences
                                                                  .getInstance(),
                                                              bloc
                                                                  .getApproximatePrice(
                                                                  context,
                                                                  prefs
                                                                      .getString(
                                                                      SharedPrefsKeys
                                                                          .ACCESS_TOKEN),
                                                                  prefs
                                                                      .getString(
                                                                      SharedPrefsKeys
                                                                          .TOKEN_TYPE),
                                                                  serviceId,
                                                                  _currentPosition
                                                                      .latitude,
                                                                  _currentPosition
                                                                      .longitude,
                                                                  _driverSourceLat,
                                                                  _driverSourceLng),

                                                              if(snap.data !=
                                                                  null){
                                                                // setState(() {

                                                                isShowProviders =
                                                                false

                                                                // }),
                                                              }
                                                            } else
                                                              {
                                                                showToast(
                                                                    "Please select a provider to continue",
                                                                    context)
                                                              }
                                                          },
                                                        ),
/*                                                        ElevatedButton(
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .only(
                                                                left: 20,
                                                                right: 20,
                                                                top: 15,
                                                                bottom: 15),
                                                            child: Text(
                                                                "Random ",
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                    AppTheme
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
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                          25),
                                                                      side:
                                                                      BorderSide(
                                                                          color: AppTheme
                                                                              .white)))),
                                                          onPressed: () async =>
                                                          {
                                                            prefs =
                                                            await SharedPreferences
                                                                .getInstance(),
                                                            // setState(() {}
                                                            // ),
                                                          },
                                                        )*/
                                                      ],
                                                    ))),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: height * 0.10),
                                                child:
                                                ListView.builder(
                                                    reverse: true,
                                                    itemCount: snapProvider
                                                        .data !=
                                                        null
                                                        ? snapProvider.data
                                                        .allServicesList.length
                                                        : 0,
                                                    itemBuilder: (context,
                                                        index) {
                                                      final item = snapProvider
                                                          .data
                                                          .allServicesList[index];
                                                      Size size = MediaQuery
                                                          .of(context)
                                                          .size;

                                                      return Card(
                                                          margin: EdgeInsets
                                                              .only(
                                                              left: 30,
                                                              right: 30,
                                                              bottom: 20),
                                                          shape: selectedIndex ==
                                                              index
                                                              ? new RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(
                                                                  Radius
                                                                      .circular(
                                                                      30)),
                                                              side: new BorderSide(
                                                                  color: Colors
                                                                      .blue,
                                                                  width: 1.0))
                                                              : new RoundedRectangleBorder(
                                                              side: new BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 1.0),
                                                              borderRadius: BorderRadius
                                                                  .all(
                                                                  Radius
                                                                      .circular(
                                                                      30))),
                                                          color: AppTheme.white,
                                                          elevation: 3,
                                                          child: Padding(
                                                              padding: EdgeInsets
                                                                  .all(
                                                                  15),
                                                              child: ListTile(
                                                                leading:
                                                                Container(
                                                                  height: 50,
                                                                  width: 50,
                                                                  decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    boxShadow: <
                                                                        BoxShadow>[
                                                                      BoxShadow(
                                                                          color: AppTheme
                                                                              .grey
                                                                              .withOpacity(
                                                                              0.6),
                                                                          offset: const Offset(
                                                                              2.0,
                                                                              4.0),
                                                                          blurRadius: 8),
                                                                    ],
                                                                  ),
                                                                  child: ClipRRect(
                                                                    borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                        Radius
                                                                            .circular(
                                                                            60.0)),
                                                                    child: FadeInImage
                                                                        .assetNetwork(
                                                                      image: item
                                                                          .avatar !=
                                                                          null
                                                                          ? item
                                                                          .avatar
                                                                          : "",
                                                                      placeholder: 'assets/images/car.png',
                                                                      height: 40,
                                                                      width: 40,
                                                                    ),
                                                                  ),
                                                                ),
                                                                title: Text(
                                                                  item
                                                                      .first_name +
                                                                      " " +
                                                                      item
                                                                          .last_name,
                                                                  style: TextStyle(
                                                                      fontFamily: AppTheme
                                                                          .fontName,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight: FontWeight
                                                                          .w800,
                                                                      fontSize: 15),
                                                                ),
                                                                subtitle:
                                                                RatingBarIndicator(
                                                                  rating: double
                                                                      .parse(
                                                                      item
                                                                          .rating
                                                                          .toString()),
                                                                  itemBuilder: (
                                                                      context,
                                                                      index) =>
                                                                      Icon(
                                                                        Icons
                                                                            .star,
                                                                        color: Colors
                                                                            .amber,
                                                                      ),
                                                                  itemCount: 5,
                                                                  itemSize: 20.0,
                                                                  direction: Axis
                                                                      .horizontal,
                                                                ),
                                                                trailing: Visibility(
                                                                    child: RichText(
                                                                      textAlign: TextAlign
                                                                          .center,
                                                                      text: TextSpan(
                                                                        text: '',
                                                                        style: DefaultTextStyle
                                                                            .of(
                                                                            context)
                                                                            .style,
                                                                        children: <
                                                                            TextSpan>[
                                                                          TextSpan(
                                                                              text: _selectedDriverKmAway,
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight
                                                                                      .bold,
                                                                                  fontSize: 15,
                                                                                  fontFamily: AppTheme
                                                                                      .fontName)),
                                                                          TextSpan(
                                                                              text: '\nKm Away',
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight
                                                                                      .normal,
                                                                                  fontFamily: AppTheme
                                                                                      .fontName,
                                                                                  fontSize: 8)),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    visible: selectedIndex ==
                                                                        index
                                                                        ? _selectedDriverKmAway !=
                                                                        ''
                                                                        ? true
                                                                        : false
                                                                        : false),
                                                                onTap: () {
                                                                  Position startCoordinates = Position(
                                                                      latitude: _currentPosition
                                                                          .latitude,
                                                                      longitude: _currentPosition
                                                                          .longitude);
                                                                  Position destinationCoordinates = Position(
                                                                      latitude: item
                                                                          .latitude,
                                                                      longitude: item
                                                                          .longitude);
                              if (mounted) {
                                setState(() {
                                  selectedIndex =
                                      index;

                                  _selectedDriverid =
                                      item.id;
                                  _driverSourceLat =
                                      item
                                          .latitude;
                                  _driverSourceLng =
                                      item
                                          .longitude;
                                  _calculateDistance(
                                      startCoordinates,
                                      destinationCoordinates);

                                  // _createPolylines();
                                });
                              }
                                                                },
                                                              )));
                                                    })
                                            )
                                          ],
                                        ),
                                      ),
                                    ) :

                                    // Service With Money
                                    Positioned(
                                      /*Show Service Description*/
                                      bottom: 0,
                                      child: Container(
                                        color: Color.fromRGBO(
                                            255, 255, 255, 0.0),
                                        width: width,
                                        height: height * 0.35,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                                bottom: 0,
                                                child: Container(
                                                    width: width,
                                                    height: height * 0.20,
                                                    padding: const EdgeInsets
                                                        .all(
                                                        20.0),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .only(
                                                            topRight: Radius
                                                                .circular(
                                                                25.0),
                                                            topLeft: Radius
                                                                .circular(
                                                                25.0)),
                                                        color: AppTheme
                                                            .colorPrimaryDark),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .center,
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .end,
                                                      children: [
                                                        ElevatedButton(
                                                          child: Padding(
                                                            padding:
                                                            EdgeInsets.only(
                                                                left: 100,
                                                                right: 100,
                                                                top: 25,
                                                                bottom: 25),
                                                            child: Text(
                                                                "Book Now",
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
                                                            prefs =
                                                            await SharedPreferences
                                                                .getInstance(),
                                                            bloc.sendRideReq(
                                                                context,
                                                                prefs.getString(
                                                                    SharedPrefsKeys
                                                                        .ACCESS_TOKEN),
                                                                prefs.getString(
                                                                    SharedPrefsKeys
                                                                        .TOKEN_TYPE),
                                                                serviceId,
                                                                _currentPosition
                                                                    .latitude,
                                                                _currentPosition
                                                                    .longitude,
                                                                _driverSourceLat,
                                                                _driverSourceLng,
                                                                _placeDistance
                                                                ,
                                                                ""
                                                                ,
                                                                ""
                                                                ,
                                                                ""
                                                                ,
                                                                "0"
                                                                ,
                                                                "CASH"
                                                                ,
                                                                ""
                                                            ),

                                                          },
                                                        )
                                                      ],
                                                    ))),
                                            Positioned(
                                              child: Container(
                                                width: width,
                                                child: Card(
                                                    margin: EdgeInsets.only(
                                                        left: 30,
                                                        right: 30,
                                                        bottom: 20),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .all(
                                                            Radius.circular(
                                                                30))),
                                                    color: AppTheme.white,
                                                    elevation: 3,
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                          15),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize
                                                            .max,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                              mainAxisSize: MainAxisSize
                                                                  .max,
                                                              children: [
                                                                new FadeInImage
                                                                    .assetNetwork(
                                                                  placeholder:
                                                                  'assets/images/car.png',
                                                                  image: serviceImg,
                                                                  width: width *
                                                                      0.15,
                                                                  height: height *
                                                                      0.08,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        SizedBox(
                                                                          width: width *
                                                                              0.500,
                                                                          child: Padding(
                                                                              padding:
                                                                              EdgeInsets
                                                                                  .only(
                                                                                  left: 15),
                                                                              child: Text(
                                                                                serviceName,
                                                                                style: TextStyle(
                                                                                  fontSize: 15,
                                                                                  fontWeight:
                                                                                  FontWeight
                                                                                      .w800,
                                                                                  fontFamily:
                                                                                  AppTheme
                                                                                      .fontName,
                                                                                  color: AppTheme
                                                                                      .grey,
                                                                                ),
                                                                              )),
                                                                        ),
                                                                        // width * 0.20
                                                                        Padding(
                                                                          padding:
                                                                          EdgeInsets
                                                                              .only(
                                                                              left: 0),
                                                                          child: Text(
                                                                            snap
                                                                                .data ==
                                                                                null
                                                                                ? ''
                                                                                : "\$ " +
                                                                                snap
                                                                                    .data
                                                                                    .basePrice
                                                                                    .toString(),
                                                                            style: TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .w800,
                                                                              fontFamily: AppTheme
                                                                                  .fontName,
                                                                              color:
                                                                              AppTheme
                                                                                  .grey,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Padding(
                                                                        padding: EdgeInsets
                                                                            .only(
                                                                            left: 15),
                                                                        child: Text(
                                                                          subServiceName ==
                                                                              null
                                                                              ? "null"
                                                                              : subServiceName,
                                                                          style: TextStyle(
                                                                            fontSize: 12,
                                                                            fontFamily:
                                                                            AppTheme
                                                                                .fontName,
                                                                            color: AppTheme
                                                                                .grey,
                                                                          ),
                                                                        ))
                                                                  ],
                                                                ),
                                                              ])
                                                        ],
                                                      ),
                                                    )),
                                              ),
                                              bottom: height * 0.10,
                                            )
                                          ],
                                        ),
                                      ),
                                    )

                                );
                            });
                      });
                }
            )


          ],
        ),
      ),
    );
  }

  Widget statusWiseWidget(String status, CheckStatusData checkStatusData) {
    var height = MediaQuery
        .of(context)
        .size
        .height;
    var width = MediaQuery
        .of(context)
        .size
        .width;

    if (status == "SEARCHING") {
      return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(

                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),

                  SizedBox(height: 15,),
                  Text('We are looking for captain\nAcceptyour request',
                    style: TextStyle(
                        fontSize: 18, fontFamily: AppTheme.fontName),
                    textAlign: TextAlign.center,),

                ],
              ),

              Container(
                  alignment: Alignment.bottomCenter,
                  child:
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: ElevatedButton(

                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 5, bottom: 5),
                        child: Text(
                          "Cancel Request", style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,),
                      ),
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white),
                          backgroundColor:
                          MaterialStateProperty.all<Color>(
                              AppTheme.nearlyBlack),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: BorderSide(
                                      color: AppTheme.nearlyBlack)))),
                      onPressed: () async =>
                      {
                        prefs =
                        await SharedPreferences
                            .getInstance(),
                        showCupertinoDialog(
                          context: _scaffoldKey.currentContext,
                          builder: (context) =>
                              CupertinoAlertDialog(
                                content: Text(
                                    "Are you sure you want to cancel booking"),
                                actions: <Widget>[

                                  CupertinoDialogAction(
                                      child: Text("Yes"),
                                      onPressed: () =>
                                      {
                                        Navigator.of(context).pop(
                                            false),
                                        bloc.cancelTrip(_scaffoldKey.currentContext,
                                            prefs.getString(
                                                SharedPrefsKeys
                                                    .ACCESS_TOKEN),
                                            prefs.getString(
                                                SharedPrefsKeys
                                                    .TOKEN_TYPE),
                                            checkStatusData.id
                                                .toString(),
                                            _tripRating.toString())
                                      }
                                  ),
                                  CupertinoDialogAction(
                                    child: Text("No"),
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                  ),
                                ],
                              ),
                        ),


                      },
                    ),

                  )

              )

            ],
          )

      );
    } else
    if (status == "STARTED" || status == "ARRIVED" || status == "PICKEDUP") {
      return Positioned(
        /*Show Service Description*/
        bottom: 0,
        child: Container(
          color: Color.fromRGBO(255, 255, 255, 0.0),
          width: width,
          height: height * 0.65,
          child: Stack(
            children: [
              Positioned(
                  bottom: 0,
                  child: Container(
                      width: width,
                      height: height * 0.46,
                      padding: const EdgeInsets.all(
                          20.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius
                              .only(
                              topRight: Radius.circular(
                                  25.0),
                              topLeft: Radius.circular(
                                  25.0)),
                          color: AppTheme
                              .colorPrimaryDark),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center,
                        crossAxisAlignment: CrossAxisAlignment
                            .end,
                        children: [
                          ElevatedButton(
                            child: Padding(
                              padding:
                              EdgeInsets.only(left: 10,
                                  right: 10,
                                  top: 15,
                                  bottom: 15),
                              child: Text("Call Captain",
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
                                    AppTheme.white),
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
                              prefs =
                              await SharedPreferences
                                  .getInstance(),


                            },
                          ),
                          SizedBox(width: 5,),

                          Visibility(
                            visible: cancelBookingBtnVisibility(
                                checkStatusData),
                            child: ElevatedButton(
                              child: Padding(
                                padding:
                                EdgeInsets.only(left: 10,
                                    right: 10,
                                    top: 15,
                                    bottom: 15),
                                child: Text("Cancel Booking",
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
                                      AppTheme.white),
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


                                prefs =
                                await SharedPreferences
                                    .getInstance(),
                                showCupertinoDialog(
                                  context: context,
                                  builder: (context) =>
                                      CupertinoAlertDialog(
                                        content: Text(
                                            "Are you sure you want to cancel booking"),
                                        actions: <Widget>[

                                          CupertinoDialogAction(
                                              child: Text("Yes"),
                                              onPressed: () =>
                                              {
                                                Navigator.of(context).pop(
                                                    false),
                                                bloc.cancelTrip(_scaffoldKey.currentContext,
                                                    prefs.getString(
                                                        SharedPrefsKeys
                                                            .ACCESS_TOKEN),
                                                    prefs.getString(
                                                        SharedPrefsKeys
                                                            .TOKEN_TYPE),
                                                    checkStatusData.id
                                                        .toString(),
                                                    _tripRating.toString())
                                              }
                                          ),
                                          CupertinoDialogAction(
                                            child: Text("No"),
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                          ),
                                        ],
                                      ),
                                ),

                              },
                            ),
                          )
                        ],
                      ))),
              Positioned(
                child:
                Container(
                    height: height * 0.65,
                    width: width,
                    child:
                    Padding(
                      padding:

                      EdgeInsets.all(15),
                      child:
                      Column(
                        mainAxisSize: MainAxisSize
                            .max,
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          checkStatusData.provider.avatar != null ?
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                //                   <--- border color
                                width: 2.0,
                              ),
                              boxShadow: <BoxShadow>[
                                BoxShadow(color: AppTheme.grey.withOpacity(0.6),
                                    offset: const Offset(2.0, 4.0),
                                    blurRadius: 8),
                              ],
                            ),

                            child:
                            ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(60.0),),
                                child: new FadeInImage.assetNetwork(
                                  placeholder:
                                  'assets/images/userImage.png',
                                  image: checkStatusData.provider.avatar != null
                                      ? checkStatusData.provider.avatar
                                      : serviceImg,
                                  width: width * 0.25,
                                  height: height *
                                      0.12,
                                  fit: BoxFit.cover,
                                )
                            ),
                          ) :
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                //                   <--- border color
                                width: 2.0,
                              ),
                              boxShadow: <BoxShadow>[
                                BoxShadow(color: AppTheme.grey.withOpacity(0.6),
                                    offset: const Offset(2.0, 4.0),
                                    blurRadius: 8),
                              ],
                            ),

                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(60.0),),
                              child: Image.asset(
                                'assets/images/userImage.png', height: 50,
                                width: 50,

                              ),
                            ),
                          ),
                          Padding(
                              padding:
                              EdgeInsets
                                  .only(
                                  left: 15, top: 15),
                              child:
                              Text(
                                checkStatusData.provider.firstName + " " +
                                    checkStatusData.provider.lastName,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight:
                                  FontWeight.w400,
                                  fontFamily:
                                  AppTheme.fontName,
                                  color: AppTheme.white,
                                ),
                              )),
                          Padding(
                              padding: EdgeInsets
                                  .only(
                                  left: 15),
                              child:
                              Row(
                                mainAxisSize: MainAxisSize.min,

                                children: [
                                  Text(
                                    'Rating ' + checkStatusData.provider.rating,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight:
                                      FontWeight.w300,
                                      fontFamily:
                                      AppTheme.fontName,
                                      color: AppTheme.white,
                                    ),
                                  ),

                                  SizedBox(width: 5,),
                                  RatingBarIndicator(
                                    rating: 1,
                                    itemBuilder: (context,
                                        index) =>
                                        Icon(
                                          Icons.star,
                                          color: Colors
                                              .amber,
                                        ),
                                    itemCount: 1,
                                    itemSize: 20.0,
                                    direction: Axis
                                        .horizontal,
                                  ),


                                ],
                              )
                          ),

                          // Padding(
                          //     padding: EdgeInsets
                          //         .only(
                          //         left: 15),
                          //     child: Text(
                          //       serviceName,
                          //       style: TextStyle(
                          //         fontSize: 12,
                          //         fontFamily:
                          //         AppTheme
                          //             .fontName,
                          //         color: AppTheme
                          //             .grey,
                          //       ),
                          //     )),
                          Card(
                              margin: EdgeInsets.only(
                                  left: 30, right: 30, bottom: 20, top: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(30))),
                              color: AppTheme.white,
                              elevation: 3,
                              child:
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(padding: EdgeInsets.only(
                                      left: 25, right: 5, top: 10, bottom: 10),
                                    child: Text(checkStatusData.provider_service
                                        .service_number.toString()),
                                  ),

                                  Container(
                                    height: 20,
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  Padding(padding: EdgeInsets.only(
                                      left: 5, right: 25, top: 10, bottom: 10),
                                    child: Text(checkStatusData.provider_service
                                        .service_model.toString()),
                                  ),


                                ],
                              )),

                          showStatusWiseMessage(checkStatusData)

                        ],


                      ),
                    )
                ),
                bottom: height * 0.02,
              )
            ],
          ),
        ),
      );
    } else if (status == "DROPPED") {
      return Positioned(
        /*Show Service Description*/
        bottom: 0,
        child: Container(
          color: Color.fromRGBO(255, 255, 255, 0.0),
          width: width,
          height: height * 0.75,
          child: Stack(
            children: [
              Positioned(
                  bottom: 0,
                  child: Container(
                      width: width,
                      height: height * 0.50,
                      padding: const EdgeInsets.all(
                          20.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius
                              .only(
                              topRight: Radius.circular(
                                  25.0),
                              topLeft: Radius.circular(
                                  25.0)),
                          color: AppTheme
                              .colorPrimaryDark),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center,
                        crossAxisAlignment: CrossAxisAlignment
                            .end,
                        children: [
                        ],
                      ))),
              Positioned(
                child:
                Container(
                    height: height * 0.45,
                    width: width,
                    child:
                    Padding(
                      padding:

                      EdgeInsets.all(15),
                      child: Column(
                        mainAxisSize: MainAxisSize
                            .max,
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [

                          Padding(
                              padding:
                              EdgeInsets
                                  .only(
                                  left: 15, top: 15, bottom: 15),
                              child:
                              Text('Booking Id: ${checkStatusData.booking_id}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight:
                                  FontWeight.w400,
                                  fontFamily:
                                  AppTheme.fontName,
                                  color: AppTheme.white,
                                ),
                              )),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding:
                                  EdgeInsets
                                      .only(
                                      left: 15, top: 5, bottom: 15),
                                  child:
                                  Text('Base Fare',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight:
                                      FontWeight.w400,
                                      fontFamily:
                                      AppTheme.fontName,
                                      color: AppTheme.white,
                                    ),
                                  )),
                              Padding(
                                  padding:
                                  EdgeInsets
                                      .only(
                                      right: 15, top: 5, bottom: 15),
                                  child:
                                  Text('\$${checkStatusData.payment.fixed}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight:
                                      FontWeight.w400,
                                      fontFamily:
                                      AppTheme.fontName,
                                      color: AppTheme.white,
                                    ),
                                  )),


                            ],

                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding:
                                  EdgeInsets
                                      .only(
                                      left: 15, top: 5, bottom: 15),
                                  child:
                                  Text('Distance Fare',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight:
                                      FontWeight.w400,
                                      fontFamily:
                                      AppTheme.fontName,
                                      color: AppTheme.white,
                                    ),
                                  )),
                              Padding(
                                  padding:
                                  EdgeInsets
                                      .only(
                                      right: 15, top: 5, bottom: 15),
                                  child:
                                  Text('\$${checkStatusData.payment.distance}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight:
                                      FontWeight.w400,
                                      fontFamily:
                                      AppTheme.fontName,
                                      color: AppTheme.white,
                                    ),
                                  )),


                            ],

                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding:
                                  EdgeInsets
                                      .only(
                                      left: 15, top: 5, bottom: 15),
                                  child:
                                  Text('Extra Service Charege',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight:
                                      FontWeight.w400,
                                      fontFamily:
                                      AppTheme.fontName,
                                      color: AppTheme.white,
                                    ),
                                  )),
                              Padding(
                                  padding:
                                  EdgeInsets
                                      .only(
                                      right: 15, top: 5, bottom: 15),
                                  child:
                                  Text('\$${checkStatusData.payment.tax}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight:
                                      FontWeight.w400,
                                      fontFamily:
                                      AppTheme.fontName,
                                      color: AppTheme.white,
                                    ),
                                  )),


                            ],

                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding:
                                  EdgeInsets
                                      .only(
                                      left: 15, top: 5, bottom: 15),
                                  child:
                                  Text('Total',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight:
                                      FontWeight.w400,
                                      fontFamily:
                                      AppTheme.fontName,
                                      color: AppTheme.white,
                                    ),
                                  )),
                              Padding(
                                  padding:
                                  EdgeInsets
                                      .only(
                                      right: 15, top: 5, bottom: 15),
                                  child:
                                  Text('\$${checkStatusData.payment.total}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight:
                                      FontWeight.w400,
                                      fontFamily:
                                      AppTheme.fontName,
                                      color: AppTheme.white,
                                    ),
                                  )),


                            ],

                          ),

                          Divider(color: Colors.white24,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding:
                                  EdgeInsets
                                      .only(
                                      left: 15, top: 5, bottom: 15),
                                  child:
                                  Text('Amount to be paid',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight:
                                      FontWeight.w400,
                                      fontFamily:
                                      AppTheme.fontName,
                                      color: AppTheme.white,
                                    ),
                                  )),
                              Padding(
                                  padding:
                                  EdgeInsets
                                      .only(
                                      right: 15, top: 5, bottom: 15),
                                  child:
                                  Text('\$${checkStatusData.payment.payable}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight:
                                      FontWeight.w800,
                                      fontFamily:
                                      AppTheme.fontName,
                                      color: AppTheme.white,
                                    ),
                                  )),


                            ],

                          ),

                          showStatusWiseMessage(checkStatusData)

                        ],


                      ),
                    )
                ),
                bottom: height * 0.02,
              )
            ],
          ),
        ),
      );
    } else if (status == "COMPLETED") {
      return Positioned(
        /*Show Service Description*/
        bottom: 0,
        child: Container(
          color: Color.fromRGBO(255, 255, 255, 0.0),
          width: width,
          height: height * 0.65,
          child: Stack(
            children: [
              Positioned(
                  bottom: 0,
                  child: Container(
                      width: width,
                      height: height * 0.56,
                      padding: const EdgeInsets.all(
                          20.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius
                              .only(
                              topRight: Radius.circular(
                                  25.0),
                              topLeft: Radius.circular(
                                  25.0)),
                          color: AppTheme
                              .colorPrimaryDark),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center,
                        crossAxisAlignment: CrossAxisAlignment
                            .end,
                        children: [
                          ElevatedButton(
                            child: Padding(
                              padding:
                              EdgeInsets.only(left: 30,
                                  right: 30,
                                  top: 15,
                                  bottom: 15),
                              child: Text("Submit",
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
                                    AppTheme.white),
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
                              prefs =
                              await SharedPreferences
                                  .getInstance(),

                              bloc.rateYourTrip(context, prefs.getString(
                                  SharedPrefsKeys
                                      .ACCESS_TOKEN),
                                  prefs.getString(
                                      SharedPrefsKeys
                                          .TOKEN_TYPE),
                                  checkStatusData.id.toString(),
                                  _tripRating.toString())
                            },
                          ),

                          /*SizedBox(width: 5,),

                          ElevatedButton(
                            child: Padding(
                              padding:
                              EdgeInsets.only(left: 10,
                                  right: 10,
                                  top: 15,
                                  bottom: 15),
                              child: Text("SMS",
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
                                    AppTheme.white),
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
                              prefs =
                              await SharedPreferences
                                  .getInstance(),


                            },
                          )*/
                        ],
                      ))),
              Positioned(
                child: Container(
                    height: height * 0.65,
                    width: width,
                    child:
                    Padding(
                      padding:

                      EdgeInsets.all(15),
                      child: Column(
                        mainAxisSize: MainAxisSize
                            .max,
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [

                          Padding(
                              padding:
                              EdgeInsets
                                  .only(
                                  left: 15, top: 15, bottom: 15),
                              child:
                              Text(
                                'Rate your Captain',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight:
                                  FontWeight.w400,
                                  fontFamily:
                                  AppTheme.fontName,
                                  color: AppTheme.white,
                                ),
                              )),

                          checkStatusData.provider.avatar != null ?
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                //                   <--- border color
                                width: 2.0,
                              ),
                              boxShadow: <BoxShadow>[
                                BoxShadow(color: AppTheme.grey.withOpacity(0.6),
                                    offset: const Offset(2.0, 4.0),
                                    blurRadius: 8),
                              ],
                            ),

                            child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(60.0),),
                                child: new FadeInImage.assetNetwork(
                                  placeholder:
                                  'assets/images/userImage.png',
                                  image: checkStatusData.provider.avatar != null
                                      ? checkStatusData.provider.avatar
                                      : serviceImg,
                                  width: width * 0.25,
                                  height: height *
                                      0.12,
                                  fit: BoxFit.cover,
                                )
                            ),
                          ) :
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                //                   <--- border color
                                width: 2.0,
                              ),
                              boxShadow: <BoxShadow>[
                                BoxShadow(color: AppTheme.grey.withOpacity(0.6),
                                    offset: const Offset(2.0, 4.0),
                                    blurRadius: 8),
                              ],
                            ),

                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(60.0),),
                              child: Image.asset(
                                'assets/images/userImage.png', height: 50,
                                width: 50,

                              ),
                            ),
                          ),
                          Padding(
                              padding:
                              EdgeInsets
                                  .only(
                                  left: 15, top: 15),
                              child:
                              Text(
                                checkStatusData.provider.firstName + " " +
                                    checkStatusData.provider.lastName,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight:
                                  FontWeight.w400,
                                  fontFamily:
                                  AppTheme.fontName,
                                  color: AppTheme.white,
                                ),
                              )),
                          Padding(
                              padding: EdgeInsets
                                  .only(
                                  left: 15),
                              child:
                              Row(
                                mainAxisSize: MainAxisSize.min,

                                children: [
                                  Text(
                                    'Rating ' + checkStatusData.provider.rating,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight:
                                      FontWeight.w300,
                                      fontFamily:
                                      AppTheme.fontName,
                                      color: AppTheme.white,
                                    ),
                                  ),

                                  SizedBox(width: 5,),
                                  RatingBarIndicator(
                                    rating: 1,
                                    itemBuilder: (context,
                                        index) =>
                                        Icon(
                                          Icons.star,
                                          color: Colors
                                              .amber,
                                        ),
                                    itemCount: 1,
                                    itemSize: 20.0,
                                    direction: Axis
                                        .horizontal,
                                  ),


                                ],
                              )
                          ),

                          Card(
                              margin: EdgeInsets.only(
                                  left: 30, right: 30, bottom: 20, top: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(30))),
                              color: AppTheme.white,
                              elevation: 3,
                              child:
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(padding: EdgeInsets.only(
                                      left: 25, right: 5, top: 10, bottom: 10),
                                    child: Text(checkStatusData.provider_service
                                        .service_number.toString()),
                                  ),

                                  Container(
                                    height: 20,
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  Padding(padding: EdgeInsets.only(
                                      left: 5, right: 25, top: 10, bottom: 10),
                                    child: Text(checkStatusData.provider_service
                                        .service_model.toString()),
                                  ),


                                ],
                              )),

                          RatingBar(
                            initialRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemSize: 30.0,
                            itemCount: 5,
                            minRating: 1,

                            ratingWidget: RatingWidget(
                              full: Image.asset('assets/images/star-filled.png',
                                color: Colors.amber,),
                              empty: Image.asset('assets/images/start.png',
                                  color: Colors.amber),
                            ),
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            onRatingUpdate: (rating) {
                              if (mounted) {
                                setState(() {
                                  _tripRating = rating.toInt();
                                });
                              }
                              print(rating);
                            },
                          ),
                          showStatusWiseMessage(checkStatusData)

                        ],


                      ),
                    )
                ),
                bottom: height * 0.02,
              )
            ],
          ),
        ),
      );
    } else {
      return Wrap();
    }
  }

  bool cancelBookingBtnVisibility(CheckStatusData checkStatusData) {
    if (checkStatusData.status == "STARTED") {
      return true;
    }
    else if (checkStatusData.status == "ARRIVED") {
      return true;
    } else if (checkStatusData.status == "PICKEDUP") {
      return false;
    } else if (checkStatusData.status == "DROPPED") {
      return false;
    } else {
      return false;
    }
  }

  Widget showStatusWiseMessage(CheckStatusData checkStatusData) {
    if (checkStatusData.status == "STARTED") {
      return Padding(
        padding: EdgeInsets.only(left: 55, right: 55, top: 10, bottom: 10),
        child: Text('Your Captain ${checkStatusData.provider
            .firstName} is on his way to pickup.', style: TextStyle(
            fontFamily: AppTheme.fontName, color: AppTheme.white, fontSize: 18),
          textAlign: TextAlign.center,),
      );
    }
    else if (checkStatusData.status == "ARRIVED") {
      return Padding(
        padding: EdgeInsets.only(left: 55, right: 55, top: 10, bottom: 10),
        child: Text('Your Captain ${checkStatusData.provider
            .firstName} is arrived at your location.', style: TextStyle(
            fontFamily: AppTheme.fontName, color: AppTheme.white, fontSize: 18),
          textAlign: TextAlign.center,),
      );
    } else if (checkStatusData.status == "PICKEDUP") {
      return Padding(
        padding: EdgeInsets.only(left: 55, right: 55, top: 10, bottom: 10),
        child: Text('Your Captain ${checkStatusData.provider
            .firstName}  picked you at your location.', style: TextStyle(
            fontFamily: AppTheme.fontName, color: AppTheme.white, fontSize: 18),
          textAlign: TextAlign.center,),
      );
    } else if (checkStatusData.status == "DROPPED") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
              padding:
              EdgeInsets
                  .only(
                  left: 15, top: 5, bottom: 15),
              child:
              Text('Payment Mode ${checkStatusData.payment_mode}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight:
                  FontWeight.w400,
                  fontFamily:
                  AppTheme.fontName,
                  color: AppTheme.white,
                ),
              )),
          Padding(
              padding:
              EdgeInsets
                  .only(
                  right: 15, top: 5, bottom: 15),
              child:
              Text('',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight:
                  FontWeight.w400,
                  fontFamily:
                  AppTheme.fontName,
                  color: AppTheme.white,
                ),
              )),


        ],

      );
    } else {
      return Wrap();
    }
  }

  Widget showServiceLayout() {
    var height = MediaQuery
        .of(context)
        .size
        .height;
    var width = MediaQuery
        .of(context)
        .size
        .width;
    return
      StreamBuilder<ApproximatePriceRespo>(
          stream: bloc.subjectApproximatePriceList.stream,
          builder: (context, snap) {
            return snap.data == null
                ?
            !isShowProviders ?
            Positioned(
              /*Show Service Description*/
              bottom: 0,
              child: Container(
                color: Color.fromRGBO(255, 255, 255, 0.0),
                width: width,
                height: height * 0.35,
                child: Stack(
                  children: [
                    Positioned(
                        bottom: 0,
                        child: Container(
                            width: width,
                            height: height * 0.20,
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(25.0),
                                    topLeft: Radius.circular(25.0)),
                                gradient: LinearGradient(
                                    begin: FractionalOffset.topCenter,
                                    end: FractionalOffset.centerRight,
                                    colors: [AppTheme.colorPrimaryDark, AppTheme.colorPrimary]),
                                color: AppTheme.colorPrimaryDark),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  child: Padding(
                                    padding:
                                    EdgeInsets.only(left: 100,
                                        right: 100,
                                        top: 25,
                                        bottom: 25),
                                    child: Text("Continue",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontFamily: AppTheme.fontName)),
                                  ),
                                  style: ButtonStyle(
                                      foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                      backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          AppTheme.white),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(25),
                                              side: BorderSide(
                                                  color: AppTheme.white)))),
                                  onPressed: () async =>
                                  {
                                    prefs =
                                    await SharedPreferences.getInstance(),
                                    bloc.fetchAllproviderListReq(
                                        context,
                                        prefs.getString(
                                            SharedPrefsKeys.ACCESS_TOKEN),
                                        prefs.getString(
                                            SharedPrefsKeys.TOKEN_TYPE),
                                        serviceId,
                                        _currentPosition.latitude,
                                        _currentPosition.longitude),
/*
                                    if(bloc.subjectProvidersList.stream
                                        .hasValue){

*/
/*
                                      setState(() {
                                        isShowProviders = true;
                                      }),
*//*


                                    }
*/
                                  },
                                )
                              ],
                            ))),
                    Positioned(
                      child: Container(
                        width: width,
                        child: Card(
                            margin: EdgeInsets.only(
                                left: 30, right: 30, bottom: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(30))),
                            color: AppTheme.white,
                            elevation: 3,
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        new FadeInImage.assetNetwork(
                                          placeholder:
                                          'assets/images/car.png',
                                          image: serviceImg,
                                          width: width * 0.15,
                                          height: height * 0.08,
                                          fit: BoxFit.cover,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .center,
                                              children: [
                                                SizedBox(
                                                  width: width * 0.500,
                                                  child: Padding(
                                                      padding:
                                                      EdgeInsets.only(
                                                          left: 15),
                                                      child: Text(
                                                        serviceName,
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                          FontWeight
                                                              .w800,
                                                          fontFamily:
                                                          AppTheme
                                                              .fontName,
                                                          color: AppTheme
                                                              .grey,
                                                        ),
                                                      )),
                                                ),
                                                // width * 0.20
                                              ],
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: 15),
                                                child: Text(
                                                  subServiceName == null
                                                      ? "null"
                                                      : subServiceName,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily:
                                                    AppTheme.fontName,
                                                    color: AppTheme.grey,
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ])
                                ],
                              ),
                            )),
                      ),
                      bottom: height * 0.10,
                    )
                  ],
                ),
              ),
            ) : Text('')

                :
            Positioned(
              /*Show Service Description*/
              bottom: 0,
              child: Container(
                color: Color.fromRGBO(255, 255, 255, 0.0),
                width: width,
                height: height * 0.35,
                child: Stack(
                  children: [
                    Positioned(
                        bottom: 0,
                        child: Container(
                            width: width,
                            height: height * 0.20,
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(25.0),
                                    topLeft: Radius.circular(25.0)),
                                gradient: LinearGradient(
                                    begin: FractionalOffset.topCenter,
                                    end: FractionalOffset.centerRight,
                                    colors: [AppTheme.colorPrimaryDark, AppTheme.colorPrimary]),
                                color: AppTheme.colorPrimaryDark),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  child: Padding(
                                    padding:
                                    EdgeInsets.only(left: 100,
                                        right: 100,
                                        top: 25,
                                        bottom: 25),
                                    child: Text("Continue",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontFamily: AppTheme.fontName)),
                                  ),
                                  style: ButtonStyle(
                                      foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                      backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          AppTheme.white),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(25),
                                              side: BorderSide(
                                                  color: AppTheme.white)))),
                                  onPressed: () async =>
                                  {
                                    prefs =
                                    await SharedPreferences.getInstance(),
                                    bloc.fetchAllproviderListReq(
                                        context,
                                        prefs.getString(
                                            SharedPrefsKeys.ACCESS_TOKEN),
                                        prefs.getString(
                                            SharedPrefsKeys.TOKEN_TYPE),
                                        serviceId,
                                        _currentPosition.latitude,
                                        _currentPosition.longitude),


                                  },
                                )
                              ],
                            ))),
                    Positioned(
                      child: Container(
                        width: width,
                        child: Card(
                            margin: EdgeInsets.only(
                                left: 30, right: 30, bottom: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(30))),
                            color: AppTheme.white,
                            elevation: 3,
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        new FadeInImage.assetNetwork(
                                          placeholder:
                                          'assets/images/car.png',
                                          image: serviceImg,
                                          width: width * 0.15,
                                          height: height * 0.08,
                                          fit: BoxFit.cover,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .center,
                                              children: [
                                                SizedBox(
                                                  width: width * 0.500,
                                                  child: Padding(
                                                      padding:
                                                      EdgeInsets.only(
                                                          left: 15),
                                                      child: Text(
                                                        serviceName,
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                          FontWeight
                                                              .w800,
                                                          fontFamily:
                                                          AppTheme
                                                              .fontName,
                                                          color: AppTheme
                                                              .grey,
                                                        ),
                                                      )),
                                                ),
                                                // width * 0.20
                                                Padding(
                                                  padding:
                                                  EdgeInsets.only(
                                                      left: 0),
                                                  child: Text(
                                                    snap.data.basePrice == 0
                                                        ? ''
                                                        : "\$ " +
                                                        snap.data.basePrice
                                                            .toString(),
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                      FontWeight.w800,
                                                      fontFamily: AppTheme
                                                          .fontName,
                                                      color:
                                                      AppTheme.grey,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: 15),
                                                child: Text(
                                                  subServiceName == null
                                                      ? "null"
                                                      : subServiceName,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily:
                                                    AppTheme.fontName,
                                                    color: AppTheme.grey,
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ])
                                ],
                              ),
                            )),
                      ),
                      bottom: height * 0.10,
                    )
                  ],
                ),
              ),
            );
          });
  }

  Widget chooseRandomButton() =>
      StreamBuilder<ProvidersListResponse>(
          stream: bloc.subjectProvidersList.stream,
          builder: (context, snap) {
            return ElevatedButton(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 20, right: 20, top: 15, bottom: 15),
                child: Text("Random ",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontFamily: AppTheme.fontName)),
              ),
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      AppTheme.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: BorderSide(color: AppTheme.white)))),
              onPressed: () async =>
              {
                prefs = await SharedPreferences.getInstance(),
                bloc.fetchAllproviderListReq(
                    context,
                    prefs.getString(SharedPrefsKeys.ACCESS_TOKEN),
                    prefs.getString(SharedPrefsKeys.TOKEN_TYPE),
                    serviceId,
                    _currentPosition.latitude,
                    _currentPosition.longitude),
              if (mounted) {

                setState(() {
                  this.allProviderList = snap.data.allServicesList;
                }),
              }
              },
            );
          });

  @override
  void dispose() {
    super.dispose();

    bloc.unSubscribeEvents();
    timer?.cancel();
  }

}


class Utils {
  static String mapStyles = '''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]''';
}

import 'package:cbx_driver/HomePage/location_type_screen.dart';
import 'package:cbx_driver/HomePage/map_locationpicker.dart';
import 'package:cbx_driver/HomePage/tyrecarselect_screen.dart';
import 'package:cbx_driver/Modals/AllServicesModel.dart';
import 'package:cbx_driver/Modals/AllSubServicesModel.dart';
import 'package:cbx_driver/Modals/categorieslist.dart';
import 'package:cbx_driver/Modals/services_response.dart';
import 'package:cbx_driver/Modals/sub_services_response.dart';
import 'package:cbx_driver/Utils/helperutils.dart';
import 'package:cbx_driver/bloc/LoginBloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_theme.dart';

class EnterVehicleDetails extends StatefulWidget {
  EnterVehicleDetails(
      {Key key,
      this.serviceName,
      this.serviceId,
      this.subServiceId,
      this.subServiceName,
      this.locationType,
      this.serviceImg})
      : super(key: key);

  final serviceName;
  final serviceImg;
  final serviceId;
  final subServiceId;
  final subServiceName;
  final locationType;

  @override
  _EnterVehicleDetailsState createState() => _EnterVehicleDetailsState(
      this.serviceName,
      this.serviceId,
      this.subServiceId,
      this.subServiceName,
      this.locationType,
      this.serviceImg);
}

class _EnterVehicleDetailsState extends State<EnterVehicleDetails>
    with TickerProviderStateMixin {
  _EnterVehicleDetailsState(this.serviceName, this.serviceId, this.subServiceId,
      this.subServiceName, this.locationType, this.serviceImg);

  List<CategoriesList> categoriesList = CategoriesList.categoriesList;
  AnimationController animationController;
  bool multiple = true;
  final _vinNumberController = TextEditingController();
  final _makeController = TextEditingController();
  final _modalController = TextEditingController();
  final _colorController = TextEditingController();
  final _platNumberController = TextEditingController();

  String serviceId;
  String serviceName;
  String subServiceId;
  String subServiceName;
  String locationType;
  String serviceImg;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();

    print(serviceId);

    initPreferences();
  }

  Future<void> initPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: AppTheme.white,
          elevation: 0,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                this.serviceName == '' ? 'CBX' : this.serviceName,
                style: TextStyle(
                  fontSize: 20,
                  color: AppTheme.darkText,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Enter Vehicle Details',
                style: TextStyle(
                  fontSize: 15,
                  color: AppTheme.darkText,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        ),
        backgroundColor: AppTheme.white,
        body: SingleChildScrollView(
          child: Container(
              height: size.height,
              color: AppTheme.white,
              child: Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 0, left: 20, right: 20),
                        child: Center(
                          child: Text(
                            'Please fill all the details carefully so that we assist you better.',
                            style: TextStyle(
                              fontSize: 15,
                              color: AppTheme.darkText,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )),
/*                    Padding(
                      padding: EdgeInsets.only(
                          top: 10, left: 20, right: 20, bottom: 5),
                      child: TextField(
                        controller: _vinNumberController,
                        keyboardType: TextInputType.text,
                        cursorColor: AppTheme.nearlyBlack,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            hintText: "17-Character VIN Number",
                            hintStyle: new TextStyle(
                                color: AppTheme.darkerText,
                                fontFamily: AppTheme.fontName,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                            labelStyle: new TextStyle(
                                color: const Color(0xFF424242),
                                fontFamily: AppTheme.fontName,
                                fontSize: 15),
                            border: new UnderlineInputBorder(
                                borderSide: new BorderSide(color: Colors.red))),
                      ),
                    ),*/
                    Padding(
                      padding: EdgeInsets.only(
                          top: 10, left: 20, right: 20, bottom: 5),
                      child: TextField(
                        textInputAction: TextInputAction.next,
                        controller: _makeController,
                        keyboardType: TextInputType.text,
                        cursorColor: AppTheme.nearlyBlack,
                        decoration: InputDecoration(
                            hintText: "Year",
                            hintStyle: new TextStyle(
                                color: AppTheme.darkerText,
                                fontFamily: AppTheme.fontName,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                            labelStyle: new TextStyle(
                                color: const Color(0xFF424242),
                                fontFamily: AppTheme.fontName,
                                fontSize: 15),
                            border: new UnderlineInputBorder(
                                borderSide: new BorderSide(color: Colors.red))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 10, left: 20, right: 20, bottom: 5),
                      child: TextField(
                        textInputAction: TextInputAction.next,
                        controller: _modalController,
                        keyboardType: TextInputType.text,
                        cursorColor: AppTheme.nearlyBlack,
                        decoration: InputDecoration(
                            hintText: "Modal",
                            hintStyle: new TextStyle(
                                color: AppTheme.darkerText,
                                fontFamily: AppTheme.fontName,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                            labelStyle: new TextStyle(
                                color: const Color(0xFF424242),
                                fontFamily: AppTheme.fontName,
                                fontSize: 15),
                            border: new UnderlineInputBorder(
                                borderSide: new BorderSide(color: Colors.red))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 10, left: 20, right: 20, bottom: 5),
                      child: TextField(
                        textInputAction: TextInputAction.next,
                        controller: _colorController,
                        keyboardType: TextInputType.text,
                        cursorColor: AppTheme.nearlyBlack,
                        decoration: InputDecoration(
                            hintText: "Color",
                            hintStyle: new TextStyle(
                                color: AppTheme.darkerText,
                                fontFamily: AppTheme.fontName,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                            labelStyle: new TextStyle(
                                color: const Color(0xFF424242),
                                fontFamily: AppTheme.fontName,
                                fontSize: 15),
                            border: new UnderlineInputBorder(
                                borderSide: new BorderSide(color: Colors.red))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 10, left: 20, right: 20, bottom: 5),
                      child: TextField(
                        textInputAction: TextInputAction.done,
                        controller: _platNumberController,
                        keyboardType: TextInputType.text,
                        cursorColor: AppTheme.nearlyBlack,
                        decoration: InputDecoration(
                            hintText: "Plat Number",
                            hintStyle: new TextStyle(
                                color: AppTheme.darkerText,
                                fontFamily: AppTheme.fontName,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                            labelStyle: new TextStyle(
                                color: const Color(0xFF424242),
                                fontFamily: AppTheme.fontName,
                                fontSize: 15),
                            border: new UnderlineInputBorder(
                                borderSide: new BorderSide(color: Colors.red))),
                      ),
                    ),
                  ],
                ),
              )),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20, left: 50, right: 50),
          child: ElevatedButton(
            child: Padding(
              padding: EdgeInsets.only(left: 0, right: 0, top: 20, bottom: 20),
              child: Text("Continue", style: TextStyle(fontSize: 14)),
            ),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor:
                    MaterialStateProperty.all<Color>(AppTheme.colorPrimary),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(color: AppTheme.colorPrimary)))),
            onPressed: () async => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return MapView(
                        serviceName: this.serviceName,
                        serviceId: this.serviceId,
                        subServiceId: this.subServiceId,
                        subServiceName: this.subServiceName,
                        locationType: this.locationType,
                        serviceImg: this.serviceImg);
                  },
                ),
              )

/*
              Navigator.push<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => MapView(
                      serviceName: this.serviceName
                      ,serviceId: this.serviceId
                      ,subServiceId: this.subServiceId
                      ,subServiceName: this.subServiceName
                      ,locationType:this.locationType
                      ,serviceImg:this.serviceImg

                  ),
                ),
              )
*/
            },
          ),
        ));
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
}

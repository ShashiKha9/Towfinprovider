import 'package:cbx_driver/HomePage/location_type_screen.dart';
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
import 'enter_vehicle_details.dart';

class TyreSelectScreen extends StatefulWidget {
  TyreSelectScreen(
      {Key key, this.serviceName, this.serviceId, this.subServiceId,this.subServiceName,this.locationType,this.serviceImg
      })
      : super(key: key);

  final serviceName;
  final serviceId;
  final subServiceId;
  final subServiceName;
  final serviceImg;
  final locationType;

  @override
  _TyreSelectScreenState createState() => _TyreSelectScreenState(
      this.serviceName, this.serviceId, this.subServiceId,this.subServiceName,this.locationType,this.serviceImg);
}

class _TyreSelectScreenState extends State<TyreSelectScreen>
    with TickerProviderStateMixin {
  _TyreSelectScreenState(this.serviceName, this.serviceId, this.subServiceId,this.subServiceName,this.locationType,this.serviceImg);

  List<CategoriesList> categoriesList = CategoriesList.categoriesList;
  AnimationController animationController;
  bool multiple = true;

  String serviceId;
  String serviceImg;
  String serviceName;
  String subServiceId;
  String subServiceName;
  String locationType;

  double _tireOneOpacity = 0.5;
  double _tireTwoOpacity = 0.5;
  double _tireThreeOpacity = 0.5;
  double _tirefourOpacity = 0.5;
  bool isTowService = false;

  int _radioValue1 = -1;
  int _radioValue2 = -1;
  int _tireselectionCount = 0;

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
        title: Text(
          this.serviceName == '' ? 'CBX' : this.serviceName,
          style: TextStyle(
            fontSize: 22,
            color: AppTheme.darkText,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      backgroundColor: AppTheme.white,
      body:
      SingleChildScrollView(

        child:       Container(
          height: size.height,
            color: AppTheme.white,
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 0, left: 20),
                      child: Center(
                        child: Text(
                          'How many tires need to replacement?',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppTheme.darkText,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {

                                if(_tireOneOpacity==0.5){
                                  _tireOneOpacity = 1;
                                  _tireselectionCount++;
                                }
                                else{
                                  _tireOneOpacity = 0.5;
                                  _tireselectionCount--;
                                }

                                if(_tireselectionCount>1){
                                  isTowService = true;
                                  _radioValue1=1;

                                }else{
                                  isTowService = false;
                                  _radioValue1=0;

                                }

                              });
                            },
                            child:
                          Padding(padding: EdgeInsets.all(15),
                            child:
                            Opacity(
                              opacity: _tireOneOpacity,
                              child:  Image.asset("assets/images/selected_tyre.png", width: size.width*0.15,height: size.height*0.15,
                              ),

                            )

                          ),
                          ),

                          SizedBox(height: size.height/5,),

                          InkWell(
                            onTap: (){
                              setState(() {

                                if(_tireTwoOpacity==0.5) {
                                  _tireTwoOpacity = 1;
                                  _tireselectionCount++;

                                }
                                else {

                                  _tireTwoOpacity = 0.5;
                                  _tireselectionCount--;

                                }

                                if(_tireselectionCount>1){
                                  isTowService = true;
                                  _radioValue1=1;

                                }else{
                                  isTowService = false;
                                  _radioValue1=0;

                                }


                              });
                            },
                            child:
                          Padding(padding: EdgeInsets.all(15),
                            child:


                            Opacity(
                              opacity: _tireTwoOpacity,
                              child:
                              Image.asset("assets/images/selected_tyre.png", width: size.width*0.15,height: size.height*0.15,),
                          ),
                          ),
                          )


                        ],
                      ),

                      Image.asset("assets/images/car.png", width: size.width*0.35,height: size.height*0.35,),


                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {

                                if(_tireThreeOpacity==0.5) {
                                  _tireThreeOpacity = 1;
                                  _tireselectionCount++;

                                }
                                else{ _tireThreeOpacity = 0.5;
                                _tireselectionCount--;

                                }


                                if(_tireselectionCount>1){
                                  isTowService = true;
                                  _radioValue1=1;

                                }else{
                                  isTowService = false;
                                  _radioValue1=0;

                                }

                              });
                            },
                            child:
                          Padding(padding: EdgeInsets.all(15),
                            child:
                            Opacity(
                              opacity: _tireThreeOpacity,
                              child:
                              Image.asset("assets/images/selected_tyre.png", width: size.width*0.15,height: size.height*0.15,),
                          ),
                          ),
                          ),

                          SizedBox(height: size.height/5,),
                          InkWell(
                            onTap: (){
                              setState(() {

                                if(_tirefourOpacity==0.5){
                                  _tireselectionCount++;

                                  _tirefourOpacity = 1;}
                                else {
                                  _tireselectionCount--;

                                  _tirefourOpacity = 0.5;
                                }

                                if(_tireselectionCount>1){
                                  isTowService = true;
                                  _radioValue1=1;
                                }else{
                                  isTowService = false;
                                  _radioValue1=0;

                                }

                              });
                            },
                            child: Padding(padding: EdgeInsets.all(15),
                              child:
                              Opacity(
                                opacity: _tirefourOpacity,
                                child:
                                Image.asset("assets/images/selected_tyre.png", width: size.width*0.15,height: size.height*0.15,),
                              ),
                            )


                          )


                        ],
                      )


                    ],
                  ),



                  Visibility(
                    visible: !isTowService,
                    child:
                    Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(top: 0, left: 20),
                            child: Center(
                              child: Text(
                                'Do you have spare tire?',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: AppTheme.fontName,
                                  color: AppTheme.darkText,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )),

                        new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Radio(
                              value: 0,
                              groupValue: _radioValue1,
                              onChanged: _handleRadioValueChange1,
                            ),
                            new Text(
                              'Yes',
                              style: new TextStyle(fontSize: 16.0),
                            ),
                            new Radio(
                              value: 1,
                              groupValue: _radioValue1,
                              onChanged: _handleRadioValueChange1,
                            ),
                            new Text(
                              'No',
                              style: new TextStyle(
                                fontSize: 16.0,
                              ),
                            ),

                          ],
                        ),

                      ],
                    )
                  ),
                  Visibility(
                    visible: isTowService,
                    child: Padding(
                        padding: EdgeInsets.only(top: 0, left: 20),
                        child:

                        Center(
                          child:
                          Column(
                            children: [
                              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 50,),

                              SizedBox(height: 10,),
                              Text(
                                'Your service is being changed\nto crane request.\nDo you want to proceed?',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: AppTheme.fontName,
                                  color: AppTheme.darkText,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),

                            ],
                          )

                        )),

                  )


                ],
              ),
            )),

      ),
        bottomNavigationBar:  Padding(
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
              Navigator.push<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => EnterVehicleDetails(
                    serviceName: serviceName,
                    serviceId: serviceId,
                    subServiceId: subServiceId,
                    serviceImg: serviceImg,
                    subServiceName: subServiceName,
                  ),
                ),
              )
            },
          ),
        )


    );


  }

  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioValue1 = value;
      if(_radioValue1==0) isTowService = false;
      else isTowService = true;
    });
  }

  void _handleRadioValueChange2(int value) {
    setState(() {
      _radioValue2 = value;

    });
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

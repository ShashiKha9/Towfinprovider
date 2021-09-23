import 'dart:convert';
import 'dart:io';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:cbx_driver/HomePage/change_password.dart';
import 'package:cbx_driver/Utils/helperutils.dart';
import 'package:cbx_driver/bloc/UserProfileBloc.dart';
import 'package:cbx_driver/components/rounded_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_theme.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class EditAccount extends StatefulWidget {
  const EditAccount({
    Key key}) : super(key: key);


  @override
  _EditAccountState createState() =>
      _EditAccountState(

      );
}

class _EditAccountState extends State<EditAccount>
    with TickerProviderStateMixin {
  _EditAccountState();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
var _imageFile;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileNumController = TextEditingController();
  final _emailaddressController = TextEditingController();




  @override
  void initState() {

    super.initState();


    initPreferences();

    _mobileNumController.addListener(_printLatestValue);


  }

  Future<void> initPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _firstNameController.text = prefs.getString(SharedPrefsKeys.FIRST_NAME);
    _lastNameController.text = prefs.getString(SharedPrefsKeys.LAST_NAME);
    _mobileNumController.text = prefs.getString(SharedPrefsKeys.MOBILE);
    _emailaddressController.text = prefs.getString(SharedPrefsKeys.EMAIL_ADDRESS);

    setState(() {

    });

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
      key:_scaffoldKey,
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: IconThemeData(
          color: AppTheme.white, //change your color here
        ),

        title: Column(
          children: [
            Text(
              'Edit Profile',
              style: TextStyle(
                fontSize: 20,
                color: AppTheme.white,
                fontWeight: FontWeight.w400,
              ),
            ),

          ],
        ),
        elevation: 0,
        backgroundColor: AppTheme.colorPrimary,
      ),
      body: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


                SizedBox(height: 20,),

                Center(
                  child:_imageFile != null
                      ? Stack(children: <Widget>[
                    Container(
                        height: 80,
                        width: 80,

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: <BoxShadow>[
                            BoxShadow(color: AppTheme.grey.withOpacity(0.6), offset: const Offset(2.0, 4.0), blurRadius: 8),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(60.0)),

                          child:Image.file(_imageFile,
                              fit: BoxFit.cover),

                        )),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        width: 80,
                        height: 25,

                        alignment: Alignment.bottomCenter,
                        color: AppTheme.nearlyBlack,
                        child: FlatButton(
                          onPressed: () {
                            _showSelectionDialog(context);
                          },
                          child: Center(
                              child: Text("Edit",
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontFamily:
                                      AppTheme.fontName,
                                      color: Colors.white,
                                      backgroundColor: AppTheme
                                          .nearlyBlack))),
                        ),
                      ),
                    )
                  ])
                      :
                  Stack(children: [

                    Container(
                        height: 80,
                        width: 80,

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: <BoxShadow>[
                            BoxShadow(color: AppTheme.grey.withOpacity(0.6), offset: const Offset(2.0, 4.0), blurRadius: 8),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(60.0)),

                          child: Image.asset(
                            "assets/images/userImage.png",
                            fit: BoxFit.contain,
                            height: 80,
                            width: 80,
                            alignment: Alignment.center,
                          ),

                        )),

                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        width: 80,
                        height: 25,
                        alignment: Alignment.bottomCenter,
                        color: AppTheme.nearlyBlack,
                        child: FlatButton(
                          onPressed: () {
                            _showSelectionDialog(context);
                          },
                          child: Center(
                              child: Text("Edit",
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontFamily:
                                      AppTheme.fontName,
                                      color: Colors.white,
                                      backgroundColor: AppTheme
                                          .nearlyBlack))),
                        ),
                      ),
                    )

                  ],),

                ),





                Visibility(
                  visible: false,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 20, bottom: 20),
                    child: Text("Your Details",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 20,
                            color: AppTheme.darkerText,
                            fontWeight: FontWeight.w800,
                            fontFamily: "WorkSans")),
                  ),
                ),


                Padding(
                  padding: EdgeInsets.only(left: 25, right: 25,top:20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("First Name",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.darkerText,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppTheme.fontName)),

                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 25, right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: size.width * 0.8,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: new TextField(
                          controller: _firstNameController,
                          inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[a-zA-Z ]")),],

                          decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            hintText: 'First Name',
                          ),
                        ),
                      ),

                    ],
                  ),
                ),



                Padding(
                  padding: EdgeInsets.only(left: 25, right: 25,top:25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Last Name",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.darkerText,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppTheme.fontName)),

                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 25, right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: size.width * 0.8,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: new TextField(
                          controller: _lastNameController,
                          inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[a-zA-Z ]")),],

                          decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.grey),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                            ),
                            hintText: 'Last Name',
                          ),
                        ),
                      ),

                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 30, left: 25, right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Mobile Number",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.darkerText,
                              fontWeight: FontWeight.w600,
                              fontFamily: "WorkSans")),

                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 25, right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: size.width * 0.8,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(10),

                        ),

                        child:
                        new TextField(
                          autofocus: true,
                          inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[0-9]")),],

                          controller: _mobileNumController,
                         /* onChanged: (text) {

                            // setState(() {
                            //   _mobileNumController.text = text;



                            // });

                            print("First text field: $text");


                          },*/

                          keyboardType: TextInputType.numberWithOptions(
                              signed: false, decimal: false),
                          decoration: new InputDecoration(
                            // suffix: RawMaterialButton(
                            //   constraints: BoxConstraints(),
                            //   padding: EdgeInsets.all(5.0),
                            //   onPressed: () async {
                            //     if (!_mobileNumController.text
                            //         .toString()
                            //         .isEmpty) {
                            //       // if (!isMobileNumberVerified) {
                            //       //   customer_reg_otp_sendtomobile(_mobileNumController.text.toString());
                            //       // }
                            //     } else {
                            //       _showMyDialog(context,
                            //           "Please Enter Mobile Number.","Error");
                            //     }
                            //   },
                            //   child: Text('VERIFIED'),
                            // ),
                            border: new OutlineInputBorder(
                              borderSide:
                              new BorderSide(color: Colors.grey),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                            ),
                            hintText: 'Mobile Number',
                          ),
                        ),
                      ),

                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 30, left: 25, right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Email Address",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.darkerText,
                              fontWeight: FontWeight.w600,
                              fontFamily: "WorkSans")),

                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 25, right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: size.width * 0.8,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: new TextField(
                          controller: _emailaddressController,
                          decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            hintText: 'Email Address',
                          ),
                        ),
                      ),

                    ],
                  ),
                ),


                Divider(
                  height: 50,
                  thickness: 15,
                  color: AppTheme.chipBackground,
                ),

                SizedBox(
                  height: 15,
                ),


                Padding(
                  padding: EdgeInsets.only(top: 10, left: 25, right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.push<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) => ChangePassword(),
                            ),
                          );
                        },
                        child:
                      Text("Looking to change password?",
                          textAlign: TextAlign.start,
                          style: TextStyle(

                              fontSize: 18,
                              color: Colors.blue,
                              fontWeight: FontWeight.w400,
                              fontFamily: "WorkSans")),


                          )

                    ],
                  ),
                ),



              ],
            ));
          }
        },
      ),
      bottomNavigationBar: Visibility(
          visible: true,
          child: Container(
            alignment: Alignment.center,
            height: size.height * 0.12,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RoundedButton(
                  color: AppTheme.colorPrimary,
                  text: "Save Changes",
                  press: () async {
                    if (_firstNameController.text.toString().isEmpty) {
                      _showMyDialog(
                          context, "Please enter first name.","Error");

                    }else if (_lastNameController.text.toString().isEmpty) {
                      _showMyDialog(
                          context, "Please enter last name.","Error");

                    }else if (_mobileNumController.text.toString().isEmpty) {
                      _showMyDialog(
                          context, "Please enter mobile number.","Error");
                    }else if (_emailaddressController.text.toString().isEmpty) {
                      _showMyDialog(
                          context, "Please enter email address.","Error");

                    }  else{

                      SharedPreferences  prefs = await SharedPreferences.getInstance();


                      showCupertinoDialog(
                        context: _scaffoldKey.currentContext,
                        builder: (context) =>
                            CupertinoAlertDialog(
                              content: Text(
                                  "Are you sure you want to update?"),
                              actions: <Widget>[

                                CupertinoDialogAction(
                                    child: Text("Yes"),
                                    onPressed: () =>
                                    {
                                      Navigator.of(context).pop(false),
                                      bloc.userProfileReq(_emailaddressController.text.toString()
                                          ,_firstNameController.text.toString()
                                          ,_lastNameController.text.toString()
                                          ,_mobileNumController.text.toString()
                                          ,_scaffoldKey.currentContext,
                                          
                                      prefs.getString(SharedPrefsKeys.ACCESS_TOKEN)
                                          ,prefs.getString(SharedPrefsKeys.TOKEN_TYPE)
                                      )
                                    }
                                ),
                                CupertinoDialogAction(
                                  child: Text("No"),
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                ),
                              ],
                            ),
                      );

                    }

                  },
                ),
              ],
            ),
          )),
    );
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
                textStyle:
                    TextStyle(color: Colors.red, fontFamily: AppTheme.fontName),
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
        );});
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                "From where do you want to take the photo?",
                style: TextStyle(fontFamily: 'Poppins', fontSize: 18),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        captureImage(ImageSource.gallery);
                        Navigator.pop(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        captureImage(ImageSource.camera);
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ));
        });
  }

  Future<void> captureImage(ImageSource imageSource) async {

    try {
      final imageFile = await ImagePicker.pickImage(source: imageSource);
      final dir = await path_provider.getTemporaryDirectory();

      final targetPath = dir.absolute.path +
          "/temp" +
          DateTime.now().millisecondsSinceEpoch.toString() +
          ".jpg";

      // Compress plugin
      File compressedImage = await FlutterImageCompress.compressAndGetFile(
        imageFile.path,
        targetPath,
        quality: 50,
      );

      setState(() {
        _imageFile = compressedImage;

        // fileitemsServer.add(imageFile.readAsBytesSync());
      });
    } catch (e) {
      print(e);
    }


    /* try {
      final imageFile = await ImagePicker.pickImage(source: imageSource);
      setState(() {
        _imageFile = imageFile;

      });
    } catch (e) {
      print(e);
    }*/
  }




}



import 'package:cbx_driver/HomePage/location_type_screen.dart';
import 'package:cbx_driver/HomePage/locout_keys_screen.dart';
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
import 'waiting_screen.dart';

class SubServicePage extends StatefulWidget {
   SubServicePage({Key key,this.serviceName,this.serviceId,this.serviceImg}) : super(key: key);

  final serviceName;
  final serviceId;
  final serviceImg;

  @override
  _SubServicePageState createState() => _SubServicePageState(this.serviceName,this.serviceId,this.serviceImg);


}

class _SubServicePageState extends State<SubServicePage> with TickerProviderStateMixin {


  _SubServicePageState(this.serviceName, this.serviceId,this.serviceImg);
  List<CategoriesList> categoriesList = CategoriesList.categoriesList;
  AnimationController animationController;
  bool multiple = true;

  String serviceId;
  String serviceName;
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
    bloc.fetchAllSubServicesReq(context,prefs.getString(SharedPrefsKeys.ACCESS_TOKEN),prefs.getString(SharedPrefsKeys.TOKEN_TYPE),serviceId);

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

      appBar: AppBar(brightness: Brightness.light, backgroundColor: AppTheme.chipBackground,elevation: 0,

      title: Text(
        this.serviceName==''?'CBX':this.serviceName,
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
      backgroundColor: AppTheme.chipBackground,
      body:
      Container(
          color: AppTheme.chipBackground,
          child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // appBar(),
            Flexible(child:

            StreamBuilder<SubServiceResponse>(
                stream: bloc.subjectAllSubServices.stream,
                builder: (context, snap) {
                  return
                    snap.data!=null?
                    snap.data.allServicesList.length>0?
                    FutureBuilder<bool>(
                      future: getData(),
                      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox();
                        } else {
                          return Padding(
                            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child:
                                  FutureBuilder<bool>(
                                    future: getData(),
                                    builder:
                                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                                      if (!snapshot.hasData) {
                                        return const SizedBox();
                                      } else {
                                        return GridView(
                                          padding: const EdgeInsets.only(
                                              top: 0, left: 12, right: 12),
                                          physics: const BouncingScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          children: List<Widget>.generate(
                                            snap.data.allServicesList.length,
                                                (int index) {
                                              final int count = snap.data.allServicesList.length;
                                              final Animation<double> animation =
                                              Tween<double>(begin: 0.0, end: 1.0).animate(
                                                CurvedAnimation(
                                                  parent: animationController,
                                                  curve: Interval((1 / count) * index, 1.0,
                                                      curve: Curves.fastOutSlowIn),
                                                ),
                                              );
                                              animationController.forward();
                                              return HomeListView(
                                                animation: animation,
                                                animationController: animationController,
                                                categoriesListData: snap.data.allServicesList[index],
                                                callBack: () {

                                                  if(serviceName=='FLAT TIRE'){
                                                    print("SUBSERVICENAME"+snap.data.allServicesList[index].name.toString());

                                                    Navigator.push<dynamic>(
                                                      context,
                                                      MaterialPageRoute<dynamic>(
                                                        builder: (BuildContext context) =>
                                                            LocationTypeScreen(
                                                              serviceName: serviceName,
                                                              serviceId: serviceId,
                                                              serviceImg: serviceImg,
                                                              subServiceId: snap.data.allServicesList[index].id.toString(),
                                                              subServiceName: snap.data.allServicesList[index].name.toString(),
                                                            ),
                                                      ),
                                                    );

                                                  }else if(serviceName=="LOCKOUT"){
                                                    Navigator.push<dynamic>(
                                                      context,
                                                      MaterialPageRoute<dynamic>(
                                                        builder: (BuildContext context) =>
                                                            LockoutScreen(
                                                              serviceName: serviceName,
                                                              serviceId: serviceId,
                                                              serviceImg: serviceImg,
                                                              subServiceId: snap.data.allServicesList[index].id.toString(),
                                                              subServiceName: snap.data.allServicesList[index].name.toString(),
                                                            ),
                                                      ),
                                                    );

                                                  }else if(serviceName=="FUEL"){
                                                    Navigator.push<dynamic>(
                                                      context,
                                                      MaterialPageRoute<dynamic>(
                                                        builder: (BuildContext context) =>
                                                            WaitingScreen(
                                                              serviceName: serviceName,
                                                              serviceId: serviceId,
                                                                serviceImg:serviceImg,
                                                              subServiceId: snap.data.allServicesList[index].id.toString(),

                                                            ),
                                                      ),
                                                    );

                                                  }else{
                                                    print("SUBSERVICENAME"+snap.data.allServicesList[index].name.toString());

                                                    Navigator.push<dynamic>(
                                                      context,
                                                      MaterialPageRoute<dynamic>(
                                                        builder: (BuildContext context) =>
                                                            LocationTypeScreen(
                                                              serviceName: serviceName,
                                                              serviceId: serviceId,
                                                              serviceImg: serviceImg,
                                                              subServiceId: snap.data.allServicesList[index].id.toString(),
                                                              subServiceName: snap.data.allServicesList[index].name.toString(),

                                                            ),
                                                      ),
                                                    );
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                          gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: multiple ? 2 : 1,
                                            mainAxisSpacing: 5.0,
                                            crossAxisSpacing: 5.0,
                                            childAspectRatio: 1.5,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ):
                    NoDataFound():NoDataFound();

                }),
            ),

            // Divider( height: 20,color: AppTheme.chipBackground,thickness: 2,)

          ],
        ),
      )
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
}



class HomeListView extends StatelessWidget {
  const HomeListView(
      {Key key,
      this.categoriesListData,
      this.callBack,
      this.animationController,
      this.animation})
      : super(key: key);

  final AllSubServicesModel categoriesListData;
  final VoidCallback callBack;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: AspectRatio(
              aspectRatio: 1.6,
              child:
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                Card(
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(10))),
            color: AppTheme.white,
            elevation: 0,
            child:
                    Column(
                      children: <Widget>[

                            Container(
                              height: size.height*0.10,
                              width: size.width*0.51,

                              child: Padding(
                                padding: EdgeInsets.all(
                                    15),
                                child: Image.network(
                                  categoriesListData.image,
                                ),
                              ),
                            ),

                        SizedBox(
                          width: size.width*0.25,
                          child:                         Text(categoriesListData.name,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: AppTheme.nearlyBlack,

                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppTheme.fontName)),

                        ),
                      ],
                    ),
                    ),
                    // -------------also set Image png/JPG--------------

                    /*Image.asset(
                      categoriesListData.imagePath,
                      fit: BoxFit.cover,
                    ),*/

                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.grey.withOpacity(0.2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4.0)),
                        onTap: () {
                          callBack();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class NoDataFound extends StatelessWidget {
  const NoDataFound(
      {Key key})
      : super(key: key);



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[

        Container(
          alignment: Alignment.center,
          width: size.width,
          height: size.height*0.25,
          child: Padding(
              padding: EdgeInsets.all(
                  5),
              child: Image.asset("assets/images/datanotfound.png")

          ),
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

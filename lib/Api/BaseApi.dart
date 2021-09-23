
import 'package:cbx_driver/Utils/CommanStrings.dart';
import 'package:dio/dio.dart';

class BaseApi{
  Dio dio;


  BaseApi(this.dio){
    BaseOptions options = new BaseOptions(
      baseUrl: BASE_URL,
    );

    dio = new Dio(options);
  }
}
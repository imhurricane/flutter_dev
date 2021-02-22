import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter_dev/view/comm_views/offline/moudel/image.dart';

import 'address.dart';
import 'code.dart';
import 'logs_interceptor.dart';
import 'response_interceptor.dart';
import 'result_data.dart';

class HttpManager {
  static HttpManager _instance = HttpManager._internal();
  Dio _dio;

  static const CODE_SUCCESS = 200;
  static const CODE_TIME_OUT = -1;

  factory HttpManager() => _instance;

  ///通用全局单例，第一次使用时初始化
  HttpManager._internal({String baseUrl}) {
    if (null == _dio) {
      _dio = new Dio(
          new BaseOptions(baseUrl: Address.BASE_URL, connectTimeout: 5000,receiveTimeout: 300000,sendTimeout: 300000));
      _dio.interceptors.add(new LogsInterceptors());
      _dio.interceptors.add(new ResponseInterceptors());
    }
  }

  static HttpManager getInstance({String baseUrl}) {
    if (baseUrl == null) {
      return _instance._normal();
    } else {
      return _instance._baseUrl(baseUrl);
    }
  }

  //用于指定特定域名，比如cdn和kline首次的http请求
  HttpManager _baseUrl(String baseUrl) {
    if (_dio != null) {
      _dio.options.baseUrl = baseUrl;
    }
    return this;
  }

  //一般请求，默认域名
  HttpManager _normal() {
    if (_dio != null) {
      if (_dio.options.baseUrl != Address.BASE_URL) {
        _dio.options.baseUrl = Address.BASE_URL;
      }
    }
    return this;
  }

  ///通用的GET请求
  get(api, params, {noTip = false}) async {
    Response response;
    try {
      response = await _dio.get(api, queryParameters: params);
    } on DioError catch (e) {
      return resultError(e);
    }

    if (response is DioError) {
      ///自定义错误
//      return resultError(response.data['code']);
    }

    return response.data;
  }

  ///通用的POST请求
  post(api, params, {noTip = false}) async {
    Response response;

    try {
      response = await _dio.post(api, data: params);
    } on DioError catch (e) {
      return resultError(e);
    }

    if (response is DioError) {
//      return resultError(response.data['code']);
    }

    return response.data;
  }

  uploadPictures(api,Map<String, dynamic> params,List<RissImages> images) async{
    Response response;

    var formData = FormData();
    images.forEach((element) {
      if(!element.isUpload){
        var name = element.path.substring(element.path.lastIndexOf("/") + 1, element.path.length);
        var mapEntry = MapEntry(
          "files",
          MultipartFile.fromFileSync(element.path,
              filename: name),
        );
        formData.files.add(mapEntry);
      }
    });
    try {
      response = await _dio.post(api,data: formData,queryParameters: params);
    } on DioError catch (e) {
      return resultError(e);
    }
    return response.data;
  }

  uploadPicture(api,Map<String, dynamic> params,path) async{
    Response response;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    var image = await MultipartFile.fromFile(
      path,
      filename: name,
    );
    FormData formData = FormData.fromMap({
      "image": image
    });
    try {
      response = await _dio.post(api,data: formData,queryParameters: params);
    } on DioError catch (e) {
      return resultError(e);
    }
    return response.data;
  }
}



ResultData resultError(DioError e) {
  Response errorResponse;
  if (e.response != null) {
    errorResponse = e.response;
  } else {
    errorResponse = new Response(statusCode: 66);
  }
  if (e.type == DioErrorType.CONNECT_TIMEOUT ||
      e.type == DioErrorType.RECEIVE_TIMEOUT) {
    errorResponse.statusCode = Code.NETWORK_TIMEOUT;
    errorResponse.statusMessage = "网络连接超时"+"\n"+Address.BASE_URL;
  }else{
    errorResponse.statusCode = Code.NETWORK_TIMEOUT;
    errorResponse.statusMessage = "网络连接失败"+"\n"+Address.BASE_URL;
  }
  return new ResultData(
      errorResponse.statusMessage, false, errorResponse.statusCode);
}

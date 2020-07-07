import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/moudel/user_bean.dart';
import 'package:flutter_dev/router/route_util.dart';
import 'package:flutter_dev/view/login/login_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MainMinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainMinePageState();
  }
}

class MainMinePageState extends State<MainMinePage> {
  String result = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("网络请求"),
      ),
      body: Column(
        children: [
          FlatButton(
            onPressed: () {
              SpUtil.remove("userInfo");
              RouteUtils.pushReplacePage(context, LoginPage());
            },
            child: Text("退出登录"),
          ),
        ],
      ),
    );
  }

  User mUser;

  //get请求
  void getRequest() async {
    Dio dio = Dio();
    //请求地址
    String url = "";
    Response response = await dio.get(url);
    String data = response.data;

    String json = "";
    ///String转Map   若本来就是JSON无需再转
    Map<String, dynamic> user = jsonDecode(data);
    ///Map转bean
    User().fromJson(user);

    setState(() {
      result = user.toString();
      mUser = user["data"];
    });
  }

  //一般post请求
  void postRequest() async {
    Dio dio = Dio();
    //请求地址
    String url = "";

    //创建map封装参数
    Map<String, dynamic> map = Map();
    //创建formData
    FormData formData = FormData.fromMap(map);

    configCommParams(url, null, null, method: "POST");

    Response response = await dio.post(url, data: formData);
  }

  /// 上传文件请求
  void postFileRequest() async {
    String filePath = "";
    Dio dio = Dio();
    //请求地址
    String url = "";
    //创建map封装参数
    Map<String, dynamic> map = Map();
    map["auth"] = "123123";

    ///await 等待图片读取完成
    map["file"] = await MultipartFile.fromFile(filePath, filename: "xxx.png");

    //创建formData
    FormData formData = FormData.fromMap(map);
    Response response = await dio.post(url, data: formData,
        onSendProgress: (int progress, int total) {
          print("当前进度 $progress");
          print("总进度 $total");
        });
  }

  void downLoadFileRequest() async {
    ///申请手机读写文件权限
    requestPermission(Permission.storage);

    Dio dio = Dio();
    //请求地址
    String url = "";

    ///手机存储目录
    String savePath = await getPhoneLocalPath();
    await dio.download(url, savePath, onReceiveProgress: (received, total) {
      if (total != -1) {
        print((received / total * 100).toStringAsFixed(0) + '%');
      }
    });
  }

  ///获取手机目录
  Future<String> getPhoneLocalPath() async {
    final directory = Theme.of(context).platform == TargetPlatform.android
        ? await getExternalStorageDirectories()
        : await getApplicationDocumentsDirectory();
    return directory;
  }

  ///添加公共参数
  void configCommParams(
      String url, formData, Map<String, dynamic> queryParameters,
      {String method = "GET"}) {
    if (method == "GET") {
      if (queryParameters != null) {
        queryParameters['xxx'] = "xxx";
      } else {
        if (url.contains("?")) {
          url += "&xxx=xxx";
        } else {
          url += "?xxx=xxx";
        }
      }
    } else {
      if (formData != null) {
        formData[''] = "";
      }
    }
  }

  ///申请权限
  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();

    setState(() {
      print(status);
    });
  }
}

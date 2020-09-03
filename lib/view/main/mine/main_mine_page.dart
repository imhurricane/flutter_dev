import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/comm/comm_utils.dart';
import 'package:flutter_dev/comm/storage_utils.dart';
import 'package:flutter_dev/moudel/user_bean.dart';
import 'package:flutter_dev/router/route_util.dart';
import 'package:flutter_dev/view/comm_views/components/form_select_cell.dart';
import 'package:flutter_dev/view/login/login_page.dart';
import 'package:flutter_dev/view/login/moudel/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'mine_item.dart';

class MainMinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainMinePageState();
  }
}

class MainMinePageState extends State<MainMinePage> {
  String result = "";

  List<MineItem> items;
  LoginUser loginUser;

  @override
  void initState() {
    super.initState();
    items = new List<MineItem>();
    loginUser = LoginUser.fromJson(StorageUtils.getModelWithKey("userInfo"));
    buildSettingItem();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text("个人中心"),
            centerTitle: true,
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            snap: false, 
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top:60.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("resources/images/weChart.png")
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(this.loginUser.usernamecn,style: TextStyle(color: Colors.white),),
                        SizedBox(width: 16.0,),
                        Text(this.loginUser.deptname,style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ),
          SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: new SliverChildBuilderDelegate(
                  (context, index) => FormSelectCell(
                    text: items[index].description,
                    leftWidget: Padding(
                      padding: const EdgeInsets.only(right:8.0),
                      child: Icon(items[index].icon,size: 20,color: items[index].iconColor,),
                    ),
                    clickCallBack: (){
                      ///   TODO 根据不同button做不同逻辑
                      switch(items[index].type){
                        case ButtonType.loginOut:
                          loginOut(index);
                          break;
                        default:break;
                      }
                    },
                  ),
              childCount: items.length,
            ),
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

  //  退出登录操作
  loginOut(int index) {
    CommUtils.showDialog(context, "提示", "确认退出APP吗?", true,okOnPress: (){
    StorageUtils.removeWithKey("userInfo");
    RouteUtils.pushReplacePage(context, LoginPage());
    },cancelOnPress: (){

    });

  }

  void buildSettingItem() {
    MineItem mineItem = MineItem(type: ButtonType.loginOut);
    mineItem.description = "退出登录";
    mineItem.icon = Icons.settings_power;
    mineItem.iconColor = Colors.red[300];
    items.add(mineItem);
  }
}

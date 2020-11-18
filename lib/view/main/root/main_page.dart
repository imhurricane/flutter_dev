

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app_upgrade/flutter_app_upgrade.dart';
import 'package:flutter_dev/comm/storage_utils.dart';
import 'package:flutter_dev/http/address.dart';
import 'package:flutter_dev/http/http_manager.dart';
import 'package:flutter_dev/http/result_data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../main_find_page.dart';
import '../home/home_page.dart';
import '../mine/main_mine_page.dart';
import '../main_sort_page.dart';

class MainPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }

}

class MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin  {

  List<String> tabTitleList = ["首页","分类","发现","我的"];
  List<Widget> pageList = [MainHomePage(),MainSortPage(),MainFindPage(),MainMinePage()];
  List<String> normalIcon = ["sy_01.png","fl_01.png","bk_01.png","mine_01.png"];
  List<String> selectIcon = ["sy_02.png","fl_02.png","bk_02.png","mine_02.png"];
  num selectIndex = 0;
  DateTime _lastPressedAt;

  @override
  void initState() {
    super.initState();
    initData();
    AppUpgrade.appUpgrade(
      context,
      _checkAppInfo(),
      iosAppId: 'id88888888',
    );
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_lastPressedAt == null) {
          //首次点击提示...信息
          FlutterToast.showToast(
            msg: "连续双击退出APP",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
        if (_lastPressedAt == null ||
            DateTime.now().difference(_lastPressedAt) > Duration(seconds: 1)) {
          //两次点击间隔超过1秒则重新计时
          _lastPressedAt = DateTime.now();
          return false; // 不退出
        }
        return true; //退出
      },
      child: Scaffold(
        body: pageList[selectIndex],
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels:true,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Image.asset("resources/images/${selectIndex==0?selectIcon[0]:normalIcon[0]}",width: 24,height: 24,),title: Text(tabTitleList[0],style: TextStyle(color: selectIndex==0?Colors.lightBlue:Colors.black),),),
            BottomNavigationBarItem(icon: Image.asset("resources/images/${selectIndex==1?selectIcon[1]:normalIcon[1]}",width: 24,height: 24,),title: Text(tabTitleList[1],style: TextStyle(color: selectIndex==1?Colors.lightBlue:Colors.black),),),
            BottomNavigationBarItem(icon: Image.asset("resources/images/${selectIndex==2?selectIcon[2]:normalIcon[2]}",width: 24,height: 24,),title: Text(tabTitleList[2],style: TextStyle(color: selectIndex==2?Colors.lightBlue:Colors.black),),),
            BottomNavigationBarItem(icon: Image.asset("resources/images/${selectIndex==3?selectIcon[3]:normalIcon[3]}",width: 24,height: 24,),title: Text(tabTitleList[3],style: TextStyle(color: selectIndex==3?Colors.lightBlue:Colors.black),),),
          ],
          onTap: (value){
            setState(() {
              selectIndex = value;
            });
          },
          currentIndex: selectIndex,
        ),
      ),
    );
  }

  initData() async{
    String ip = StorageUtils.getStringWithKey("ip");
    if(ip != null && ip.length>0){
      Address.setBaseUrl(ip);
    }else{
      Address.BASE_URL = "http://192.168.1.166:7001";
    }
  }

  Future<AppUpgradeInfo> _checkAppInfo() async {
    //这里一般访问网络接口，将返回的数据解析成如下格式
    AppInfo appInfo = await FlutterUpgrade.appInfo;
    print('version:'+appInfo.versionCode);
    print('version:'+appInfo.versionName);
    Map<String,dynamic> params = Map();
    params['ver']=appInfo.versionName;
//    params['ver']="1.00.00";
    params['appType']="FLUTTER";
    List<String> des = List();
    String downloadApkUrl = "";
    String forceupgrade = "";
    ResultData result = await HttpManager.getInstance().get(Address.CheckVersion_URL, params);
    print('data:'+result.data.toString());
    if(result.code == 200){
      Map<String, dynamic> json = jsonDecode(result.data);
      if(json.containsKey("path")){
        downloadApkUrl = json.containsKey("path")?json['path']:"";
        forceupgrade = json.containsKey("forceupgrade")?json['forceupgrade']:"";
        String desc = json.containsKey("desc")?json['desc']:"";

        des = desc.split("\n");
        return Future.delayed(Duration(seconds: 1), () {
          return AppUpgradeInfo(
              title: '发现新版本',
              contents: des,
              force: forceupgrade=="1"?true:false,
              apkDownloadUrl: downloadApkUrl
          );
        });
      }else{
        return null;
      }
    }else{
      return null;
    }

  }

}
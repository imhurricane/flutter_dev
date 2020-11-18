

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_upgrade/flutter_app_upgrade.dart';

class AboutPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return AboutPageState();
  }

}

class AboutPageState extends State<AboutPage>{

  String mVersionName = "";

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("关于我们"),
        leading: IconButton(
          alignment: Alignment.center,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Container(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("版本号："),
              Text(mVersionName),
            ],
          ),
        ),
      ),
    );
  }

  initData() async{
    AppInfo appInfo = await FlutterUpgrade.appInfo;
    mVersionName = appInfo.versionName;
    setState(() {});
  }


}
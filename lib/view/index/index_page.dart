import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/comm/storage_utils.dart';
import 'package:flutter_dev/router/route_util.dart';
import 'package:flutter_dev/view/login/login_page.dart';
import 'package:flutter_dev/view/main/root/main_page.dart';


import 'guide_page.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return IndexPageState();
  }
}

class IndexPageState extends State<IndexPage> {
  bool mIsFirst;
  TimerUtil mTimerUtil;
  num mTick = 5;
  Map<String, dynamic> user;

  @override
  void initState() {
    super.initState();
    user = StorageUtils.getModelWithKey("userInfo");
    mTimerUtil = new TimerUtil(mInterval: 100, mTotalTime: 5000);
    mTimerUtil.setOnTimerTickCallback((int tick) {
      setState(() {
        mTick = tick / 1000;
        if (0 == mTick) {
          if (user != null) {
            RouteUtils.pushReplacePage(context, MainPage());
          } else {
            RouteUtils.pushReplacePage(context, LoginPage());
          }
        }
      });
    });
//    readCacheData();
    mTimerUtil.startCountDown();
  }

  readCacheData() async {
    bool isFirst = StorageUtils.getBoolWithKey("is_first");
    user = StorageUtils.getModelWithKey("userInfo");
    if (isFirst == null || isFirst == false) {
      //第一次进入APP  进入引导页
      StorageUtils.saveBool("is_first", true);
      RouteUtils.pushReplacePage(context, GuidePage());
    } else {
      //倒计时进入主页
      mTimerUtil.startCountDown();
    }
    mIsFirst = isFirst;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          buildBackGroundImage(),
//          buildCenterProgress(),
          buildTimerTask(),
          Positioned(
            right: 20,
            top: 34,
            child: Ink(
              child: InkWell(
                onTap: () {
                  if (mTimerUtil.isActive()) {
                    mTimerUtil.cancel();
                  }
                  if (user != null) {
                    RouteUtils.pushReplacePage(context, MainPage());
                  } else {
                    RouteUtils.pushReplacePage(context, LoginPage());
                  }
                },
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    value: (5.0 - mTick) / 5.0,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.asset(
                    "resources/images/logo.png",
                    width: 32,
                    height: 32,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Flutter欢饮您",
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildBackGroundImage() {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      bottom: 0,
      child: Image.asset("resources/images/splash.jpg", fit: BoxFit.fill),
    );
  }

  buildTimerTask() {
    return Positioned(
      right: 20,
      top: 34,
      height: 50,
      width: 50,
      child: Center(
        child: Text('${mTick.toInt()}s'),
      ),
    );
  }

  buildCenterProgress() {
    return Positioned(
      child: Center(
        child: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

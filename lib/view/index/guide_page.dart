import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/comm/comm_utils.dart';
import 'package:flutter_dev/comm/storage_utils.dart';
import 'package:flutter_dev/moudel/user_bean.dart';
import 'package:flutter_dev/router/route_util.dart';
import 'package:flutter_dev/view/login/login_page.dart';
import 'package:flutter_dev/view/login/moudel/user.dart';
import 'package:flutter_dev/view/main/root/main_page.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class GuidePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new GuidePageState();
  }
}

class GuidePageState extends State<GuidePage> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Swiper(
        itemBuilder: (BuildContext context1, int index) {
          if (3 == index) {
            return Stack(
              children: [
                Positioned(
                  left: 0,
                  bottom: 0,
                  top: 0,
                  right: 0,
                  child: Image.asset(
                    "resources/images/img3.jpg",
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 150,
                      ),
                      Text(
                        "山高水长",
                        style: TextStyle(fontSize: 16,color: Colors.white),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text("Flutter与您同行", style: TextStyle(fontSize: 16,color: Colors.white)),
                    ],
                  ),
                ),
                Positioned(
                    bottom: 120,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(22)),
                        color: Colors.deepPurple,
                        child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(22)),
                            color: Colors.white,
                          ),
                          child: InkWell(
                            onTap: () {
                              LoginUser loginUser = StorageUtils.getModelWithKey("userInfo") as LoginUser;
                              if(null != loginUser){
                                RouteUtils.pushReplacePage(context,MainPage());
                              }else{
                                RouteUtils.pushReplacePage(context,LoginPage());
                              }
                            },
                            borderRadius: BorderRadius.all(Radius.circular(22)),
                            splashColor: Colors.grey,
                            child: Container(
                              width: 90,
                              height: 28,
                              alignment: Alignment.center,
                              child: Text("进入首页"),
                            ),
                          ),
                        ),
                      ),
                    )),
              ],
            );
          }
          return new Image.asset(
            "resources/images/img$index.jpg",
            fit: BoxFit.fill,
          );
        },
        itemCount: 4,
        pagination: new SwiperPagination(),
//        control: new SwiperControl(),
      ),
    );
  }
}

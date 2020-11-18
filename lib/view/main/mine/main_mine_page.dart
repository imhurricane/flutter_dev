import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/comm/comm_utils.dart';
import 'package:flutter_dev/comm/storage_utils.dart';
import 'package:flutter_dev/router/route_util.dart';
import 'package:flutter_dev/view/comm_views/components/form_select_cell.dart';
import 'package:flutter_dev/view/login/login_page.dart';
import 'package:flutter_dev/view/login/moudel/user.dart';
import 'package:flutter_dev/view/main/mine/about_page.dart';

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
                      padding: const EdgeInsets.only(top: 60.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                              child: Image.asset("resources/images/user.jpeg",
                                width: 100,
                                height: 100,
                          ))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            this.loginUser.usernamecn,
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 16.0,
                          ),
                          Text(
                            this.loginUser.deptname,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: new SliverChildBuilderDelegate(
              (context, index) => FormSelectCell(
                text: items[index].description,
                leftWidget: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    items[index].icon,
                    size: 20,
                    color: items[index].iconColor,
                  ),
                ),
                clickCallBack: () {
                  ///   TODO 根据不同button做不同逻辑
                  switch (items[index].type) {
                    case ButtonType.loginOut:
                      loginOut(index);
                      break;
                    case ButtonType.aboutAs:
                      RouteUtils.pushPage(context, AboutPage());
                      break;
                    default:
                      break;
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

  //  退出登录操作
  loginOut(int index) {
    CommUtils.showDialog(context, "提示", "确认退出APP吗?", true, okOnPress: () {
      StorageUtils.removeWithKey("userInfo");
      RouteUtils.pushReplacePage(context, LoginPage());
    }, cancelOnPress: () {});
  }

  void buildSettingItem() {
    MineItem mineItem = MineItem(type: ButtonType.loginOut);
    mineItem.description = "退出登录";
    mineItem.icon = Icons.settings_power;
    mineItem.iconColor = Colors.red[300];
    MineItem mineItem1 = MineItem(type: ButtonType.aboutAs);
    mineItem1.description = "关于我们";
    mineItem1.icon = Icons.info;
    mineItem1.iconColor = Colors.lightBlue[400];
    items.add(mineItem);
    items.add(mineItem1);
  }
}

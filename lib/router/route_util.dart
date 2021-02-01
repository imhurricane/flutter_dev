//路由工具类
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/router/page_route.dart';


class RouteUtils {
  static void pushPage(BuildContext context, Widget page) {
    if (null == page) {
      return;
    }
    Future.delayed(Duration.zero, () {
//      Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) => page));
      Navigator.push(context, LeftToRightPageRoute(page));
    });

  }

  static void pushReplacePage(BuildContext context, Widget page) {
    if (null == page) {
      return;
    }
    Future.delayed(Duration.zero, () {
//      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => page));
      Navigator.pushReplacement(context, LeftToRightPageRoute(page));
    });

  }

  static void pushPage1(BuildContext context,Widget currentPage, Widget toPage) {
    if (null == toPage) {
      return;
    }
    Future.delayed(Duration.zero, () {
      Navigator.push(context, CustomPageRoute(currentPage,toPage));
    });

  }

  //关闭界面
  static void popPage(BuildContext context) {
    if (context != null) {
      Navigator.pop(context);
    }
  }
}

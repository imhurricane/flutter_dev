//路由工具类
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class RouteUtils {
  static void pushPage(BuildContext context, Widget page) {
    if (null == page) {
      return;
    }
    Future.delayed(Duration.zero, () {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) => page));
    });

  }

  static void pushReplacePage(BuildContext context, Widget page) {
    if (null == page) {
      return;
    }
    Future.delayed(Duration.zero, () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => page));
    });

  }

  //关闭界面
  static void popPage(BuildContext context) {
    if (context != null) {
      Navigator.pop(context);
    }
  }
}

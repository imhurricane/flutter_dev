import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/comm/storage_utils.dart';
import 'package:flutter_dev/moudel/user_bean.dart';
import 'package:flutter_dev/view/login/moudel/user.dart';
import 'package:permission_handler/permission_handler.dart';

class CommUtils {
  static showDialog(
      BuildContext context, String title, String msg, bool showCancel,
      {cancelOnPress, okOnPress}) {
    if (showCancel) {
      AwesomeDialog(
        context: context,
        headerAnimationLoop: false,
        dialogType: DialogType.NO_HEADER,
        animType: AnimType.BOTTOMSLIDE,
        title: title!=null?title:"",
        desc: '$msg',
        btnOkColor: Colors.lightBlue,
        btnCancelColor: Colors.red,
        btnCancelOnPress: cancelOnPress,
        btnOkOnPress: okOnPress,
        btnOkText: "确定",
        btnCancelText: "取消",
        dismissOnTouchOutside:false,
      ).show();
    } else {
      AwesomeDialog(
        context: context,
        headerAnimationLoop: false,
        dialogType: DialogType.NO_HEADER,
        animType: AnimType.BOTTOMSLIDE,
        title: title!=null?title:"",
        desc: '$msg',
        btnOkOnPress: okOnPress,
        btnOkText: "确定",
        btnOkColor: Colors.lightBlue,
        dismissOnTouchOutside:false,
      ).show();
    }
  }

  /// 获取用户信息
  static LoginUser getUserInfo(){
    return LoginUser.fromJson(StorageUtils.getModelWithKey("userInfo"));
  }

  ///申请权限
  Future requestPermission(Permission permission) async {
    return await permission.request();
  }


  ///取小数点后几位
  ///num 数据
  ///location 几位
  static String formatNum(double num, int location) {
    if ((num.toString().length - num.toString().lastIndexOf(".") - 1) <
        location) {
      //小数点后有几位小数
      return num.toStringAsFixed(location)
          .substring(0, num.toString().lastIndexOf(".") + location + 1)
          .toString();
    } else {
      return num.toString()
          .substring(0, num.toString().lastIndexOf(".") + location + 1)
          .toString();
    }
  }
}

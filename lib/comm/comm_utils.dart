import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/comm/storage_utils.dart';
import 'package:flutter_dev/moudel/user_bean.dart';
import 'package:flutter_dev/view/login/moudel/user.dart';

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
        title: '提示',
        desc: '$msg',
        btnOkColor: Colors.lightBlue,
        btnCancelColor: Colors.red,
        btnCancelOnPress: cancelOnPress,
        btnOkOnPress: okOnPress,
        btnOkText: "确定",
        btnCancelText: "取消",
        dismissOnTouchOutside:false,
      )..show();
    } else {
      AwesomeDialog(
        context: context,
        headerAnimationLoop: false,
        dialogType: DialogType.NO_HEADER,
        animType: AnimType.BOTTOMSLIDE,
        title: '提示',
        desc: '$msg',
        btnOkOnPress: okOnPress,
        btnOkText: "确定",
        btnOkColor: Colors.lightBlue,
        dismissOnTouchOutside:false,
      )..show();
    }
  }

  /// 获取用户信息
  static LoginUser getUserInfo(){
    return LoginUser.fromJson(StorageUtils.getModelWithKey("userInfo"));
  }

}

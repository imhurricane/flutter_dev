import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';

class CommUtils {

  static showDialog(BuildContext context, String title, String msg,bool showCancel,
      {cancelOnPress,okOnPress}) {
    if(showCancel){
      AwesomeDialog(
        context: context,
        headerAnimationLoop: false,
        dialogType: DialogType.NO_HEADER,
        animType: AnimType.BOTTOMSLIDE,
        title: '提示',
        desc: '$msg',
        btnCancelOnPress: cancelOnPress,
        btnOkOnPress: okOnPress,
        btnOkText: "确定",
      )..show();
    }else{
      AwesomeDialog(
        context: context,
        headerAnimationLoop: false,
        dialogType: DialogType.NO_HEADER,
        animType: AnimType.BOTTOMSLIDE,
        title: '提示',
        desc: '$msg',
        btnOkOnPress: okOnPress,
        btnOkText: "确定",
      )..show();
    }

  }
}

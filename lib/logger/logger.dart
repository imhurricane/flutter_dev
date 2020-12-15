import 'dart:io';

import 'package:flustars/flustars.dart';
import 'package:path_provider/path_provider.dart';

class LogUtil {
  static const String _TAG_DEF = "###common_utils###";

  static bool debuggable = false; //是否是debug模式,true: log v 不输出.
  static String TAG = _TAG_DEF;

  static void init({bool isDebug = false, String tag = _TAG_DEF}) {
    debuggable = isDebug;
    TAG = tag;
  }

  static void e(Object object, {String tag}) {
    _printLog(tag,object);
  }

  static void v(Object object, {String tag}) {
    if (debuggable) {
      _printLog(tag, object);
    }
  }

  static _printLog(String tag, Object object) async {
    StringBuffer sb = new StringBuffer();
    sb.write((tag == null || tag.isEmpty) ? "TYPE: "+TAG : "TYPE: "+tag);
    sb.write("\n");
    sb.write(object);
    final file = await _localFile;
    return file.writeAsString(sb.toString());
  }

  static Future<String> get _localPath async {
    // 获取应用支持目录(IOS和安卓通用)
    // 用于存储应用支持的目录 这个目录对于用户是不可见的
    // getApplicationSupportDirectory().then((value) => print(value));

    // 获取外部存储目录(仅安卓可用)
    // 获取外部存储目录 用户可见
    // getExternalStorageDirectory().then((value) => print(value));

//    final _path = await getApplicationSupportDirectory();
    Directory appDocDirs = await getExternalStorageDirectory();
    Directory directory = await Directory('${appDocDirs.path}/Log').create();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    var formatDate = DateUtil.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");
    return File('$path/Log-'+formatDate+'.txt');
  }
}

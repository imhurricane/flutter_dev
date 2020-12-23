import 'dart:io';

import 'package:flustars/flustars.dart';
import 'package:flutter_dev/comm/comm_utils.dart';
import 'package:flutter_dev/logger/Logger_base.dart';
import 'package:flutter_dev/logger/logger_moudel.dart';
import 'package:path_provider/path_provider.dart';

class ErrorLog extends LoggerBase {

  ErrorLog(int level) {
    this.level = level;
  }

  @override
  void write(LoggerMoudel message) {
    print(message.date + ":  " + message.tag + "==>  " + message.message);
  }
}

class FileLog extends LoggerBase {
  FileLog(int level) {
    this.level = level;
  }

  @override
  void write(LoggerMoudel message) {
    _printLog(message);
  }

  static _printLog(LoggerMoudel message) async {
    StringBuffer sb = new StringBuffer();
    sb.write("\n==============================\n");
    sb.write("date:  "+message.date);
    sb.write("\n");
    sb.write(message.tag+":  "+message.message);
    final file = await _localFile;
    return file.openWrite(mode: FileMode.append).write(sb.toString());
//    return file.writeAsString(sb.toString());
  }

  static Future<File> get _localFile async {
    Directory appDocDirs = await getExternalStorageDirectory();
    Directory directory = await Directory('${appDocDirs.path}/Log').create();
    final path = directory.path;
    var formatDate = DateUtil.formatDate(DateTime.now(), format: "yyyy-MM-dd");
    return File('$path/Log-'+formatDate+'.txt');
  }
}

class ConsoleLog extends LoggerBase {

  ConsoleLog(int level) {
    this.level = level;
  }

  @override
  void write(LoggerMoudel message) {
    print(message.date + ":  " + message.tag + "==>  " + message.message);
  }
}

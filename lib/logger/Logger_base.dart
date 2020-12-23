import 'package:flustars/flustars.dart';

import 'logger_moudel.dart';

abstract class LoggerBase {
  static int INFO = 1;
  static int DEBUG = 2;
  static int ERROR = 3;
  int level;

  LoggerBase nextLogger;

  void setNextLogger(LoggerBase nextLogger) {
    this.nextLogger = nextLogger;
  }

  void logMessage(int level, String tag, String message) {
    LoggerMoudel moudel = new LoggerMoudel();
    moudel.date = DateUtil.formatDate(DateTime.now(), format: "yyyy-MM-dd HH:mm:ss");
    if (null == tag || tag.length == 0) {
      moudel.tag = "log";
    } else {
      moudel.tag = tag;
    }
    moudel.message = message;
    if (this.level <= level) {
      write(moudel);
    }
    if (nextLogger != null) {
      nextLogger.logMessage(level, tag, message);
    }
  }

  void write(LoggerMoudel message);
}

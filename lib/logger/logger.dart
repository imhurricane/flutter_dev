import 'package:flutter_dev/logger/Logger_base.dart';
import 'package:flutter_dev/logger/Logger_cat.dart';

class LogUtil {

  // 根据日志级别打印、记录日志文件。
  static void write(int level,String tag,String message){
    LoggerBase errorLogger = ErrorLog(LoggerBase.ERROR);
    LoggerBase fileLogger = FileLog(LoggerBase.DEBUG);
    LoggerBase consoleLogger = ConsoleLog(LoggerBase.INFO);
    errorLogger.setNextLogger(fileLogger);
    fileLogger.setNextLogger(consoleLogger);
    errorLogger.logMessage(level,tag,message);
  }
}

import 'dart:collection';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';


class DataHelper{

  /// SplayTreeMap 自平衡二叉搜索树，它具有可以快速访问最近被访问的元素。它能在O(log n)内完成插入、查找和删除操作。
  static SplayTreeMap getBaseMap() {
    var map = new SplayTreeMap<String, dynamic>();
//    map["platform"] = "1";
//    map["system"] = "android";
//    map["channel"] = "official";
    map["time"] = new DateTime.now().millisecondsSinceEpoch.toString();
    return map;
  }

  static encryptParams(Map<String, dynamic> map) {
    var buffer = StringBuffer();
    map.forEach((key, value) {
      buffer.write(key);
      buffer.write(value);
    });

    buffer.write("SERECT");
    print('bustring--->:' + buffer.toString());
    var sign = string2MD5(buffer.toString());
    map["sign"] = sign;
    print("sign--->" + sign);
    return map;
  }

  static string2MD5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }
}
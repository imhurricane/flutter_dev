import 'package:flutter_dev/db/base_db_provider.dart';
import 'package:flutter_dev/view/comm_views/offline/moudel/equipment.dart';
import 'package:sqflite/sqflite.dart';

class Paper {

  String xtm;
  String parentxtm;
  String description;
  List<Equipment> equipment;
  bool isSignImage;

  Paper({this.xtm, this.parentxtm, this.description, this.equipment,this.isSignImage});

  Paper.fromJson(Map<String, dynamic> json) {
    xtm = json['xtm'];
    parentxtm = json['parentxtm'];
    description = json['description'];
    isSignImage = json['isSignImage']=="1"?true:false;
    if (json['equipment'] != null) {
      equipment = new List<Equipment>();
      json['equipment'].forEach((v) {
        equipment.add(new Equipment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['xtm'] = this.xtm;
    data['parentxtm'] = this.parentxtm;
    data['description'] = this.description;
    data['isSignImage'] = this.isSignImage?"1":"0";
    if (this.equipment != null) {
      data['equipment'] = this.equipment.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PaperProvider extends BaseDbProvider {
  ///表名
  final String name = 'Paper';

  final String columnId = "xtm";
  final String columnParentxtm = "parentxtm";
  final String columnDesc = "description";
  final String columnIsSignImage = "isSignImage";

  @override
  tableName() {
    return name;
  }

  @override
  createTableString() {
    return '''
        create table $name (
        $columnId text not null,
        $columnParentxtm text not null,
        $columnIsSignImage text,
        $columnDesc text not null)
      ''';
  }

  ///查询数据
  Future selectPaperById(String id) async {
    Database db = await getDataBase();
    return await db.rawQuery("select * from $name where $columnId = '$id'");
  }

  //查询数据库所有
  Future<List<Map<String, dynamic>>> selectMapList() async {
    var db = await getDataBase();
    var result = await db.query(name);
    return result;
  }

  //获取数据库里所有
  Future<List<Paper>> getAllPaper() async {
    var mapList = await selectMapList();
    var count = mapList.length;
    List<Paper> list = List<Paper>();
    for (int i = 0; i < count; i++) {
      list.add(Paper.fromJson(mapList[i]));
    }
    return list;
  }

  //根据id查询
  Future<Paper> getPaperById(String id) async {
    List mapList = await selectPaperById(id); // Get 'Map List' from database
    var user = Paper.fromJson(mapList[0]);
    return user;
  }
  //根据id查询
  Future<List<Paper>> getPaperByIsSign(bool isSign) async {
    List<Map<String,dynamic>> mapList = await selectPaperByIsSign(isSign);
    var count = mapList.length;
    List<Paper> list = List<Paper>();
    for (int i = 0; i < count; i++) {
      list.add(Paper.fromJson(mapList[i]));
    }
    return list;
  }
  //根据id查询
  Future<List<Paper>> getPaperByParentId(String parentId) async {
    List<Map<String,dynamic>> mapList = await selectPaperByParentId(parentId);
    var count = mapList.length;
    List<Paper> list = List<Paper>();
    for (int i = 0; i < count; i++) {
      list.add(Paper.fromJson(mapList[i]));
    }
    return list;
  }
  ///查询数据
  Future selectPaperByParentId(String parentId) async {
    Database db = await getDataBase();
    String sql = "select * from $name where $columnParentxtm = '$parentId' ";
    return await db.rawQuery(sql);
  }

  Future selectPaperByIsSign(bool isSIgn) async {
    Database db = await getDataBase();
    String sql = "select * from $name where $columnIsSignImage = '${isSIgn?"1":"0"}' ";
    return await db.rawQuery(sql);
  }

  //增加数据
  Future<int> insertPaper(Paper paper) async {
    var db = await getDataBase();
    var result;
    List<Map<String,dynamic>> maps = await selectPaperById(paper.xtm);
    if(maps.length>0){
      result = await update(paper);
    }else{
      result = await db.insert(name, paper.toJson());
    }
    return result;
  }

  //更新数据
  Future<int> update(Paper paper) async {
    var database = await getDataBase();
    var result = await database.rawUpdate(
        "update $name set "
        "$columnId = ?,"
        "$columnParentxtm = ?,"
        "$columnDesc = ?"
        "$columnIsSignImage = ?"
        " where $columnId= ?",
        [
          paper.xtm,
          paper.parentxtm,
          paper.description,
          paper.isSignImage,
          paper.xtm,
        ]);
    return result;
  }

  //更新数据
  Future<int> updateWithSign(Paper paper) async {
    var database = await getDataBase();
    var result = await database.rawUpdate(
        "update $name set "
            "$columnId = ?,"
            "$columnIsSignImage = ?"
            " where $columnId= ?",
        [
          paper.xtm,
          paper.isSignImage?"1":"0",
          paper.xtm,
        ]);
    return result;
  }

  //删除数据
  Future<int> deletePaperByTaskId(String taskId) async {
    var db = await getDataBase();
    var result = await db.rawDelete("DELETE FROM $name WHERE $columnParentxtm = '$taskId'");
    return result;
  }

  @override
  tableUpdate() {
    return false;
  }

}

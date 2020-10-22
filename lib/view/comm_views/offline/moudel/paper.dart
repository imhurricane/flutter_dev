import 'package:flutter_dev/db/base_db_provider.dart';
import 'package:flutter_dev/view/comm_views/offline/moudel/equipment.dart';
import 'package:sqflite/sqflite.dart';

class Paper {

  String xtm;
  String parentxtm;
  String description;
  List<Equipment> equipment;

  Paper({this.xtm, this.parentxtm, this.description, this.equipment});

  Paper.fromJson(Map<String, dynamic> json) {
    xtm = json['xtm'];
    parentxtm = json['parentxtm'];
    description = json['description'];
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
    var mapList =
        await selectPaperById(id); // Get 'Map List' from database
    var user = Paper.fromJson(mapList[id]);
    return user;
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
    print('sql:'+sql);
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
        " where $columnId= ?",
        [
          paper.xtm,
          paper.parentxtm,
          paper.description,
          paper.xtm,
        ]);
    return result;
  }

  //删除数据
  Future<int> deleteTaskById(int id) async {
    var db = await getDataBase();
    var result = await db.rawDelete("DELETE FROM $name WHERE $columnId = '$id'");
    return result;
  }
}

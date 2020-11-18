
import 'package:flutter_dev/db/base_db_provider.dart';
import 'package:flutter_dev/view/comm_views/offline/moudel/riss.dart';
import 'package:sqflite/sqflite.dart';

class Equipment {
  String parentxtm;
  String xtm;
  String comp;
  String rwxtm;
  List<Riss> riss;
  String ywmk;
  String pjjb;
  String apptype;
  String description;

  Equipment(
      {this.parentxtm,
        this.xtm,
        this.comp,
        this.rwxtm,
        this.riss,
        this.ywmk,
        this.pjjb,
        this.apptype,
        this.description});

  Equipment.fromJson(Map<String, dynamic> json) {
    parentxtm = json['parentxtm'];
    xtm = json['xtm'];
    comp = json['comp'];
    rwxtm = json['rwxtm'];
    if (json['riss'] != null) {
      riss = new List<Riss>();
      json['riss'].forEach((v) {
        riss.add(new Riss.fromJson(v));
      });
    }
    ywmk = json['ywmk'];
    pjjb = json['pjjb'];
    apptype = json['apptype'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['parentxtm'] = this.parentxtm;
    data['xtm'] = this.xtm;
    data['comp'] = this.comp;
    data['rwxtm'] = this.rwxtm;
    if (this.riss != null) {
      data['riss'] = this.riss.map((v) => v.toJson()).toList();
    }
    data['ywmk'] = this.ywmk;
    data['pjjb'] = this.pjjb;
    data['apptype'] = this.apptype;
    data['description'] = this.description;
    return data;
  }
}

class EquipmentProvider extends BaseDbProvider{

  ///表名
  final String name = 'Equipment';

  final String columnId = "xtm";
  final String columnRwxtm = "rwxtm";
  final String columnParentxtm = "parentxtm";
  final String columnComp = "comp";
  final String columnYwmk = "ywmk";
  final String columnPjjb = "pjjb";
  final String columnApptype = "apptype";
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
        $columnRwxtm text not null,
        $columnComp text not null,
        $columnParentxtm text not null,
        $columnYwmk text not null,
        $columnApptype text not null,
        $columnPjjb text not null,
        $columnDesc text not null)
      ''';
  }

  ///查询数据
  Future selectEquipmentById(String id) async {
    Database db = await getDataBase();
    return await db.rawQuery("select * from $name where $columnId = '$id'");
  }

  ///查询数据
  Future selectEquipmentByParentId(String parentId) async {
    Database db = await getDataBase();
    String sql = "select * from $name where $columnParentxtm = '$parentId' ";
    print('sql:'+sql);
    return await db.rawQuery(sql);
  }
  ///查询数据
  Future selectEquipmentByTaskId(String parentId) async {
    Database db = await getDataBase();
    return await db.rawQuery("select * from $name where $columnRwxtm = '$parentId'");
  }

  //查询数据库所有
  Future<List<Map<String, dynamic>>> selectMapList() async {
    var db = await getDataBase();
    var result = await db.query(name);
    return result;
  }

  //获取数据库里所有
  Future<List<Equipment>> getAllEquipment() async{
    var equipmentMapList = await selectMapList();
    var count  = equipmentMapList.length;
    List<Equipment> equipmentList= List<Equipment>();
    for(int i=0;i<count;i++){
      equipmentList.add(Equipment.fromJson(equipmentMapList[i]));
    }
    return equipmentList;
  }

  //根据id查询
  Future<Equipment> getEquipmentById(String id) async {
    var noteMapList = await selectEquipmentById(id); // Get 'Map List' from database
    var equipment = Equipment.fromJson(noteMapList[id]);
    return equipment;
  }
  //根据id查询
  Future<List<Equipment>> getEquipmentByParentId(String parentId) async {
    var mapList = await selectEquipmentByParentId(parentId);
    var count = mapList.length;
    List<Equipment> list = List<Equipment>();
    for (int i = 0; i < count; i++) {
      list.add(Equipment.fromJson(mapList[i]));
    }
    return list;
  }

  //根据id查询
  Future<List<Equipment>> getEquipmentByTaskId(String parentId) async {
    var mapList = await selectEquipmentByTaskId(parentId);
    var count = mapList.length;
    List<Equipment> list = List<Equipment>();
    for (int i = 0; i < count; i++) {
      list.add(Equipment.fromJson(mapList[i]));
    }
    return list;
  }

  //增加数据
  Future<int> insertEquipment(Equipment equipment) async {
    var db = await getDataBase();
    var result;
    List<Map<String,dynamic>> maps = await selectEquipmentById(equipment.xtm);
    if(maps.length>0){
      result = await update(equipment);
    }else{
      result = await db.insert(name, equipment.toJson());
    }
    return result;
  }

  //更新数据
  Future<int> update(Equipment equipment) async {
    var database = await getDataBase();
    var result = await database.rawUpdate(
        "update $name set "
            "$columnId = ?,"
            "$columnRwxtm = ?,"
            "$columnComp = ?,"
            "$columnParentxtm = ?,"
            "$columnYwmk = ?,"
            "$columnPjjb = ?,"
            "$columnApptype = ?,"
            "$columnDesc = ?"
            " where $columnId= ?",
        [equipment.xtm,equipment.rwxtm,equipment.comp,equipment.parentxtm,equipment.ywmk,equipment.pjjb,
          equipment.apptype,equipment.description,equipment.xtm]);
    return result;
  }

  //删除数据
  Future<int> deleteEquipmentByTaskId(String taskId) async {
    var db = await getDataBase();
    var result = await db.rawDelete("DELETE FROM $name WHERE $columnRwxtm = '$taskId'");
    return result;
  }

  @override
  tableUpdate() {
    return false;
  }
}
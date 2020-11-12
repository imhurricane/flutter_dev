
import 'dart:convert';

import 'package:flutter_dev/db/base_db_provider.dart';
import 'package:flutter_dev/view/comm_views/offline/moudel/image.dart';
import 'package:sqflite/sqflite.dart';

class Riss {
  String xtm;
  String errdetail;
  String parentxtm;
  String rwxtm;
  String pjjb;
  String riskfactors;
  String fxffcs;
  String inactivemesure;
  String activemesure;
  String havemesure;
  List<RissImages> image;

  Riss(
      {this.xtm,
        this.errdetail,
        this.parentxtm,
        this.rwxtm,
        this.pjjb,
        this.riskfactors,
        this.fxffcs,
        this.inactivemesure,
        this.activemesure,
        this.havemesure,
        this.image,
      });

  Riss.fromJson(Map<String, dynamic> data) {
    xtm = data['xtm'];
    errdetail = data['errdetail'];
    parentxtm = data['parentxtm'];
    rwxtm = data['rwxtm'];
    pjjb = data['pjjb'];
    riskfactors = data['riskfactors'];
    fxffcs = data['fxffcs'];
    inactivemesure = data['inactivemesure'];
    activemesure = data['activemesure'];
    havemesure = data['havemesure'];
    if(data['image']!=null){
      List decode = json.decode(data['image']);
      image = List();
      decode.forEach((v) {
        image.add(new RissImages.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['xtm'] = this.xtm;
    data['errdetail'] = this.errdetail;
    data['parentxtm'] = this.parentxtm;
    data['rwxtm'] = this.rwxtm;
    data['pjjb'] = this.pjjb;
    data['riskfactors'] = this.riskfactors;
    data['fxffcs'] = this.fxffcs;
    data['inactivemesure'] = this.inactivemesure;
    data['activemesure'] = this.activemesure;
    data['havemesure'] = this.havemesure;
    if (this.image != null) {
      data['image'] = this.image.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RissProvider extends BaseDbProvider{

  ///表名
  final String name = 'Riss';

  final String columnId = "xtm";
  final String columnRwxtm = "rwxtm";
  final String columnErrdetail = "errdetail";
  final String columnParentxtm = "parentxtm";
  final String columnPjjb = "pjjb";
  final String columnRiskfactors = "riskfactors";
  final String columnFxffcs = "fxffcs";
  final String columnInactivemesure = "inactivemesure";
  final String columnActivemesure = "activemesure";
  final String columnHavemesure = "havemesure";
  final String columnImage = "image";

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
        $columnErrdetail text not null,
        $columnParentxtm text not null,
        $columnPjjb text not null,
        $columnRiskfactors text not null,
        $columnFxffcs text not null,
        $columnInactivemesure text not null,
        $columnActivemesure text not null,
        $columnImage text,
        $columnHavemesure text not null)
      ''';
  }

  ///查询数据
  Future selectRissById(String id) async {
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
  Future<List<Riss>> getAllRiss() async{
    var mapList = await selectMapList();
    var count  = mapList.length;
    List<Riss> list= List<Riss>();
    for(int i=0;i<count;i++){
      list.add(Riss.fromJson(mapList[i]));
    }
    return list;
  }

  //根据id查询
  Future<Riss> getRissById(String id) async {
    Riss riss;
    List<Map<String,dynamic>> mapList = await selectRissById(id); // Get 'Map List' from database
    if(mapList.length==1){
      riss = Riss.fromJson(mapList[0]);
    }
    return riss;
  }

  //增加数据
  Future<int> insertRiss(Riss riss,bool isUpdateCom) async {
    var db = await getDataBase();
    var result;
    List<Map<String,dynamic>> maps = await selectRissById(riss.xtm);
    if(maps.length>0){
      result = await update(riss,isUpdateCom);
    }else{
      result = await db.insert(name, riss.toJson());
    }
    return result;
  }

  //更新数据
  Future<int> update(Riss riss,bool isUpdateCom) async {
    var database = await getDataBase();
    String sql = "update $name set "
        "$columnId = ?,"
        "$columnRwxtm = ?,"
        "$columnErrdetail = ?,"
        "$columnParentxtm = ?,"
        "$columnPjjb = ?,"
        "$columnRiskfactors = ?,"
        "$columnImage = ?,"
        "$columnFxffcs = ?";
    List list = new List();
    list.add(riss.xtm);
    list.add(riss.rwxtm);
    list.add(riss.errdetail);
    list.add(riss.parentxtm);
    list.add(riss.pjjb);
    list.add(riss.riskfactors);
    String encode = json.encode(riss.image);
    list.add(encode);
    list.add(riss.fxffcs);

    if(isUpdateCom){
      sql += ",$columnInactivemesure = ?,"
      "$columnActivemesure = ?,"
      "$columnHavemesure = ?";
      list.add(riss.inactivemesure);
      list.add(riss.activemesure);
      list.add(riss.havemesure);
    }
    sql += " where $columnId= ?";
    list.add(riss.xtm);
    var result = await database.rawUpdate(sql,list);
    return result;
  }

  //删除数据
  Future<int> deleteRissById(int id) async {
    var db = await getDataBase();
    var result = await db.rawDelete("DELETE FROM $name WHERE $columnId = '$id'");
    return result;
  }

  ///查询数据
  Future selectRissByParentId(String parentId) async {
    Database db = await getDataBase();
    return await db.rawQuery("select * from $name where $columnParentxtm = '$parentId'");
  }

  Future<List<Riss>> getRissByParentId(String parentId) async{
    var mapList = await selectRissByParentId(parentId);
    var count = mapList.length;
    List<Riss> list = List<Riss>();
    for (int i = 0; i < count; i++) {
      list.add(Riss.fromJson(mapList[i]));
    }
    return list;
  }

}
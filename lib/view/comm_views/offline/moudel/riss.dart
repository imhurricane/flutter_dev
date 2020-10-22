
import 'package:flutter_dev/db/base_db_provider.dart';
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
        this.havemesure});

  Riss.fromJson(Map<String, dynamic> json) {
    xtm = json['xtm'];
    errdetail = json['errdetail'];
    parentxtm = json['parentxtm'];
    rwxtm = json['rwxtm'];
    pjjb = json['pjjb'];
    riskfactors = json['riskfactors'];
    fxffcs = json['fxffcs'];
    inactivemesure = json['inactivemesure'];
    activemesure = json['activemesure'];
    havemesure = json['havemesure'];
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
    var mapList = await selectRissById(id); // Get 'Map List' from database
    var user = Riss.fromJson(mapList[id]);
    return user;
  }

  //增加数据
  Future<int> insertRiss(Riss riss) async {
    var db = await getDataBase();
    var result;
    List<Map<String,dynamic>> maps = await selectRissById(riss.xtm);
    if(maps.length>0){
      result = await update(riss);
    }else{
      result = await db.insert(name, riss.toJson());
    }
    return result;
  }

  //更新数据
  Future<int> update(Riss riss) async {
    var database = await getDataBase();
    var result = await database.rawUpdate(
        "update $name set "
            "$columnId = ?,"
            "$columnRwxtm = ?,"
            "$columnErrdetail = ?,"
            "$columnParentxtm = ?,"
            "$columnPjjb = ?,"
            "$columnRiskfactors = ?,"
            "$columnFxffcs = ?,"
            "$columnInactivemesure = ?,"
            "$columnActivemesure = ?,"
            "$columnHavemesure = ?"
            " where $columnId= ?",
        [riss.xtm,riss.rwxtm,riss.errdetail,riss.parentxtm,riss.pjjb,riss.riskfactors,
          riss.fxffcs,riss.inactivemesure,riss.activemesure,riss.havemesure,riss.xtm]);
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
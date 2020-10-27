
import 'package:flutter_dev/db/base_db_provider.dart';
import 'package:sqflite/sqflite.dart';

class RissComplete {
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
  String checkData;
  String isUpload;
  String yhXtm;

  RissComplete(
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
        this.checkData,
        this.isUpload,
        this.yhXtm,
      });

  RissComplete.fromJson(Map<String, dynamic> json) {
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
    checkData = json['checkData'];
    isUpload = json['isUpload'];
    yhXtm = json['yhXtm'];
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
    data['checkData'] = this.checkData;
    data['isUpload'] = this.isUpload;
    data['yhXtm'] = this.yhXtm;
    return data;
  }
}

class RissCompleteProvider extends BaseDbProvider{

  ///表名
  final String name = 'RissComplete';

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
  final String columnCheckData = "checkData";
  final String columnIsUpload = "isUpload";
  final String columnYhXtm = "yhXtm";

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
        $columnCheckData text not null,
        $columnIsUpload text not null,
        $columnYhXtm text not null,
        $columnHavemesure text not null)
      ''';
  }

  ///查询数据
  Future selectRissById(String id) async {
    Database db = await getDataBase();
    return await db.rawQuery("select * from $name where $columnId = '$id'");
  }

  ///查询数据
  Future<List<RissComplete>> selectRissByIsUpload(String isUpload) async {
    Database db = await getDataBase();
    var mapList = await db.rawQuery("select * from $name where $columnIsUpload = '$isUpload'");
    var count  = mapList.length;
    List<RissComplete> list= List<RissComplete>();
    for(int i=0;i<count;i++){
      list.add(RissComplete.fromJson(mapList[i]));
    }
    return list;
  }

  //查询数据库所有
  Future<List<Map<String, dynamic>>> selectMapList() async {
    var db = await getDataBase();
    var result = await db.query(name);
    return result;
  }

  //获取数据库里所有
  Future<List<RissComplete>> getAllRiss() async{
    var mapList = await selectMapList();
    var count  = mapList.length;
    List<RissComplete> list= List<RissComplete>();
    for(int i=0;i<count;i++){
      list.add(RissComplete.fromJson(mapList[i]));
    }
    return list;
  }

  //根据id查询
  Future<RissComplete> getRissById(String id) async {
    RissComplete rissComplete;
    List<Map<String,dynamic>> mapList = await selectRissById(id); // Get 'Map List' from database
    if(mapList.length==1){
      rissComplete = RissComplete.fromJson(mapList[0]);
    }
    return rissComplete;
  }

  //增加数据
  Future<int> insertRiss(RissComplete riss) async {
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
  Future<int> update(RissComplete riss) async {
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
            "$columnCheckData = ?,"
            "$columnIsUpload = ?,"
            "$columnYhXtm = ?,"
            "$columnHavemesure = ?"
            " where $columnId= ?",
        [riss.xtm,riss.rwxtm,riss.errdetail,riss.parentxtm,riss.pjjb,riss.riskfactors,
          riss.fxffcs,riss.inactivemesure,riss.activemesure,
          riss.checkData,riss.isUpload,riss.yhXtm,riss.havemesure,riss.xtm]);
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

  Future<List<RissComplete>> getRissByParentId(String parentId) async{
    var mapList = await selectRissByParentId(parentId);
    var count = mapList.length;
    List<RissComplete> list = List<RissComplete>();
    for (int i = 0; i < count; i++) {
      list.add(RissComplete.fromJson(mapList[i]));
    }
    return list;
  }

}
import 'dart:collection';
import 'package:flutter_dev/db/base_db_provider.dart';
import 'package:sqflite/sqflite.dart';

class EntryModel {
  String id;
  String xtm;
  String dataType;
  String icon;
  String title;
  String toPage;
  String permission;
  bool isHtml;
  bool secondLevel;
  HashMap<String,dynamic> params;

  EntryModel({
        this.xtm,
        this.id,
        this.dataType,
        this.icon,
        this.title,
        this.toPage,
        this.permission,
        this.isHtml,
        this.params,
        this.secondLevel});

  EntryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    xtm = json['xtm'];
    dataType = json['dataType'];
    icon = json['icon'];
    title = json['title'];
    toPage = json['toPage'];
    permission = json['permission'];
    isHtml = json['isHtml'];
    secondLevel = json['secondLevel'];
    params = json['params'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['xtm'] = this.xtm;
    data['dataType'] = this.dataType;
    data['icon'] = this.icon;
    data['title'] = this.title;
    data['toPage'] = this.toPage;
    data['permission'] = this.permission;
    data['isHtml'] = this.isHtml;
    data['secondLevel'] = this.secondLevel;
    data['params'] = this.params;
    return data;
  }

}

class EntryModelProvider extends BaseDbProvider {

  ///表名
  final String name = 'EntryModel';

  final String columnId = "xtm";
  final String columnTitle = "title";
  final String columnIcon = "icon";
  final String columnDataType = "dataType";
  final String columnToPage = "toPage";
  final String columnIsHtml = "isHtml";
  final String columnSecondLevel = "secondLevel";
  final String columnParams = "params";

  EntryModelProvider();

  //获取表名称
  @override
  tableName() {
    return name;
  }

  //创建表操作
  @override
  createTableString() {
    return '''
        create table $name (
        $columnId text not null,
        $columnTitle text not null,
        $columnDataType text not null,
        $columnToPage text not null,
        $columnIsHtml text not null,
        $columnSecondLevel text not null,
        $columnParams text not null,
        $columnIcon text not null)
      ''';
  }

  ///查询数据
  Future selectUser(int id) async {
    Database db = await getDataBase();
    return await db.rawQuery("select * from $name where $columnId = $id");
  }

  //查询数据库所有
  Future<List<Map<String, dynamic>>> selectMapList() async {
    var db = await getDataBase();
    var result = await db.query(name);
    return result;
  }

  //获取数据库里所有user
  Future<List<EntryModel>> getAllUser() async{
    var userMapList = await selectMapList();
    var count  = userMapList.length;
    List<EntryModel> userList= List<EntryModel>();

    for(int i=0;i<count;i++){
      userList.add(EntryModel.fromJson(userMapList[i]));
    }
    return userList;
  }

  //根据id查询user
  Future<EntryModel> getUser(int id) async {
    var noteMapList = await selectUser(id); // Get 'Map List' from database
    var user = EntryModel.fromJson(noteMapList[id]);
    return user;
  }

  //增加数据
  Future<int> insertUser(EntryModel user) async {
    var db = await getDataBase();
    var result = await db.insert(name, user.toJson());
    return result;
  }

  //更新数据
  Future<int> update(EntryModel entryModel) async {
    var database = await getDataBase();
    var result = await database.rawUpdate(
        "update $name set "
            "$columnId = ?,"
            "$columnTitle = ? "
            "where $columnId= ?",
        [entryModel.xtm, entryModel.title, entryModel.xtm]);
    return result;
  }

  //删除数据
  Future<int> deleteUser(int id) async {
    var db = await getDataBase();
    var result = await db.rawDelete('DELETE FROM $name WHERE $columnId = $id');
    return result;
  }
}
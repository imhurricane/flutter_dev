
import 'package:flutter_dev/db/base_db_provider.dart';
import 'package:flutter_dev/view/comm_views/offline/moudel/paper.dart';
import 'package:sqflite/sqflite.dart';

class Task {
  String xtm;
  String comp;
  List<Paper> paper;
  String deptxtm;
  String taskdate;
  String description;

  Task(
      {this.xtm,
        this.comp,
        this.paper,
        this.deptxtm,
        this.taskdate,
        this.description});

  Task.fromJson(Map<String, dynamic> json) {
    xtm = json['xtm'];
    comp = json['comp'];
    if (json['paper'] != null) {
      paper = new List<Paper>();
      json['paper'].forEach((v) {
        paper.add(new Paper.fromJson(v));
      });
    }
    deptxtm = json['deptxtm'];
    taskdate = json['taskdate'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['xtm'] = this.xtm;
    data['comp'] = this.comp;
    if (this.paper != null) {
      data['paper'] = this.paper.map((v) => v.toJson()).toList();
    }
    data['deptxtm'] = this.deptxtm;
    data['taskdate'] = this.taskdate;
    data['description'] = this.description;
    return data;
  }
}

class TaskProvider extends BaseDbProvider{

  ///表名
  final String name = 'Task';
  final String columnId = "xtm";
  final String columnComp = "comp";
  final String columnDeptXtm = "deptxtm";
  final String columnTaskDate = "taskdate";
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
        $columnComp text not null,
        $columnDeptXtm text not null,
        $columnTaskDate text not null,
        $columnDesc text not null)
      ''';
  }

  ///查询数据
  Future selectTaskById(String id) async {
    Database db = await getDataBase();
    return await db.rawQuery("select * from $name where $columnId = '$id'");
  }

  //查询数据库所有
  Future<List<Map<String, dynamic>>> selectMapList() async {
    var db = await getDataBase();
    var result = await db.query(name,orderBy: "taskdate desc");
    return result;
  }

  //获取数据库里所有
  Future<List<Task>> getAllTask() async{
    var mapList = await selectMapList();
    var count  = mapList.length;
    List<Task> list= List<Task>();

    for(int i=0;i<count;i++){
      list.add(Task.fromJson(mapList[i]));
    }
    return list;
  }

  //根据id查询
  Future<Task> getTaskById(String id) async {
    Task task;
    List<Map<String,dynamic>> noteMapList = await selectTaskById(id); // Get 'Map List' from database
    if(noteMapList.length>0){
      task = Task.fromJson(noteMapList[0]);
    }
    return task;
  }

  //增加数据
  Future<int> insertTask(Task task) async {
    var db = await getDataBase();
    var result;
    List<Map<String,dynamic>> maps = await selectTaskById(task.xtm);
    if(maps.length>0){
      result = await update(task);
    }else{
      result = await db.insert(name, task.toJson());
    }
    return result;
  }

  //更新数据
  Future<int> update(Task task) async {
    var database = await getDataBase();
    var result = await database.rawUpdate(
        "update $name set "
            "$columnId = ?,"
            "$columnComp = ?,"
            "$columnDeptXtm = ?,"
            "$columnTaskDate = ?,"
            "$columnDesc = ?"
            " where $columnId= ?",
        [task.xtm,task.comp,task.deptxtm,task.taskdate,task.description,task.xtm]);
    return result;
  }

  //删除数据
  Future<int> deleteTaskById(String id) async {
    var db = await getDataBase();
    var result = await db.rawDelete("DELETE FROM $name WHERE $columnId = '$id'");
    return result;
  }

}
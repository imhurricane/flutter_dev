
import 'package:flutter_dev/db/base_db_provider.dart';
import 'package:sqflite/sqflite.dart';

class Task {
  String xtm;
  String comp;
  String deptxtm;
  String taskdate;
  String description;

  Task({this.xtm, this.comp, this.deptxtm, this.taskdate, this.description});

  Task.fromJson(Map<String, dynamic> json) {
    xtm = json['xtm'];
    comp = json['comp'];
    deptxtm = json['deptxtm'];
    taskdate = json['taskdate'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['xtm'] = this.xtm;
    data['comp'] = this.comp;
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
  Future selectTaskById(int id) async {
    Database db = await getDataBase();
    return await db.rawQuery("select * from $name where $columnId = $id");
  }

  //查询数据库所有
  Future<List<Map<String, dynamic>>> selectMapList() async {
    var db = await getDataBase();
    var result = await db.query(name);
    return result;
  }

  //获取数据库里所有
  Future<List<Task>> getAllTask() async{
    var userMapList = await selectMapList();
    var count  = userMapList.length;
    List<Task> userList= List<Task>();

    for(int i=0;i<count;i++){
      userList.add(Task.fromJson(userMapList[i]));
    }
    return userList;
  }

  //根据id查询
  Future<Task> getTaskById(int id) async {
    var noteMapList = await selectTaskById(id); // Get 'Map List' from database
    var user = Task.fromJson(noteMapList[id]);
    return user;
  }

  //增加数据
  Future<int> insertTask(Task task) async {
    var db = await getDataBase();
    var result = await db.insert(name, task.toJson());
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
            "$columnDesc = ?,"
            "where $columnId= ?",
        [task.xtm,task.comp,task.deptxtm,task.taskdate,task.description,task.xtm]);
    return result;
  }

  //删除数据
  Future<int> deleteTaskById(int id) async {
    var db = await getDataBase();
    var result = await db.rawDelete('DELETE FROM $name WHERE $columnId = $id');
    return result;
  }

}
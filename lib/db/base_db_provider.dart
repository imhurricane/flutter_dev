import 'package:sqflite/sqflite.dart';
import 'package:meta/meta.dart';
import 'db_manager.dart';

abstract class BaseDbProvider {

  bool isTableExits = false;

  createTableString();

  tableName();

  tableUpdate();

  ///创建表sql语句
  tableBaseString(String sql) {
    return sql;
  }
  ///更新表sql语句
  tableUpdateString(){}

  Future<Database> getDataBase() async {
    return await open();
  }

  ///super 函数对父类进行初始化
  @mustCallSuper
  prepare(name,String createSql) async {
    if (!isTableExits) {
      Database db = await DbManager.getCurrentDatabase();
      return await db.execute(createSql);
    }
  }
  ///super 函数对父类进行初始化
  @mustCallSuper
  upgrade(upgrade, List<String> updateSql) async {
    if (upgrade) {
      Database db = await DbManager.getCurrentDatabase();
      for(int i=0;i<updateSql.length;i++){
        await db.execute(updateSql[i]);
      }
    }
  }

  @mustCallSuper
  open() async {
    isTableExits = await DbManager.isTableExits(tableName());
    if (!isTableExits) {
      await prepare(tableName(), createTableString());
    }
    if(tableUpdate()){
      await upgrade(tableUpdate(),tableUpdateString());
    }
    return await DbManager.getCurrentDatabase();
  }
}
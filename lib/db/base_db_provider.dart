import 'package:sqflite/sqflite.dart';
import 'package:meta/meta.dart';
import 'db_manager.dart';

abstract class BaseDbProvider {

  bool isTableExits = false;

  createTableString();

  tableName();

  ///创建表sql语句
  tableBaseString(String sql) {
    return sql;
  }

  Future<Database> getDataBase() async {
    return await open();
  }

  ///super 函数对父类进行初始化
  @mustCallSuper
  prepare(name, String createSql) async {
    if (!isTableExits) {
      Database db = await DbManager.getCurrentDatabase();
      return await db.execute(createSql);
    }
  }

  @mustCallSuper
  open() async {
    isTableExits = await DbManager.isTableExits(tableName());
    if (!isTableExits) {
      await prepare(tableName(), createTableString());
    }
    return await DbManager.getCurrentDatabase();
  }
}
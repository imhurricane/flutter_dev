import 'package:sqflite/sqflite.dart';

class DbManager {

  static const _DBNAME = "test.db";

  static final dbContext = DbManager();

  static DbManager getInstance() {
    return dbContext;
  }

  ///创建数据库db
  createDb(int vers) async {
    //获取数据库路径
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + _DBNAME;
    print("数据库路径：$path数据库版本$vers");
    //打开数据库
    await openDatabase(path, version: vers,
        onUpgrade: (Database db, int oldVersion, int newVersion) async {
      //数据库升级,只回调一次
      print("数据库需要升级！旧版：$oldVersion,新版：$newVersion");
    }, onCreate: (Database db, int vers) async {
      //创建表，只回调一次
      await db.execute(_getUserTableSql());
      await db.close();
      print("正在创建数据库表");
    });
  }

  _getUserTableSql() {
    return '''create table userinfo(
      _id integer primary key autoincrement,
      displayname varchar(100),
      photourl varchar(200),
      uid varchar(100),
      platform char(10)
      )
    ''';
  }

  _getDbPath() async {
    //获取数据库路径
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + _DBNAME;
    return path;
  }

  Future<Database> openDb() async {
    var path = await _getDbPath();
//    if (ConstApp.IS_DEBUG) print("数据库路径：$path");

    Database db = await openDatabase(path);

    return db;
  }

  ///增
  insert(String tableName, String sql) async {
    var path = await _getDbPath();
//    if (ConstApp.IS_DEBUG) print("数据库路径：$path");

    Database db = await openDatabase(path);
    var rowaffect = await db.transaction<int>((txn) async {
      int count = await txn.rawInsert(sql);
      return count;
    });
    await db.close();
    return rowaffect;
  }

  ///删
  delete(String sql) async {
    var path = await _getDbPath();
    Database db = await openDatabase(path);
    int count = await db.rawDelete(sql);
    await db.close();
    return count;
  }

  ///改
  update(String sql, List arg) async {
    var path = await _getDbPath();
    Database db = await openDatabase(path);
    int count = await db.rawUpdate(sql, arg); //修改条件，对应参数值
    await db.close();
    return count;
  }

  ///查条数
  getQueryNum(String sql) async {
    var path = await _getDbPath();
    Database db = await openDatabase(path);
    int count = Sqflite.firstIntValue(await db.rawQuery(sql));
    await db.close();
    return count;
  }

  ///查全部
  query(String sql) async {
    var path = await _getDbPath();
    Database db = await openDatabase(path);
    List<Map> list = await db.rawQuery(sql);
    await db.close();
    return list;
  }
}

import 'package:sqflite/sqflite.dart';

class DbManager {

  static const _VERSION=1;

  static const _DBNAME = "database.db";

  static Database _database;

  ///初始化
  static init() async {
    var databasesPath=await getDatabasesPath();

    String path = databasesPath +"/"+ _DBNAME;
    _database = await openDatabase(path,version: _VERSION,
      readOnly: false,      //   是否只读
      singleInstance: true, //   是否单例
      // 第一个被调用的可选回调 配置数据库使用SQL语句配置
      onConfigure: (Database database)async{
        await database.execute("PRAGMA foreign_keys = ON");
        print("配置数据库");
      },
      // 创建数据库回调
      onCreate: (Database database,int version)async{
        print("版本:$version 数据库创建成功");
      },
      // 数据库降级回调
      onDowngrade: (Database database,int oldVersion,int newVersion)async{
        print("版本$oldVersion 降级到 $newVersion");
        var batch = database.batch();
//        batch.execute('');
        await batch.commit();
      },
      // 数据库升级回调
      onUpgrade: (Database database,int oldVersion,int newVersion)async{
        print("版本$oldVersion 升级到 $newVersion");
      },
      // 数据库打开回调
      onOpen: (Database database){
        print("数据库打开成功");
      },
    );
  }

  ///判断表是否存在
  static isTableExits(String tableName) async {
    await getCurrentDatabase();
    var res=await _database.rawQuery("select * from Sqlite_master where type = 'table' and name = '$tableName'");
    return res!=null && res.length >0;
  }

  ///获取当前数据库对象
  static Future<Database> getCurrentDatabase() async {
    if(_database == null){
      await init();
    }
    return _database;
  }

  ///关闭
  static close() {
    _database?.close();
    _database = null;
  }
}

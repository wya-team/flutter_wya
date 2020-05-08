library sqlmanager;

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqlmanager/model_turn.dart';

const String DBName = 'material.db';

class SqliteFile<T> {
  List keyWords = [
    "add",
    "all",
    "alter",
    "and",
    "as",
    "autoincrement",
    "between",
    "case",
    "check",
    "collate",
    "commit",
    "constraint",
    "create",
    "default",
    "deferrable",
    "delete",
    "distinct",
    "drop",
    "else",
    "escape",
    "except",
    "exists",
    "foreign",
    "from",
    "group",
    "having",
    "if",
    "in",
    "index",
    "insert",
    "intersect",
    "into",
    "is",
    "isnull",
    "join",
    "limit",
    "not",
    "notnull",
    "null",
    "on",
    "or",
    "order",
    "primary",
    "references",
    "select",
    "set",
    "table",
    "then",
    "to",
    "transaction",
    "union",
    "unique",
    "update",
    "using",
    "values",
    "when",
    "where"
  ];

  Database database;

  /// 获取数据局在本地路径
  Future<String> dbpath() async {
    return await getDatabasesPath();
  }

  /// 打开数据库，如果第一次打开数据库没有的话就去创建
  Future<Database> open() async {
    var databasesPath = await dbpath();
    String path = join(databasesPath, DBName);
    print('path==$path');
    bool ishave = await databaseExists(path);
    print('isHave==$ishave');
//    if (ishave) return;
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
    });
    return database;
  }

  /// 判断表是否存在
  /// tableName 表名
  Future<bool> isTableExits(String tableName) async {
    if (tableName == 'table' || tableName == 'Table') {
      return false;
    }
    var sql =
        "SELECT * FROM sqlite_master WHERE TYPE = 'table' AND NAME = '$tableName'";
    var res = await database.rawQuery(sql);
    var returnRes = res != null && res.length > 0;
    return returnRes;
  }

  /// 创建表
  /// tableName 表名
  /// keys 对应模型的属性，example：['name', 'age', 'sex']
  /// types 属性中对应的类型只支持SQL默认类型：['TEXT','INTEGER','INTEGER']
  ///       NULL，
  ///       INTEGER，
  ///       REAL，（int和double都支持）
  ///       TEXT,
  ///       BLOB, (dart中的Uint8List类型，虽然能够存储List< int >，但官方并不建议，因为转化比较慢。)
  Future<bool> createTable(
      String tableName, List<String> keys, List<String> types) async {

    if (tableName == 'table' || tableName == 'Table') {
      return false;
    }
//    List<String> keys = ModelTurn.paramsToList(map);
//    List<String> types = ModelTurn.paramsTypeToList(map);
    if (keys.length != types.length) {
      return false;
    }
    var sql = 'CREATE TABLE $tableName (id INTEGER PRIMARY KEY,';
    for (var i = 0; i < keys.length; i++) {
      if (i == keys.length - 1) {
        sql = sql + ' ' + keys[i] + ' ' + types[i];
      } else {
        sql = sql + ' ' + keys[i] + ' ' + types[i] + ',';
      }
    }
    sql = sql + ')';
    print('sql==$sql');
    await database.execute(sql);
    return true;
  }

  /// 插入数据
  /// tableName 表名
  /// map 需要插入的数据，example：{'name':'李四','age':18}
  Future<int> insert(String tableName, Map<String, dynamic> map) async {
    return await database.insert(tableName, map);
  }

  /// 查询语句
  /// tableName 表名
  /// list 需要查询的列，example:['age']
  /// distinct 是否是独特的，即是否不让重复
  /// where 查询条件 example: 'age > ?'
  /// whereArgs 查询条件参数 example: [18]
  /// groupBy 按列分组 example: 'name' 暂时没搞懂
  /// having 给分组设置条件 example: 'count(name) < 2' 暂时没搞懂
  /// orderBy 按列排序 asc/desc example: 'name asc'
  /// limit 限制查询结果数量
  /// offset 跳过几条数据
  Future<List<Map<String, dynamic>>> query(String tableName, List<String> list,
      {bool distinct = false,
      String where,
      List<dynamic> whereArgs,
      String groupBy,
      String having,
      String orderBy,
      int limit = 100000000000000,
      int offset = 0}) async {
    return await database.query(tableName,
        columns: list,
        distinct: distinct,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset);
//      return await database.query(tableName);
  }

  /// 删除数据
  /// tableName 表名
  /// where 条件 example：'age=?'
  /// list 条件中对应的值 example：[18,20]
  Future<int> delete(String tableName, String where, List<dynamic> list) async {
    return await database.delete(tableName, where: where, whereArgs: list);
  }

  /// 更新数据
  /// updateMap 要更新的数据 example：{'name':'李四','age':18}
  /// where 条件 example：'age=?'
  /// list 条件中对应的值 example：[18,20]
  Future<int> update(String tableName, Map updateMap,
      {String where, List<dynamic> list}) async {
    return await database.update(tableName, updateMap,
        where: where, whereArgs: list);
  }

  /// 关闭数据库
  Future<bool> close() async {
    database?.close();
    database = null;
  }
}

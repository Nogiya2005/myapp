import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class Dicdb {
  final int? item_id;
  final String? word;
  final String? mean;
  final int? level;

  Dicdb({this.item_id, this.word, this.mean, this.level});

  Map<String, dynamic> tomap() {
    return {
      'item_id': item_id,
      'word': word,
      'mean': mean,
      'level': level,
    };
  }

  static Future<Database> get ddb async {
    var databasesPath = await getApplicationSupportDirectory();
    var dbfilePath = databasesPath.path;
    var path = join(dbfilePath, "asset_dicdb.db");

// 存在すれば削除
    await deleteDatabase(path);

// 親ディレクトリが存在することを確認する
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

// アセットからコピー
    ByteData data = await rootBundle.load(join("assets", "ejdict_1.db"));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await new File(path).writeAsBytes(bytes, flush: true);

// DBファイルを開く
    var ddb = await openDatabase(path, readOnly: true);
    return ddb;
  }

  static Future<List<Dicdb>> getwords(String text) async {
    final Database Ddb = await ddb;
    List<Map<String, dynamic>> maps = await Ddb.query('items',
        where: 'word LIKE ?', whereArgs: ['%${text}%'], orderBy: 'level DESC');
    return List.generate(maps.length, (i) {
      return Dicdb(
        item_id: maps[i]['item_id'],
        word: maps[i]['word'],
        mean: maps[i]['mean'],
        level: maps[i]['level'],
      );
    });
  }

  static Future<List<Dicdb>> getallwords(String text) async {
    final Database Ddb = await ddb;
    List<Map<String, dynamic>> maps = await Ddb.query(
      'items',
      where: 'word LIKE ?',
      whereArgs: ['%${text}%'],
    );
    return List.generate(maps.length, (i) {
      return Dicdb(
        item_id: maps[i]['item_id'],
        word: maps[i]['word'],
        mean: maps[i]['mean'],
        level: maps[i]['level'],
      );
    });
  }

  static Future<List<Dicdb>> getmeans(String text) async {
    final Database Ddb = await ddb;
    List<Map<String, dynamic>> maps = await Ddb.query('items',
        where: 'mean LIKE ?', whereArgs: ['%${text}%'], orderBy: 'level DESC');
    return List.generate(maps.length, (i) {
      return Dicdb(
        item_id: maps[i]['item_id'],
        word: maps[i]['word'],
        mean: maps[i]['mean'],
        level: maps[i]['level'],
      );
    });
  }
}

class Foldb {
  final int? keynumber;
  String? foldername;
  int? Developer;
  int? OrderIndex;

  Foldb({this.keynumber, this.foldername, this.Developer, this.OrderIndex});

  Map<String, dynamic> tomap() {
    return {
      'keynumber': keynumber, //+1で管理予定
      'foldername': foldername, //フォルダの名前(変更可)
      'Developer': Developer, //0と1で管理予定
      'OrderIndex': OrderIndex,
    };
  }

  static Future<Database> get foldb async {
    var databasesPath = await getApplicationSupportDirectory();
    var dbfilePath = databasesPath.path;
    // openDatabase() データベースに接続
    final Future<Database> _database = openDatabase(
      // getDatabasesPath() データベースファイルを保存するパス取得
      join(dbfilePath, 'folder_database.db'),
      onCreate: (db, version) {
        return db.execute(
          // テーブルの作成
          "CREATE TABLE folder(keynumber INTEGER NOT NULL UNIQUE, foldername TEXT NOT NULL, Developer	INTEGER NOT NULL, OrderIndex	INTEGER NOT NULL)",
        );
      },
      version: 1,
    );
    return _database;
  }

//データの取得
  static Future<List<Foldb>> getallfolders() async {
    final Database _foldb = await foldb;
    List<Map<String, dynamic>> maps =
        await _foldb.query('folder', orderBy: 'OrderIndex ASC');
    return List.generate(maps.length, (i) {
      return Foldb(
        keynumber: maps[i]['keynumber'],
        foldername: maps[i]['foldername'],
        Developer: maps[i]['Developer'],
        OrderIndex: maps[i]['OrderIndex'],
      );
    });
  }

  static Future<List<Foldb>> getkeyfolders(String key) async {
    final Database _foldb = await foldb;
    List<Map<String, dynamic>> maps = await _foldb.query('folder',
        where: 'foldername LIKE ?',
        whereArgs: ['%${key}%'],
        orderBy: 'keynumber ASC');
    return List.generate(maps.length, (i) {
      return Foldb(
        keynumber: maps[i]['keynumber'],
        foldername: maps[i]['foldername'],
        Developer: maps[i]['Developer'],
        OrderIndex: maps[i]['OrderIndex'],
      );
    });
  }

//データの追加
  static Future<void> insertFol(Foldb folder) async {
    final Database _foldb = await foldb;
    await _foldb.insert(
      'folder',
      folder.tomap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

//データの更新
  static Future<void> updateFol(Foldb folder, var updatekey) async {
    final _foldb = await foldb;
    await _foldb.update(
      'folder',
      folder.tomap(),
      where: "keynumber = ?",
      whereArgs: [updatekey],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

//データの削除
  static Future<void> deleteFol(var keynumber) async {
    final _foldb = await foldb;
    await _foldb.delete(
      'folder',
      where: "keynumber = ?",
      whereArgs: [keynumber],
    );
  }

  static Future<void> deleteallFol() async {
    final _foldb = await foldb;
    await _foldb.delete('folder');
  }
}

class Favworddb {
  final String? dicname;
  final String? word;
  final int? key;
  int? ordernumber;
  int? colornumber;
  String? url;

  Favworddb(
      {this.dicname,
      this.word,
      this.key,
      this.ordernumber,
      this.colornumber,
      this.url});

  Map<String, dynamic> tomap() {
    return {
      'dicname': dicname,
      'word': word,
      'key': key,
      'ordernumber': ordernumber,
      'colornumber': colornumber,
      'url': url
    };
  }

  static Future<Database> get favworddb async {
    var databasesPath = await getApplicationSupportDirectory();
    var dbfilePath = databasesPath.path;
    // openDatabase() データベースに接続
    final Future<Database> _database = openDatabase(
      // getDatabasesPath() データベースファイルを保存するパス取得
      join(dbfilePath, 're_favword_database.db'),
      onCreate: (db, version) {
        return db.execute(
          // テーブルの作成
          "CREATE TABLE favword(dicname TEXT NOT NULL, word TEXT NOT NULL, key INTEGER NOT NULL, ordernumber INTEGER NOT NULL, colornumber INTEGER NOT NULL, url TEXT NOT NULL)",
        );
      },
      version: 1,
    );
    return _database;
  }

//データの取得
  static Future<List<Favworddb>> getallfavwords() async {
    final Database _favworddb = await favworddb;
    List<Map<String, dynamic>> maps =
        await _favworddb.query('favword', orderBy: 'key ASC');
    return List.generate(maps.length, (i) {
      return Favworddb(
        dicname: maps[i]['dicname'],
        word: maps[i]['word'],
        key: maps[i]['key'],
        ordernumber: maps[i]['ordernumber'],
        colornumber: maps[i]['colornumber'],
        url: maps[i]['url'],
      );
    });
  }

  static Future<List<Favworddb>> getkeyfavword(int key) async {
    final Database _favworddb = await favworddb;
    List<Map<String, dynamic>> maps = await _favworddb.query('favword',
        where: 'key = ?', whereArgs: [key], orderBy: 'ordernumber ASC');
    return List.generate(maps.length, (i) {
      return Favworddb(
        dicname: maps[i]['dicname'],
        word: maps[i]['word'],
        key: maps[i]['key'],
        ordernumber: maps[i]['ordernumber'],
        colornumber: maps[i]['colornumber'],
        url: maps[i]['url'],
      );
    });
  }

  static Future<List<Favworddb>> getdicword(int key, String dicname) async {
    final Database _favworddb = await favworddb;
    List<Map<String, dynamic>> maps = await _favworddb.query('favword',
        where: 'key = ? AND dicname = ?',
        whereArgs: [key, dicname],
        orderBy: 'ordernumber ASC');
    return List.generate(maps.length, (i) {
      return Favworddb(
        dicname: maps[i]['dicname'],
        word: maps[i]['word'],
        key: maps[i]['key'],
        ordernumber: maps[i]['ordernumber'],
        colornumber: maps[i]['colornumber'],
        url: maps[i]['url'],
      );
    });
  }

  static Future<List<Favworddb>> get3dicword(
      int key, String dicname1, String dicname2, String dicname3) async {
    final Database _favworddb = await favworddb;
    List<Map<String, dynamic>> maps = await _favworddb.query('favword',
        where:
            'key = ? AND dicname = ? OR key = ? AND dicname = ? OR key = ? AND dicname = ?',
        whereArgs: [key, dicname1, key, dicname2, key, dicname3],
        orderBy: 'ordernumber ASC');
    return List.generate(maps.length, (i) {
      return Favworddb(
        dicname: maps[i]['dicname'],
        word: maps[i]['word'],
        key: maps[i]['key'],
        ordernumber: maps[i]['ordernumber'],
        colornumber: maps[i]['colornumber'],
        url: maps[i]['url'],
      );
    });
  }

  static Future<List<Favworddb>> get2dicword(
      int key, String dicname1, String dicname2) async {
    final Database _favworddb = await favworddb;
    List<Map<String, dynamic>> maps = await _favworddb.query('favword',
        where: 'key = ? AND dicname = ? OR key = ? AND dicname = ?',
        whereArgs: [key, dicname1, key, dicname2],
        orderBy: 'ordernumber ASC');
    return List.generate(maps.length, (i) {
      return Favworddb(
        dicname: maps[i]['dicname'],
        word: maps[i]['word'],
        key: maps[i]['key'],
        ordernumber: maps[i]['ordernumber'],
        colornumber: maps[i]['colornumber'],
        url: maps[i]['url'],
      );
    });
  }

  static Future<List<Favworddb>> get1dicword(int key, String dicname1) async {
    final Database _favworddb = await favworddb;
    List<Map<String, dynamic>> maps = await _favworddb.query('favword',
        where: 'key = ? AND dicname = ?',
        whereArgs: [key, dicname1],
        orderBy: 'ordernumber ASC');
    return List.generate(maps.length, (i) {
      return Favworddb(
        dicname: maps[i]['dicname'],
        word: maps[i]['word'],
        key: maps[i]['key'],
        ordernumber: maps[i]['ordernumber'],
        colornumber: maps[i]['colornumber'],
        url: maps[i]['url'],
      );
    });
  }

  static Future<List<Favworddb>> getkeysameword(
      int key, String dicname, String word) async {
    final Database _favworddb = await favworddb;
    List<Map<String, dynamic>> maps = await _favworddb.query(
      'favword',
      where: 'key = ? AND dicname = ? AND word = ?',
      whereArgs: [key, dicname, word],
    );
    return List.generate(maps.length, (i) {
      return Favworddb(
        dicname: maps[i]['dicname'],
        word: maps[i]['word'],
        key: maps[i]['key'],
        ordernumber: maps[i]['ordernumber'],
        colornumber: maps[i]['colornumber'],
        url: maps[i]['url'],
      );
    });
  }

//データの追加
  static Future<void> insertfavword(Favworddb favword) async {
    final Database _favworddb = await favworddb;
    await _favworddb.insert(
      'favword',
      favword.tomap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

//データの更新
  static Future<void> updatefavword(Favworddb favword, int updatekey,
      String updatedicname, String updateword) async {
    final _favworddb = await favworddb;
    await _favworddb.update(
      'favword',
      favword.tomap(),
      where: "dicname = ? AND word = ? AND key = ?",
      whereArgs: [updatedicname, updateword, updatekey],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

//データの削除
  static Future<void> deletefavword(
      var deletekey, var deletedicname, var deleteword) async {
    final _favworddb = await favworddb;
    await _favworddb.delete(
      'favword',
      where: "key = ? AND dicname = ? AND word = ?",
      whereArgs: [deletekey, deletedicname, deleteword],
    );
  }

  static Future<void> deletefolword(var deletekey) async {
    final _favworddb = await favworddb;
    await _favworddb.delete(
      'favword',
      where: "key = ?",
      whereArgs: [deletekey],
    );
  }

  static Future<void> deleteallfavword() async {
    final _favworddb = await favworddb;
    await _favworddb.delete('favword');
  }
}

class Psmeandb {
  final String? dicname;
  final String? word;
  String? mean;
  final int? key;
  int? colornumber;

  Psmeandb({this.dicname, this.word, this.mean, this.key, this.colornumber});

  Map<String, dynamic> tomap() {
    return {
      'dicname': dicname,
      'word': word,
      'mean': mean,
      'key': key,
      'colornumber': colornumber,
    };
  }

  static Future<Database> get psmeandb async {
    var databasesPath = await getApplicationSupportDirectory();
    var dbfilePath = databasesPath.path;
    // openDatabase() データベースに接続
    final Future<Database> _database = openDatabase(
      // getDatabasesPath() データベースファイルを保存するパス取得
      join(dbfilePath, 'psmean_database.db'),
      onCreate: (db, version) {
        return db.execute(
          // テーブルの作成
          "CREATE TABLE psmean(dicname TEXT NOT NULL, word TEXT NOT NULL, mean TEXT NOT NULL, key	INTEGER NOT NULL, colornumber	INTEGER NOT NULL)",
        );
      },
      version: 1,
    );
    return _database;
  }

//データの取得
  static Future<List<Psmeandb>> getallfavwords() async {
    final Database _favworddb = await psmeandb;
    List<Map<String, dynamic>> maps =
        await _favworddb.query('psmean', orderBy: 'key ASC');
    return List.generate(maps.length, (i) {
      return Psmeandb(
        dicname: maps[i]['dicname'],
        word: maps[i]['word'],
        mean: maps[i]['mean'],
        key: maps[i]['key'],
        colornumber: maps[i]['colornumber'],
      );
    });
  }

  static Future<List<Psmeandb>> getkeypsmean(
      int key, String dicname, String word) async {
    final Database _psmeandb = await psmeandb;
    List<Map<String, dynamic>> maps = await _psmeandb.query('psmean',
        where: 'key = ? AND dicname = ? AND word = ?',
        whereArgs: [key, dicname, word]);
    return List.generate(maps.length, (i) {
      return Psmeandb(
        dicname: maps[i]['dicname'],
        word: maps[i]['word'],
        mean: maps[i]['mean'],
        key: maps[i]['key'],
        colornumber: maps[i]['colornumber'],
      );
    });
  }

  static Future<List<Psmeandb>> getkeycolorpsmean(
      int key, String dicname, String word) async {
    final Database _psmeandb = await psmeandb;
    List<Map<String, dynamic>> maps = await _psmeandb.query('psmean',
        where:
            'key = ? AND dicname = ? AND word = ? AND colornumber != 4278190080',
        whereArgs: [key, dicname, word]);
    return List.generate(maps.length, (i) {
      return Psmeandb(
        dicname: maps[i]['dicname'],
        word: maps[i]['word'],
        mean: maps[i]['mean'],
        key: maps[i]['key'],
        colornumber: maps[i]['colornumber'],
      );
    });
  }

//データの追加
  static Future<void> insertpsmean(Psmeandb psmean) async {
    final Database _psmeandb = await psmeandb;
    await _psmeandb.insert(
      'psmean',
      psmean.tomap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

//データの更新
  static Future<void> updatepsmean(Psmeandb psmean, var updatekey,
      var updatedicname, var updateword, var updatemean) async {
    final _psmeandb = await psmeandb;
    await _psmeandb.update(
      'psmean',
      psmean.tomap(),
      where: "key = ? AND dicname = ? AND word = ? AND mean = ?",
      whereArgs: [updatekey, updatedicname, updateword, updatemean],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

//データの削除
  static Future<void> deletepsmean(
      var deletekey, var deletedicname, var deleteword) async {
    final _psmeandb = await psmeandb;
    await _psmeandb.delete(
      'psmean',
      where: "key = ? AND dicname = ? AND word = ?",
      whereArgs: [deletekey, deletedicname, deleteword],
    );
  }

  static Future<void> deletefolmean(var deletekey) async {
    final _psmeandb = await psmeandb;
    await _psmeandb.delete(
      'psmean',
      where: "key = ?",
      whereArgs: [deletekey],
    );
  }

  static Future<void> deleteallpsmean() async {
    final _psmeandb = await psmeandb;
    await _psmeandb.delete('psmean');
  }
}

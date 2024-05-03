import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:to_do_app/Globals/Variables.dart';
import 'package:to_do_app/Screens/Home.dart';
import 'package:to_do_app/Screens/ListUsers.dart';

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    Print("3");
    await database.execute("""create table tasks(
        id INTEGER primary key autoincrement NOT NULL,
        task TEXT,
        ddate TEXT,
        dtime TEXT DEFAULT NULL,
        type TEXT DEFAULT 'Default[All]',
        notId INTEGER,
        overdue int DEFAULT 0,
        fev int DEFAULT 0,
        userId int NOT NULL
      )""");
    Print("4");
    await database.execute("""create table users(
        id INTEGER primary key autoincrement NOT NULL,
        name TEXT,
        isLogedin int DEFAULT 0
      );""");
    Print("5");
  }

  static Future<bool> isUserNull() async {
    final db = await SQLHelper.db();
    List<Map<String, dynamic>> data = await db.query(
      'users',
    );
    if (data.isNotEmpty) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> isUserLogedin() async {
    final db = await SQLHelper.db();
    List<Map<String, dynamic>> data =
        await db.query('users', where: "isLogedin = ?", whereArgs: [1]);
    if (data.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static Future<sql.Database> db() async {
    Print("1");
    return sql.openDatabase('todolist', version: 1,
        onCreate: (sql.Database database, int version) async {
      Print("2");
      await createTables(database);
    });
  }

  static Future<int> createUser(String name) async {
    try {
      final db = await SQLHelper.db();
      final data = {
        'name': name,
      };
      final id = await db.insert('users', data);
      await db.update("users", {"isLogedin": 1},
          where: "id = ?", whereArgs: [id]);
      return id;
    } on sql.DatabaseException catch (e) {
      Print(e.result.toString());
      return 0;
    } on Exception catch (e) {
      Print(e.toString());
      return 0;
    }
  }

  static Future<int> createTask(
      String desc, String date, String time, String type, int notId) async {
    final db = await SQLHelper.db();
    final data = {
      'task': desc,
      'ddate': date,
      'dtime': time,
      'type': type,
      'notId': notId,
      'userId': currentUserId,
    };
    final id = await db.insert('tasks', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<Map<String, dynamic>> getCurrentUser() async {
    final db = await SQLHelper.db();

    List<Map<String, dynamic>> data =
        await db.query('users', where: 'isLogedin = ?', whereArgs: [1]);
    Print(data.toString());
    if (data.isEmpty) {
      return {};
    } else {
      return data[0];
    }
  }

  static Future<void> deleteUser(int id) async {
    final db = await SQLHelper.db();
    await db.delete("users", where: "id = ?", whereArgs: [id]);
  }

  static Future<int> updateTask(
      int id, String desc, String date, String time, String type) async {
    final db = await SQLHelper.db();
    final data = {
      'task': desc,
      'ddate': date,
      'dtime': time,
      'type': type,
    };
    final result =
        await db.update('tasks', data, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  static Future<int> updateOverdue(int id, int overdue) async {
    final db = await SQLHelper.db();
    final data = {
      'overdue': overdue,
    };
    final result =
        await db.update('tasks', data, where: 'notId = ?', whereArgs: [id]);
    return result;
  }

  static Future<int> updateOverduebyId(int id, int overdue) async {
    final db = await SQLHelper.db();
    final data = {
      'overdue': overdue,
    };
    final result =
        await db.update('tasks', data, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  static Future<int> updateFev(int id, int fev) async {
    final db = await SQLHelper.db();
    final data = {
      'fev': fev,
    };
    final result =
        await db.update('tasks', data, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  static Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await SQLHelper.db();
    return db.query("users");
  }

  static Future<List<Map<String, dynamic>>> getTasks(String? type) async {
    final db = await SQLHelper.db();
    final data = ['id', 'task', 'ddate', 'dtime', 'notId', 'type', 'overdue'];
    if (type == null) {
      return await db.query('tasks',
          columns: data, where: 'overdue = ?', whereArgs: [0], orderBy: 'id');
    } else {
      return await db.query('tasks',
          columns: data,
          where: 'type = ? and overdue = ?',
          whereArgs: [type, 0],
          orderBy: 'id');
    }
  }

  static Future<List<Map<String, dynamic>>> getOverdues(String? type) async {
    final db = await SQLHelper.db();
    final data = ['id', 'task', 'ddate', 'dtime', 'notId', 'type', 'overdue'];
    if (type == null) {
      return await db.query('tasks',
          columns: data, where: 'overdue = ?', whereArgs: [1], orderBy: 'id');
    } else {
      return await db.query('tasks',
          columns: data,
          where: 'type = ? and overdue = ?',
          whereArgs: [type, 1],
          orderBy: 'id');
    }
  }

  static Future<List<Map<String, dynamic>>> getFev(String? type) async {
    final db = await SQLHelper.db();
    final data = ['id', 'task', 'ddate', 'dtime', 'notId', 'type', 'overdue'];
    if (type == null) {
      return await db.query('tasks',
          columns: data, where: 'fev = ?', whereArgs: [1], orderBy: 'id');
    } else {
      return await db.query('tasks',
          columns: data,
          where: 'type = ? and fev = ?',
          whereArgs: [type, 1],
          orderBy: 'id');
    }
  }

  static Future<List<Map<String, dynamic>>> search(
      String str, String type) async {
    final db = await SQLHelper.db();
    if (type == 'overdue') {
      return await db.query('tasks',
          where: 'overdue = ? and task LIKE ?', whereArgs: [1, '%$str%']);
    } else if (type == 'fev') {
      return await db.query('tasks',
          where: 'fev = ? and task LIKE ?', whereArgs: [1, '%$str%']);
    } else {
      return await db.query('tasks',
          where: 'overdue = ? and task LIKE ?', whereArgs: [0, '%$str%']);
    }
  }

  static Future<void> login(int id, BuildContext context) async {
    final db = await SQLHelper.db();
    await db.update("users", {"isLogedin": 1},
        where: "id = ?", whereArgs: [id]);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false);
  }

  static Future<void> logout(int id, BuildContext context) async {
    final db = await SQLHelper.db();
    await db.update("users", {"isLogedin": 0},
        where: "id = ?", whereArgs: [id]);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const UsersAvailable()),
        (route) => false);
  }

  static Future<void> deletTask(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('tasks', where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong : $err");
    }
  }

  static Future<void> completeTask(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('tasks', where: "notId = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong : $err");
    }
  }

  static Future<void> deletAllTasks() async {
    final db = await SQLHelper.db();
    try {
      await db.delete('tasks');
    } catch (err) {
      debugPrint("Something went wrong : $err");
    }
  }
}

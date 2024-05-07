import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:to_do_app/Config/NotificationHelper.dart';
import 'package:to_do_app/Globals/Variables.dart';
import 'package:to_do_app/Models/Task.dart';
import 'package:to_do_app/Screens/Home.dart';
import 'package:to_do_app/Screens/ListUsers.dart';

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""create table tasks(
        id INTEGER primary key autoincrement NOT NULL,
        task TEXT,
        ddate TEXT,
        dtime TEXT DEFAULT NULL,
        type TEXT DEFAULT 'Default[All]',
        repeteType TEXT NOT NULL,
        notId INTEGER NOT NULL,
        overdue int DEFAULT 0,
        fev int DEFAULT 0,
        userId int NOT NULL
      )""");
    await database.execute("""create table users(
        id INTEGER primary key autoincrement NOT NULL,
        name TEXT,
        isLogedin int DEFAULT 0
      );""");
    await database.execute("""create table notify(
        id INTEGER primary key NOT NULL,
        notId int NOT NULL,
        desc TEXT NOT NULL,
        ddate TEXT NOT NULL,
        dtime TEXT NOT NULL
      );""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('todolist', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<int> getOverdueCount() async {
    final db = await SQLHelper.db();
    var data = await db.query("tasks", where: "overdue = ?", whereArgs: [1]);
    return data.length;
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

  static Future<int> createTask(String desc, String date, String time,
      String type, String repeteType) async {
    final db = await SQLHelper.db();
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT MAX(notId) AS max_notId FROM tasks');
    int? currNotId = result.first['max_notId'];
    currNotId ??= 0;
    final data = {
      'task': desc,
      'ddate': date,
      'dtime': time,
      'type': type,
      'userId': currentUser['id'],
      'notId': ++currNotId,
      'repeteType': repeteType
    };
    final id = await db.insert('tasks', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    Print("Task $desc created Successfully !!");
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

  static Future<List<Map<String, Object?>>> getNotifications() async {
    final db = await SQLHelper.db();
    return await db.query("notify");
  }

  static Future<void> deleteUser(int id) async {
    final db = await SQLHelper.db();
    await db.delete("users", where: "id = ?", whereArgs: [id]);
  }

  static Future<int> updateTask(int id, String desc, String date, String time,
      String type, String repete) async {
    final db = await SQLHelper.db();
    final data = {
      'task': desc,
      'ddate': date,
      'dtime': time,
      'type': type,
      'repeteType': repete,
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
    if (type == null) {
      return await db.query('tasks',
          where: "userId = ?",
          whereArgs: [currentUser['id']],
          orderBy: "overdue");
    } else {
      return await db.query('tasks',
          where: 'type = ? and userId = ?',
          whereArgs: [type, currentUser['id']],
          orderBy: 'id');
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

  static Future<void> completeTask(int id) async {
    final db = await SQLHelper.db();
    try {
      final notId = await db.query("tasks", where: "id = ?", whereArgs: [id]);
      Task task = Task.fromMap(notId.first);
      await db.delete('tasks', where: "id = ?", whereArgs: [id]);
      NotificationHelper.cancleNotification(task.notId);
    } catch (err) {
      debugPrint("Something went wrong : $err");
    }
  }
}

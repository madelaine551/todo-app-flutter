import 'package:flutter/cupertino.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/services/dataresources/todo_dataresource.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalSQLiteDatasource implements TodoDatasource {
  late Database database;
  bool initialised = false;

  LocalSQLiteDatasource() {
    Future<void> init() async {
      database = await openDatabase(
        join(await getDatabasesPath(), 'todo_data.db'),
        onCreate: (db, version) {
          return db.execute(
              'CREATE TABLE todos (id INTEGER PRIMARY KEY, name TEXT, description TEXT, complete INTEGER)');
        },
      );
      initialised = true;
    }
  }

  @override
  Future<bool> addTodo(Todo t) async {
    Map<String, dynamic> todo = t.toMap().remove('id');
    List<Map<String, dynamic>> maps = await database.query('todos');
    maps.add(todo);
    return true;
  }

  @override
  Future<List<Todo>> all() async {
    if (!initialised) return <Todo>[];
    List<Map<String, dynamic>> maps = await database.query('todos');
    return List.generate(maps.length, (i) {
      return Todo(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
        complete: maps[i]['complete'] == 0 ? false : true,
      );
    });
  }

  @override
  Future<bool> deleteTodo(Todo t) async {
    Map<String, dynamic> todo = t.toMap().remove('id');
    List<Map<String, dynamic>> maps = await database.query('todos');
    maps.remove(todo);
    return true;
  }

  @override
  Future<Todo> getTodo(Todo t) async {
    Map<String, dynamic> todo = t.toMap().remove('id');
    List<Map<String, dynamic>> maps = await database.query('todos');
    Map<String, dynamic> result =
        maps.firstWhere((element) => element['name'] == todo['name']);
    return Todo(
        id: result['id'],
        name: result['name'],
        description: result['description'],
        complete: result['complete'] == 0 ? false : true);
  }

  @override
  Future<bool> updateTodo(Todo t) async {
    Map<String, dynamic> todo = t.toMap().remove('id');
    List<Map<String, dynamic>> maps = await database.query('todos');
    Map<String, dynamic> result =
        maps.firstWhere((element) => element['name'] == todo['name']);
    result = todo;
    return true;
  }
}

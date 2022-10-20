import 'package:flutter/foundation.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/services/dataresources/hive_dataresource.dart';
import 'package:todo_list/services/dataresources/remote_api_dataresource.dart';
import 'package:todo_list/services/dataresources/sqlite_dataresource.dart';
import 'package:todo_list/services/dataresources/todo_dataresource.dart';
import 'dart:html' as html;
import 'package:connectivity_plus/connectivity_plus.dart';

class DataServiceManager extends TodoDatasource {
  late final TodoDatasource _local;
  //late as this will be set in the constructor.
  final TodoDatasource _remote = RemoteAPIDataresource(); //set this

  DataServiceManager() {
    if (kIsWeb) {
      _local = LocalHiveDatasource();
    } else {
      _local = LocalSQLiteDatasource();
    }
  }

  Future<bool> _checkConnectivity() async {
    if ((kIsWeb && html.window.navigator.onLine == false) ||
        await Connectivity().checkConnectivity() == ConnectivityResult.none) {
      return false;
    }
    return true;
  }

  @override
  Future<bool> addTodo(Todo t) async {
    return await _checkConnectivity()
        ? await _remote.addTodo(t)
        : await _local.addTodo(t);
  }

  @override
  Future<List<Todo>> all() async {
    return await _checkConnectivity()
        ? await _remote.all()
        : await _local.all();
  }

  @override
  Future<bool> deleteTodo(Todo t) async {
    return await _checkConnectivity()
        ? await _remote.deleteTodo(t)
        : await _local.deleteTodo(t);
  }

  @override
  Future<Todo> getTodo(Todo t) async {
    return await _checkConnectivity()
        ? await _remote.getTodo(t)
        : await _local.getTodo(t);
  }

  @override
  Future<bool> updateTodo(Todo t) async {
    return await _checkConnectivity()
        ? await _remote.updateTodo(t)
        : await _local.updateTodo(t);
  }
}

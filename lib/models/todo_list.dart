import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/services/dataresources/todo_dataresource.dart';

class TodoList extends ChangeNotifier {
  List<Todo> _todos = <Todo>[];
  UnmodifiableListView<Todo> get todos => UnmodifiableListView(_todos);
  int get todoCount => _todos.length;

  void add(Todo todo) async {
    _todos.add(todo);
    notifyListeners();
  }

  void removeAll() async {
    _todos.clear();
    notifyListeners();
  }

  void remove(Todo todo) async {
    _todos.remove(todo);
    notifyListeners();
  }

  void updateTodo(Todo todo) async {
    Todo listTodo = _todos.firstWhere((element) => element.name == todo.name);
    listTodo = todo;
    notifyListeners();
  }

  Future<void> refresh() async {
    _todos = await GetIt.I<TodoDatasource>().all();
    notifyListeners();
  }
}

import 'package:todo_list/models/todo.dart';
import 'package:todo_list/services/dataresources/todo_dataresource.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalHiveDatasource implements TodoDatasource {
  bool initialised = false;
  LocalHiveDatasource() {
    if (!initialised) {
      init();
    }
  }

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TodoAdapter());
    initialised = true;
  }

  @override
  Future<bool> addTodo(Todo t) async {
    Box box = await Hive.openBox('todo_box');
    await box.put(t.id, t);
    return true;
  }

  @override
  Future<List<Todo>> all() async {
    Box box = await Hive.openBox('todo_box');
    List todoList = box.values.toList();
    return todoList.cast();
  }

  @override
  Future<bool> deleteTodo(Todo t) async {
    Box box = await Hive.openBox('todo_box');
    await box.delete(t.id);
    return true;
  }

  @override
  Future<Todo> getTodo(Todo t) async {
    Box box = await Hive.openBox('todo_box');
    return await box.get(t.id);
  }

  @override
  Future<bool> updateTodo(Todo t) async {
    Box box = await Hive.openBox('todo_box');
    await box.put(t.id, t);
    return true;
  }
}

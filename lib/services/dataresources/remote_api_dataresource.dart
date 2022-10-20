import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:todo_list/firebase_options.dart';

import 'package:todo_list/models/todo.dart';
import 'package:todo_list/services/dataresources/todo_dataresource.dart';

class RemoteAPIDataresource extends TodoDatasource {
  late FirebaseDatabase database;
  late Future initTask;

  RemoteAPIDataresource() {
    initTask = Future(() async {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
      database = FirebaseDatabase.instance;
    });
  }

  @override
  Future<bool> addTodo(Todo t) async {
    await initTask;

    final DatabaseReference ref = database.ref('todos/${t.id}');

    await ref.set(t.toMap());

    return true;
  }

  @override
  Future<List<Todo>> all() async {
    await initTask;
    List<Todo> todos = <Todo>[];

    final DataSnapshot snapshot = await database.ref('todos').get();
    if (!snapshot.exists) {
      throw Exception(
          "Invalid Request - Cannot find snapshot: " + snapshot.ref.path);
    }

    (snapshot.value as Map<String, dynamic>).forEach((key, value) {
      value['id'] = key;
      todos.add(Todo.fromJSON(value));
    });

    return todos;
  }

  @override
  Future<bool> deleteTodo(Todo t) async {
    await initTask;

    final DatabaseReference ref = database.ref('todos/${t.id}');

    await ref.remove();

    return true;
  }

  @override
  Future<Todo> getTodo(Todo t) async {
    await initTask;

    final DataSnapshot snapshot = await database.ref('todos/${t.id}').get();

    return snapshot.value as Todo;
  }

  @override
  Future<bool> updateTodo(Todo t) async {
    await initTask;

    final DatabaseReference ref = database.ref('todos/${t.id}');

    await ref.set(t.toMap());

    return true;
  }
}

import 'package:todo_list/models/todo.dart';

abstract class TodoDatasource {
  Future<List<Todo>> all();
  Future<bool> addTodo(Todo t);
  Future<bool> deleteTodo(Todo t);
  Future<Todo> getTodo(Todo t);
  Future<bool> updateTodo(Todo t);
}

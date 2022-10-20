import 'dart:html';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/models/todo_list.dart';
import 'package:todo_list/services/dataresources/data_service_manager.dart';
import 'package:todo_list/services/dataresources/hive_dataresource.dart';
import 'package:todo_list/services/dataresources/remote_api_dataresource.dart';
//import 'package:todo_list/services/dataresources/hive_dataresource.dart';
//import 'package:todo_list/services/dataresources/sqlite_dataresource.dart';
import 'package:todo_list/services/dataresources/todo_dataresource.dart';
import 'package:todo_list/views/todo_widget.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //GetIt.I.registerSingleton<TodoDatasource>(RemoteAPIDataresource());
  GetIt.I.registerSingleton<TodoDatasource>(DataServiceManager());
  runApp(ChangeNotifierProvider(
    create: (context) => TodoList(),
    child: const TodoApp(),
  ));
}

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      debugShowCheckedModeBanner: false,
      home: const TodoHomePage(),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({Key? key}) : super(key: key);

  @override
  _TodoHomePageState createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  var uuid = const Uuid();
  final TextEditingController _controlName = TextEditingController();
  final TextEditingController _controlDescription = TextEditingController();
  final TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Todo List', style: TextStyle(fontSize: 30)),
        ),
        actions: [
          Consumer<TodoList>(builder: (context, model, child) {
            model.refresh();
            var count = model.todos
                .where((element) => element.complete == false)
                .toList()
                .length;
            return Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: Text(
                'Total: $count',
                style: const TextStyle(fontSize: 20),
              ),
            );
          })
        ],
      ),
      body: Center(
        child: Consumer<TodoList>(builder: (context, model, child) {
          model.refresh();
          return //RefreshIndicator(
              //onRefresh: model.refresh,
              //child:
              ListView.builder(
            itemCount: model.todoCount,
            itemBuilder: (BuildContext context, int i) {
              return TodoWidget(todo: model.todos[i]);
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTodo,
        tooltip: 'Add new item',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openAddTodo() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(5, 8, 5, 0),
                  child: Text('Name'),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 8),
                  child: TextFormField(
                    controller: _controlName,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(5, 8, 5, 0),
                  child: Text('Description'),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 8),
                  child: TextFormField(
                    controller: _controlDescription,
                  ),
                ),
                ElevatedButton(
                  child: const Text("Submit"),
                  onPressed: () {
                    setState(() {
                      GetIt.I<TodoDatasource>().addTodo(Todo(
                        id: uuid.v1(),
                        name: _controlName.text,
                        description: _controlDescription.text,
                      ));
                    });
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        });
  }

  // final List<Todo> todos = <Todo>[
  //   Todo(name: 'Shopping', description: 'Pick up groceries'),
  //   Todo(name: 'Paint', description: 'Recreate Mona Lisa'),
  //   Todo(name: 'Dance', description: 'I wanna dance with somebody'),
  // ];
}

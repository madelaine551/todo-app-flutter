import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_list/models/todo.dart';

import '../services/dataresources/todo_dataresource.dart';

class TodoWidget extends StatefulWidget {
  final Todo todo;
  const TodoWidget({Key? key, required this.todo}) : super(key: key);

  @override
  _TodoWidgetState createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  final TextEditingController _controlName = TextEditingController();
  final TextEditingController _controlDescription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.deepPurple.shade200,
      margin: const EdgeInsets.all(10),
      elevation: 3,
      child: ListTile(
          title: Text(widget.todo.name),
          subtitle: Text(widget.todo.description),
          onTap: () {
            _openGetTodo();
          },
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Edit button
              IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Update the item',
                  onPressed: _openUpdateTodo),
              // Delete button
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'Delete the item',
                onPressed: () {
                  setState(() {
                    GetIt.I<TodoDatasource>().deleteTodo(widget.todo);
                  });
                },
              ),
            ],
          )),
    );
  }

  void _openGetTodo() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(5, 8, 5, 0),
                  child: Text('Name',
                      style: TextStyle(fontSize: 20, color: Colors.deepPurple)),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 8),
                  child: Text(widget.todo.name),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(5, 8, 5, 0),
                  child: Text('Description',
                      style: TextStyle(fontSize: 20, color: Colors.deepPurple)),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 8),
                  child: Text(widget.todo.description),
                ),
                ElevatedButton(
                  child: const Text("Close"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        });
  }

  void _openUpdateTodo() {
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
                      GetIt.I<TodoDatasource>().updateTodo(Todo(
                        id: widget.todo.id,
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
}

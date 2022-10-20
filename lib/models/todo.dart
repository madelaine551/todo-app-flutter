import 'dart:convert';
import 'dart:html';
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Todo {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final bool complete;

  Todo(
      {required this.id,
      required this.name,
      required this.description,
      this.complete = false});

  factory Todo.fromJSON(Map<String, dynamic> json) {
    return Todo(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        complete: json['complete'] ?? false);
  }

  @override
  String toString() {
    //return name + "(" + description + ")"; old operation on string
    return "$name - ($description) "; //string interpolation
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'complete': complete,
    };
  }
}

class TodoAdapter extends TypeAdapter<Todo> {
  @override
  Todo read(BinaryReader reader) {
    return Todo(
      id: reader.read(0),
      name: reader.read(1),
      description: reader.read(2),
      complete: reader.read(3),
    );
  }

  @override
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, Todo obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.description);
    writer.write(obj.complete);
  }
}

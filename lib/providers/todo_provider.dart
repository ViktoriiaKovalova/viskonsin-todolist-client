import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todoList = [];

  void clear() {
    // TODO: api call and error handling
    _todoList.clear();
  }
}

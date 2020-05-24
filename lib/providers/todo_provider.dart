import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todoList = [
    Todo(
      id: 1,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      label: "Work",
      description: "Test",
    ),
    Todo(
      id: 2,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      label: "Work",
      description: "Test 1",
    ),
    Todo(
      id: 3,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      label: "Work",
      description: "Test 3",
    ),
    Todo(
      id: 4,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      label: "Work",
      description: "Test 4",
    ),
  ];

  DateTime _currentDay = DateTime.now();

  DateTime get currentDay => _currentDay;

  set currentDay(DateTime newCurrentDay) =>
      _currentDay = newCurrentDay == null ? DateTime.now() : newCurrentDay;

  List<Todo> get currentDayTodolist => [..._todoList];

  void next() {
    _currentDay = _currentDay.add(
      Duration(
        days: 1,
      ),
    );
  }

  void prev() {
    _currentDay = _currentDay.subtract(
      Duration(
        days: 1,
      ),
    );
  }

  Future<void> fetchTodolist() async {
    return Future.delayed(const Duration(seconds: 1));
    //TODO: api call and error handling
  }

  Todo getTodoById(int id) =>
      _todoList.firstWhere((element) => element.id == id);

  void deleteTodo(int todoId) {
    //todo: api-delete
    _todoList.removeWhere((element) => element.id == todoId);
    notifyListeners();
  }

  void clear() {
    // TODO: api call and error handling
    _todoList.clear();
    notifyListeners();
  }
}

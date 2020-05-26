import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/todo.dart';

class TodoProvider with ChangeNotifier {
  ApiService _api = ApiService();

  List<Todo> _todoList = [];

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
    _todoList = await _api.fetchTodos(_currentDay);
  }

  Future<void> create(
    String label,
    DateTime timestamp,
    String note,
  ) async {
    Todo todo = Todo(
      id: 1,
      label: label,
      description: note,
      timestamp: timestamp.millisecondsSinceEpoch,
    );

    await _api.createTodo(todo);
    notifyListeners();
  }

  Future<void> edit(
    int id,
    String label,
    DateTime timestamp,
    String note,
  ) async {
    Todo todo = Todo(
      id: id,
      label: label,
      description: note,
      timestamp: timestamp.millisecondsSinceEpoch,
    );

    await _api.editTodo(todo);
    notifyListeners();
  }

  Todo getTodoById(int id) =>
      _todoList.firstWhere((element) => element.id == id, orElse: () => null);

  Future<void> deleteTodo(int todoId) async {
    await _api.delete(todoId);
  }

  void clear() {
    _api.clear();
    _todoList.clear();
    notifyListeners();
  }
}

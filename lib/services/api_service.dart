import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/todo.dart';

class ApiService {
  static final ApiService _singleton = ApiService._internal();

  final String _root = "https://vikka-backend.herokuapp.com";

  factory ApiService() {
    return _singleton;
  }

  ApiService._internal();

  Future<List<Todo>> fetchTodos(DateTime time) async {
    int from = DateTime(
      time.year,
      time.month,
      time.day,
    ).millisecondsSinceEpoch;

    int to = DateTime(
      time.year,
      time.month,
      time.day + 1,
    ).millisecondsSinceEpoch;

    final url = "$_root/list?from=$from&to=$to";

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List<dynamic>;
      return body.map((e) => Todo.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> createTodo(Todo todo) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final body = json.encode(todo.toMap());
    final url = "$_root/create";
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 201) {
      print("Created!");
    }
  }

  Future<void> editTodo(Todo todo) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final body = json.encode(todo.toMap());
    final url = "$_root/edit";
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      print("Edited!");
    }
  }

  Future<void> delete(int id) async {
    final url = '$_root/delete/$id';
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print("Delete $id!");
    }
  }

  Future<void> clear() async {
    final url = '$_root/clear';
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print("Clear!");
    }
  }
}

import 'package:flutter/material.dart';
import '../components/todo_form.dart';

class CreateTodoScreen extends StatelessWidget {
  static const String routeName = '/create';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildNavBar(),
      body: TodoForm(null),
    );
  }

  Widget _buildNavBar() {
    return AppBar(
      title: Text("Create todo"),
    );
  }
}

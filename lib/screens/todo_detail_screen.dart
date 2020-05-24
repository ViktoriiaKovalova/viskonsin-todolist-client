import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../components/todo_form.dart';

class TodoDetailScreen extends StatelessWidget {
  static const String routeName = '/edit';

  @override
  Widget build(BuildContext context) {
    final int todoId = ModalRoute.of(context).settings.arguments as int;
    final provider = Provider.of<TodoProvider>(context);

    return Scaffold(
      appBar: _buildNavBar(() {
        provider.deleteTodo(todoId);
        Navigator.of(context).pop();
      }),
      body: TodoForm(provider.getTodoById(todoId)),
    );
  }

  Widget _buildNavBar(Function handler) {
    return AppBar(
      title: Text("Edit todo"),
      actions: <Widget>[
        IconButton(
          onPressed: handler,
          icon: Icon(Icons.delete),
        ),
      ],
    );
  }
}

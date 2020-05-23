import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Diet App'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Clear todolist'),
            onTap: () {
              Provider.of<TodoProvider>(
                context,
                listen: false,
              ).clear();
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}

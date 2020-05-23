import 'package:flutter/material.dart';
import '../components/app_drawer.dart';

class DayTodolistScreen extends StatelessWidget {
  static const String routeName = '/list';

  @override
  Widget build(BuildContext context) {
    final appBar = _buildNavBar();

    return Scaffold(
      appBar: appBar,
      body: _buildTodoList(),
      drawer: AppDrawer(),
    );
  }

  Widget _buildNavBar() {
    return AppBar(
      title: const Text('TODO app'),
    );
  }

  Widget _buildTodoList() {}
}

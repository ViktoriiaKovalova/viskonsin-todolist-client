import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './theme/style.dart';
import './routes.dart';
import './providers.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders,
      child: MaterialApp(
        title: 'TODO app',
        theme: appTheme(),
        initialRoute: '/list',
        routes: routes,
      ),
    );
  }
}

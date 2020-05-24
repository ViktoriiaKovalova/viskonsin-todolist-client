import 'package:flutter/widgets.dart';
import './screens/day_todolist_screen.dart';
import './screens/todo_detail_screen.dart';
import './screens/create_todo_screen.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  DayTodolistScreen.routeName: (ctx) => DayTodolistScreen(),
  TodoDetailScreen.routeName: (ctx) => TodoDetailScreen(),
  CreateTodoScreen.routeName: (ctx) => CreateTodoScreen(),
};

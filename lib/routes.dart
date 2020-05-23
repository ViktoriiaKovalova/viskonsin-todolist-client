import 'package:flutter/widgets.dart';
import './screens/day_todolist_screen.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  DayTodolistScreen.routeName: (ctx) => DayTodolistScreen(),
};

import 'package:provider/provider.dart';
import './providers/todo_provider.dart';

List<SingleChildCloneableWidget> appProviders = [
  ChangeNotifierProvider.value(
    value: TodoProvider(),
  ),
];

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/todo_provider.dart';
import '../components/app_drawer.dart';
import '../components/todo_form.dart';

class DayTodolistScreen extends StatefulWidget {
  static const String routeName = '/list';

  @override
  _DayTodolistScreenState createState() => _DayTodolistScreenState();
}

class _DayTodolistScreenState extends State<DayTodolistScreen> {
  bool _isInit = true;
  bool _isLoading = false;

  void _fetchData() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<TodoProvider>(
      context,
    ).fetchTodolist().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2100),
    ).then((pickedData) {
      if (pickedData == null) {
        return;
      }
      Provider.of<TodoProvider>(context).currentDay = pickedData;
      _fetchData();
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _fetchData();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = _buildNavBar();

    return Scaffold(
      appBar: appBar,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _buildTodoList(),
      drawer: AppDrawer(),
    );
  }

  Widget _buildNavBar() {
    return AppBar(
      title: _buildCurrentDayRow(),
      actions: <Widget>[
        IconButton(
          onPressed: _presentDatePicker,
          icon: Icon(Icons.calendar_today),
        ),
        IconButton(
          onPressed: () => Navigator.pushNamed(context, '/create')
              .whenComplete(() => _fetchData()),
          icon: Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _buildTodoList() {
    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final provider = Provider.of<TodoProvider>(context);
    final todolist = provider.currentDayTodolist;

    return ListView.builder(
      itemCount: todolist.length,
      itemBuilder: (BuildContext ctxt, int index) {
        final currTask = todolist[index];
        final taskTime = localizations.formatTimeOfDay(
            TimeOfDay.fromDateTime(
              DateTime.fromMillisecondsSinceEpoch(
                currTask.timestamp,
              ),
            ),
            alwaysUse24HourFormat: false);

        return ListTile(
          leading: Icon(Icons.event_available),
          title: Text(currTask.description),
          subtitle: Text("Time: $taskTime | Tag: ${currTask.label}"),
          trailing: IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
            ),
            onPressed: () => Navigator.pushNamed(
              context,
              '/edit',
              arguments: currTask.id,
            ).whenComplete(() => _fetchData()),
          ),
        );
      },
    );
  }

  Widget _buildCurrentDayRow() {
    final provider = Provider.of<TodoProvider>(context);
    final currDayStr =
        DateFormat.yMMMMd("en_US").format(provider.currentDay).toString();

    return Row(
      children: <Widget>[
        IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              provider.prev();
              _fetchData();
            }),
        Text(currDayStr),
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () {
            provider.next();
            _fetchData();
          },
        ),
      ],
    );
  }
}

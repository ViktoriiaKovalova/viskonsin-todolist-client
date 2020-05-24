import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';

class TodoForm extends StatefulWidget {
  final Todo todo;

  TodoForm(this.todo);

  @override
  _TodoFormState createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  final _formKey = GlobalKey<FormState>();

  /* form data */
  String _label;
  String _note;
  int _projectId = -1;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    if (widget.todo != null) {
      _selectedDate = DateTime.fromMillisecondsSinceEpoch(
        widget.todo.timestamp,
      );

      _selectedTime = TimeOfDay.fromDateTime(
        DateTime.fromMillisecondsSinceEpoch(
          widget.todo.timestamp,
        ),
      );
    }

    super.initState();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: widget.todo == null
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(
              widget.todo.timestamp,
            ),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    ).then((pickedData) {
      if (pickedData == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedData;
      });
    });
  }

  Future<Null> _selectTime(BuildContext context) async {
    TimeOfDay selectedTime = await showTimePicker(
      context: context,
      initialTime: widget.todo == null
          ? TimeOfDay.now()
          : TimeOfDay.fromDateTime(
              DateTime.fromMillisecondsSinceEpoch(
                widget.todo.timestamp,
              ),
            ),
    );

    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    if (selectedTime != null) {
      String formattedTime = localizations.formatTimeOfDay(selectedTime,
          alwaysUse24HourFormat: false);
      if (formattedTime != null) {
        setState(() {
          _selectedTime = selectedTime;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 50.0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildButtonAndTimeRow(),
              _buildButtonAndInputTextRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonAndTimeRow() {
    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    String formattedTime = localizations.formatTimeOfDay(_selectedTime,
        alwaysUse24HourFormat: false);

    final tagInput = _buildInput(
      (value) {
        _label = value;
      },
      (val) {},
      "Tag",
    );

    final dateInput = GestureDetector(
      onTap: _presentDatePicker,
      child: Text(
        '${DateFormat.yMMMMd("en_US").format(_selectedDate)}',
        style: TextStyle(
          color: Colors.lightBlue,
          fontSize: 18,
        ),
        textAlign: TextAlign.center,
      ),
    );

    final timeInput = GestureDetector(
      onTap: () async {
        await _selectTime(context);
      },
      child: Text(
        formattedTime,
        style: TextStyle(
          color: Colors.lightBlue,
          fontSize: 18,
        ),
        textAlign: TextAlign.center,
      ),
    );

    /* result */
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        tagInput,
        dateInput,
        timeInput,
      ],
    );
  }

  Widget _buildButtonAndInputTextRow() {
    final submitButton = RaisedButton(
      onPressed: () {},
      child: Text(
        widget.todo == null ? "Create" : "Edit",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      color: Colors.blue,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        _buildMiltiLineInput(
          (value) {
            _note = value;
          },
          (val) {},
          "Add new todo",
        ),
        submitButton,
      ],
    );
  }

  Widget _buildInput(
    Function onSaveHandler,
    Function validator,
    String hint,
  ) {
    return Container(
      height: 20,
      width: 120,
      child: TextFormField(
        initialValue: widget.todo == null ? "" : widget.todo.label,
        onSaved: onSaveHandler,
        minLines: 1,
        maxLines: 1,
        validator: (value) {
          return null;
        },
        keyboardType: TextInputType.text,
        style: TextStyle(
          fontSize: 18,
        ),
        textAlign: TextAlign.left,
        decoration: InputDecoration(
          hintText: hint,
        ),
      ),
    );
  }

  Widget _buildMiltiLineInput(
      Function onSaveHandler, Function validator, String hint) {
    return Container(
      height: 100,
      width: double.infinity,
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        initialValue: widget.todo == null ? "" : widget.todo.description,
        minLines: 1,
        maxLines: 3,
        onSaved: onSaveHandler,
        validator: (value) {
          return null;
        },
        style: TextStyle(
          fontSize: 18,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            widget.todo == null ? Icons.add : Icons.edit,
          ),
          hintText: hint,
        ),
      ),
    );
  }
}

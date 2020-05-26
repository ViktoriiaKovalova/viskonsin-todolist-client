import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/todo_provider.dart';
import '../models/todo.dart';

class TodoForm extends StatefulWidget {
  final Todo todo;

  TodoForm(this.todo);

  @override
  _TodoFormState createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  /* form data */
  String _label;
  String _note;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _sendData() async {
    _formKey.currentState.save();
    
    DateTime timestamp = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final provider = Provider.of<TodoProvider>(
      context,
      listen: false,
    );

    setState(() {
      _isLoading = true;
    });

    if (widget.todo == null) {
      await provider.create(_label, timestamp, _note);
    } else {
      await provider.edit(widget.todo.id, _label, timestamp, _note);
    }

    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pop();
  }

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
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
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
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Center(
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
      onPressed: () async {
        await _sendData();
      },
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

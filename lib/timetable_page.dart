import 'package:flutter/material.dart';

class TimetablePage extends StatefulWidget {
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  Map<String, Map<String, String>> timetable = {
    'Monday': {},
    'Tuesday': {},
    'Wednesday': {},
    'Thursday': {},
    'Friday': {},
    'Saturday': {},
    'Sunday': {},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weekly Timetable'),
      ),
      body: ListView(
        children: timetable.keys.map((day) {
          return ExpansionTile(
            title: Text(day),
            children: [
              ...timetable[day]!.entries.map((entry) {
                return ListTile(
                  title: Text("${entry.key}: ${entry.value}"),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      print('Edit button tapped for $day at ${entry.key}');
                      _editScheduleDialog(day, entry.key, entry.value);
                    },
                  ),
                );
              }).toList(),
              ListTile(
                title: TextButton(
                  onPressed: () {
                    print('Add Schedule button tapped for $day');
                    _addScheduleDialog(day);
                  },
                  child: Text("Add Schedule"),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _addScheduleDialog(String day) {
    TextEditingController _timeController = TextEditingController();
    TextEditingController _taskController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Schedule for $day"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _timeController,
                decoration: InputDecoration(hintText: "Enter time (e.g., 09:00 AM)"),
              ),
              TextField(
                controller: _taskController,
                decoration: InputDecoration(hintText: "Enter task description"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  print('Saving new schedule for $day at ${_timeController.text}');
                  timetable[day]![_timeController.text] = _taskController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _editScheduleDialog(String day, String time, String task) {
    TextEditingController _timeController = TextEditingController(text: time);
    TextEditingController _taskController = TextEditingController(text: task);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Schedule for $day"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _timeController,
                decoration: InputDecoration(hintText: "Edit time (e.g., 09:00 AM)"),
              ),
              TextField(
                controller: _taskController,
                decoration: InputDecoration(hintText: "Edit task description"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  print('Editing schedule for $day at $time');
                  timetable[day]!.remove(time);
                  timetable[day]![_timeController.text] = _taskController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }
}

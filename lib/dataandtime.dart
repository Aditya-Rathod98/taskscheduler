import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DateandTimePicker extends StatefulWidget {
  final Map<DateTime, String> notes;
  final Function(DateTime, String) onNoteSaved;

  const DateandTimePicker({
    super.key,
    required this.notes,
    required this.onNoteSaved,
  });

  @override
  State<DateandTimePicker> createState() => _DateandTimePickerState();
}

class _DateandTimePickerState extends State<DateandTimePicker> {
  DateTime today = DateTime.now();

  void _onDateSelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
    _showNoteDialog(day);
  }

  void _showNoteDialog(DateTime day) {
    TextEditingController _noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Note for ${day.toLocal().toIso8601String().substring(0, 10)}"),
          content: TextField(
            controller: _noteController,
            decoration: InputDecoration(hintText: "Enter your note here"),
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
                widget.onNoteSaved(day, _noteController.text);
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: TableCalendar(
          locale: 'en_us',
          rowHeight: 70,
          headerStyle: HeaderStyle(titleCentered: true, formatButtonVisible: false),
          focusedDay: today,
          availableGestures: AvailableGestures.all,
          onDaySelected: _onDateSelected,
          selectedDayPredicate: (day) => isSameDay(day, today),
          firstDay: DateTime.utc(2000, 01, 01),
          lastDay: DateTime.utc(2030, 01, 01),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (widget.notes[date] != null) {
                return Positioned(
                  bottom: 1,
                  child: Icon(Icons.note, size: 16.0, color: Colors.blueAccent),
                );
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:taskscheduler/dataandtime.dart';
import 'package:taskscheduler/notes_page.dart';
import 'package:taskscheduler/timetable_page.dart'; // Import the new Timetable page

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<DateTime, String> notes = {};

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Task Scheduler'),
          backgroundColor: Colors.blueGrey,
        ),
        body: DateandTimePicker(
          notes: notes,
          onNoteSaved: (date, note) {
            setState(() {
              notes[date] = note;
            });
          },
        ),
        drawer: Drawer(
          child: Builder(
              builder: (BuildContext context) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          DrawerHeader(
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                            ),
                            child: Text(
                              'Others',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.calendar_today),
                            title: Text('Calendar'),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.note),
                            title: Text('Notes'),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotesPage(
                                    notes: notes,
                                    onNoteEdited: (date, newNote) {
                                      setState(() {
                                        notes[date] = newNote;
                                      });
                                    },
                                    onNoteDeleted: (date) {
                                      setState(() {
                                        notes.remove(date);
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.schedule),
                            title: Text('Timetable'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => TimetablePage()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Divider(), // Adds a dividing line
                    Container(
                      color: Colors.grey[500],
                      width: double.infinity,// Change this to your desired background color
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Aligns the children to the start of the container
                        children: [
                          Text(
                            'Developed by LearnMind',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8.0),
                          Text('Email: be.learnmind@gmail.com'),
                          Text('Contact: +91 7276884953'),
                          SizedBox(height: 8.0),
                        ],
                      ),
                    ),
                  ],
                );
              }
          ),
        ),
      ),
    );
  }
}
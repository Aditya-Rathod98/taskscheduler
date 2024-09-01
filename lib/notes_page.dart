import 'package:flutter/material.dart';

class NotesPage extends StatelessWidget {
  final Map<DateTime, String> notes;
  final Function(DateTime) onNoteDeleted;
  final Function(DateTime, String) onNoteEdited;

  NotesPage({
    required this.notes,
    required this.onNoteDeleted,
    required this.onNoteEdited,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Notes'),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          DateTime date = notes.keys.elementAt(index);
          String note = notes[date]!;

          return Dismissible(
            key: Key(date.toIso8601String()),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            confirmDismiss: (DismissDirection direction) async {
              return await _confirmDelete(context, date);
            },
            onDismissed: (direction) {
              onNoteDeleted(date);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Deleted note for ${date.toLocal().toIso8601String().substring(0, 10)}")),
              );
            },
            child: ListTile(
              title: Text("${date.toLocal().toIso8601String().substring(0, 10)}: $note"),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _editNoteDialog(context, date, note);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _editNoteDialog(BuildContext context, DateTime date, String note) {
    TextEditingController _noteController = TextEditingController(text: note);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Note for ${date.toLocal().toIso8601String().substring(0, 10)}"),
          content: TextField(
            controller: _noteController,
            decoration: InputDecoration(hintText: "Edit your note here"),
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
                onNoteEdited(date, _noteController.text);
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _confirmDelete(BuildContext context, DateTime date) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Note"),
          content: Text("Are you sure you want to delete the note for ${date.toLocal().toIso8601String().substring(0, 10)}?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}

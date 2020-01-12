import 'package:flutter/material.dart';
import 'package:flutter_notes/code/code.dart';
import 'package:hive/hive.dart';
import 'package:flutter_notes/data/hiveDB.dart';
import 'package:flutter_notes/code/config.dart';

class EditNote extends StatelessWidget {
  final int noteKey;
  EditNote({Key key, @required this.noteKey}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Note note = Hive.box<Note>(notesBox)
        .values
        .singleWhere((value) => value.key == noteKey);
    _titleController.text = note.title;
    _descriptionController.text = note.description;
    return Scaffold(
      appBar: AppBar(
        title: Text("Editing note"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Note info",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
                  ),
                  getDivider(),
                  title(),
                  getDivider(),
                  description(),
                  getDivider(),
                  Row(
                    children: <Widget>[
                      Text(
                        "Updated: ",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        Code().getDateFormated(note.dateUpdated),
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  getDivider(),
                  Row(
                    children: <Widget>[
                      Text(
                        "Created: ",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        Code().getDateFormated(note.dateCreated),
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  getDivider(),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: OutlineButton(
                            textColor: Colors.red,
                            child: Text("Delete"),
                            onPressed: () {
                              deleteNote(context);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: OutlineButton(
                            textColor: Colors.blue,
                            child: Text("Save"),
                            onPressed: () {
                              updateNoteInfo(note, context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  updateNoteInfo(Note note, context) async {
    if (_formKey.currentState.validate()) {
      note.title = _titleController.text;
      note.description = _descriptionController.text;
      note.dateUpdated = DateTime.now();
      Box<Note> notes = Hive.box<Note>(notesBox);
      await notes.put(noteKey, note);
      Navigator.of(context).pop();
    }
  }

  deleteNote(context) async {
    bool continueDelete = await alertConfirmDialog(context);
    if (continueDelete) {
      Box<Note> notes = Hive.box<Note>(notesBox);
      await notes.delete(noteKey);
      Navigator.of(context).pop();
    }
  }

  Future<bool> alertConfirmDialog(context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Note"),
          content: Text("Are you sure you want to delete this Note?"),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }

  getDivider() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
    );
  }

  final TextEditingController _titleController = TextEditingController();
  title() {
    return TextFormField(
      controller: _titleController,
      validator: (value) {
        if (value.isEmpty) {
          return "Please fill the Note title";
        }
        return null;
      },
      style: TextStyle(fontSize: 18),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0),
          hintText: "Note title",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
    );
  }

  final TextEditingController _descriptionController = TextEditingController();
  description() {
    return TextFormField(
      controller: _descriptionController,
      style: TextStyle(fontSize: 18),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0),
          hintText: "Note description (optional)",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
    );
  }
}

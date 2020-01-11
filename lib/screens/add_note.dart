import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_notes/data/hiveDB.dart';
import 'package:flutter_notes/code/config.dart';

class AddNote extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Note"),
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
                    "Fill Note info",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
                  ),
                  getDivider(),
                  title(),
                  getDivider(),
                  description(),
                  getDivider(),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: OutlineButton(
                            child: Text("Text Note"),
                            onPressed: () {
                              createTextNote(context);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: OutlineButton(
                            child: Text("Check List Note"),
                            onPressed: () {
                              createCheckListNote(context);
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

  createTextNote(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      Box<Note> notes = Hive.box<Note>(notesBox);
      reorderNotes(notes);
      int pk = await notes.add(Note(DateTime.now(), _titleController.text,
          _descriptionController.text, DateTime.now(), NoteType.Text, 0));
      Box<TextNote> tNotes = Hive.box<TextNote>(textNotesBox);
      await tNotes.add(TextNote("", pk));
      Navigator.of(context).pop();
    }
  }

  createCheckListNote(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      Box<Note> notes = Hive.box<Note>(notesBox);
      reorderNotes(notes);
      int pk = await notes.add(Note(DateTime.now(), _titleController.text,
          _descriptionController.text, DateTime.now(), NoteType.CheckList, 0));
      Box<CheckListNote> clNotes = Hive.box<CheckListNote>(checkListNotesBox);
      await clNotes.add(CheckListNote("", false, 0, pk));
      Navigator.of(context).pop();
    }
  }

  reorderNotes(Box<Note> notes) {
    for (Note noteOrder in notes.values) {
      noteOrder.position = noteOrder.position + 1;
      notes.put(noteOrder.key, noteOrder);
    }
  }
}

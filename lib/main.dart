import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/hiveDB.dart'; //this is where I created my Hive Classes
import 'code/config.dart';
import 'screens/add_note.dart';
import 'screens/edit_check_note.dart';
import 'screens/edit_note.dart';
import 'screens/edit_text_note.dart'; //this is where I save some common configurations

void main() async {
  if (!kIsWeb) {
    //waits to initialize path on flutter with the default path
    await Hive.initFlutter();
  }
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(NoteTypeAdapter());
  Hive.registerAdapter(CheckListNoteAdapter());
  Hive.registerAdapter(TextNoteAdapter());
  //if it's the first time running, it will also create the "Box", else it will just open
  await Hive.openBox<Note>(notesBox);
  await Hive.openBox<TextNote>(
      textNotesBox); //this box will be used later for the Text Type entries
  await Hive.openBox<CheckListNote>(
      checkListNotesBox); //this box will be used later for the Check List Type entries
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      title: appName,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appName),
        ),
        body: SafeArea(
          child: getNotes(),
        ),
        floatingActionButton: addNoteButton(),
      ),
    );
  }

  getNotes() {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Note>(notesBox).listenable(),
      builder: (context, Box<Note> box, _) {
        if (box.values.isEmpty) {
          return Center(
            child: Text("No Notes!"),
          );
        }
        List<Note> notes = getNotesList(); //get notes from box function
        return ReorderableListView(
            onReorder: (oldIndex, newIdenx) async {
              await reorderNotes(oldIndex, newIdenx, notes);
            },
            children: <Widget>[
              for (Note note in notes) ...[
                getNoteInfo(note, context),
              ],
            ]);
      },
    );
  }

  reorderNotes(oldIndex, newIdenx, notes) async {
    Box<Note> hiveBox = Hive.box<Note>(notesBox);
    if (oldIndex < newIdenx) {
      notes[oldIndex].position = newIdenx - 1;
      await hiveBox.put(notes[oldIndex].key, notes[oldIndex]);
      for (int i = oldIndex + 1; i < newIdenx; i++) {
        notes[i].position = notes[i].position - 1;
        await hiveBox.put(notes[i].key, notes[i]);
      }
    } else {
      notes[oldIndex].position = newIdenx;
      await hiveBox.put(notes[oldIndex].key, notes[oldIndex]);
      for (int i = newIdenx; i < oldIndex; i++) {
        notes[i].position = notes[i].position + 1;
        await hiveBox.put(notes[i].key, notes[i]);
      }
    }
  }

  getNotesList() {
    //get notes as a List
    List<Note> notes = Hive.box<Note>(notesBox).values.toList();
    notes = getNotesSortedByOrder(notes);
    return notes;
  }

  getNotesSortedByOrder(List<Note> notes) {
    //ordering note list by position
    notes.sort((a, b) {
      var adate = a.position;
      var bdate = b.position;
      return adate.compareTo(bdate);
    });
    return notes;
  }

  getNoteInfo(Note note, BuildContext context) {
    return ListTile(
      dense: true,
      key: Key(note.key.toString()),
      onTap: () {
        if (note.noteType == NoteType.Text) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditTextNote(
                noteParent: note.key,
                noteTitle: note.title,
              ),
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditCheckNote(
                noteParent: note.key,
                noteTitle: note.title,
              ),
            ),
          );
        }
      },
      title: Container(
        padding: EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.black,
        ),
        child: Text(
          note.title,
          style: TextStyle(fontSize: 18),
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.info, size: 22, color: Colors.blueAccent),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditNote(
                noteKey: note.key,
              ),
            ),
          );
        },
      ),
    );
  }

  addNoteButton() {
    return Builder(
      builder: (context) {
        return FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddNote()));
          },
        );
      },
    );
  }
}

import 'package:flutter_notes/data/hiveDB.dart';
import 'package:hive/hive.dart';
import 'config.dart';
import 'package:intl/intl.dart' as intl;

class Code {
  changeUpdatedDate(int noteKey) async {
    Box<Note> notes = Hive.box<Note>(notesBox);
    Note note = Hive.box<Note>(notesBox)
        .values
        .singleWhere((value) => value.key == noteKey);
    note.dateUpdated = DateTime.now();
    await notes.put(noteKey, note);
  }
  String getDateFormated(DateTime date) {
    return intl.DateFormat('dd-MM-yyyy HH:mm:ss').format(date);
  }
}

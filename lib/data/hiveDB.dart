import 'package:hive/hive.dart';

part 'hiveDB.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  DateTime dateCreated;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime dateUpdated;

  @HiveField(4)
  NoteType noteType;

  @HiveField(5)
  int position;

  Note(this.dateCreated, this.title, this.description, this.dateUpdated,
      this.noteType, this.position);
}

@HiveType(typeId: 1)
enum NoteType {
  @HiveField(0)
  Text,
  @HiveField(1)
  CheckList,
}
const noteType = <NoteType, int>{
  NoteType.Text: 1,
  NoteType.CheckList: 2,
};

@HiveType(typeId: 2)
class CheckListNote extends HiveObject {
  @HiveField(0)
  String text;

  @HiveField(1)
  bool done;

  @HiveField(2)
  int position;

  @HiveField(3)
  int noteParent;

  CheckListNote(this.text, this.done, this.position, this.noteParent);
}

@HiveType(typeId: 3)
class TextNote extends HiveObject {
  @HiveField(0)
  String text;

  @HiveField(1)
  int noteParent;

  TextNote(this.text, this.noteParent);
}
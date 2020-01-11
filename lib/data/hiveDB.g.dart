// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hiveDB.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteTypeAdapter extends TypeAdapter<NoteType> {
  @override
  final typeId = 1;

  @override
  NoteType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return NoteType.Text;
      case 1:
        return NoteType.CheckList;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, NoteType obj) {
    switch (obj) {
      case NoteType.Text:
        writer.writeByte(0);
        break;
      case NoteType.CheckList:
        writer.writeByte(1);
        break;
    }
  }
}

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final typeId = 0;

  @override
  Note read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Note(
      fields[0] as DateTime,
      fields[1] as String,
      fields[2] as String,
      fields[3] as DateTime,
      fields[4] as NoteType,
      fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.dateCreated)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.dateUpdated)
      ..writeByte(4)
      ..write(obj.noteType)
      ..writeByte(5)
      ..write(obj.position);
  }
}

class CheckListNoteAdapter extends TypeAdapter<CheckListNote> {
  @override
  final typeId = 2;

  @override
  CheckListNote read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CheckListNote(
      fields[0] as String,
      fields[1] as bool,
      fields[2] as int,
      fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CheckListNote obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.done)
      ..writeByte(2)
      ..write(obj.position)
      ..writeByte(3)
      ..write(obj.noteParent);
  }
}

class TextNoteAdapter extends TypeAdapter<TextNote> {
  @override
  final typeId = 3;

  @override
  TextNote read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TextNote(
      fields[0] as String,
      fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TextNote obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.noteParent);
  }
}

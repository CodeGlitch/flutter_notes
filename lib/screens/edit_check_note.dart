import 'package:flutter/material.dart';
import 'package:flutter_notes/code/code.dart';
import 'package:hive/hive.dart';
import 'package:flutter_notes/data/hiveDB.dart';
import 'package:flutter_notes/code/config.dart';

class EditCheckNote extends StatefulWidget {
  final int noteParent;
  final String noteTitle;
  EditCheckNote({Key key, @required this.noteParent, @required this.noteTitle})
      : super(key: key);

  @override
  _EditCheckNoteState createState() => _EditCheckNoteState();
}

class _EditCheckNoteState extends State<EditCheckNote> {
  List<CheckListNote> checkListNote;
  loadNoteItems() {
    checkListNote = Hive.box<CheckListNote>(checkListNotesBox)
        .values
        .where((value) => value.noteParent == widget.noteParent)
        .map((item) => item)
        .toList();
    checkListNote.sort((a, b) {
      var adate = a.position;
      var bdate = b.position;
      return adate.compareTo(bdate);
    });
  }

  @override
  Widget build(BuildContext context) {
    loadNoteItems();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noteTitle),
      ),
      body: SafeArea(
        child: ReorderableListView(
          onReorder: (oldIndex, newIdenx) {
            reorderNotesNewPosition(oldIndex, newIdenx);
          },
          children: <Widget>[
            if (checkListNote.length == 0) ...[
              Center(
                key: Key("empty"),
                child: Text("No items!"),
              )
            ] else ...[
              for (CheckListNote item in checkListNote) ...[
                ListTile(
                  key: Key(item.key
                      .toString()), //using the Box key to assign it to the ListTile key for reordering later
                  leading: Checkbox(
                    value: item.done,
                    onChanged: (bool value) async {
                      item.done = value;
                      getUpdateItemInfo(item);
                      Box<CheckListNote> clNotes =
                          Hive.box<CheckListNote>(checkListNotesBox);
                      await clNotes.put(item.key, item);
                      Code().changeUpdatedDate(widget.noteParent);
                      setState(() {});
                    },
                  ),
                  title: CheckListItemText(
                    itemID: item.key,
                    noteParent: widget.noteParent,
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, size: 22, color: Colors.redAccent),
                    onPressed: () async {
                      Box<CheckListNote> clNotes =
                          Hive.box<CheckListNote>(checkListNotesBox);
                      await clNotes.delete(item.key);
                      Code().changeUpdatedDate(widget.noteParent);
                      loadNoteItems();
                      setState(() {});
                    },
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Box<CheckListNote> clNotes =
              Hive.box<CheckListNote>(checkListNotesBox);
          reorderNoteItems(clNotes);
          await clNotes.add(CheckListNote("", false, 0, widget.noteParent));

          Code().changeUpdatedDate(widget.noteParent);
          loadNoteItems();
          setState(() {});
        },
      ),
    );
  }

  reorderNotesNewPosition(oldIndex, newIdenx) async {
    Box<CheckListNote> clNotes = Hive.box<CheckListNote>(checkListNotesBox);
    if (oldIndex < newIdenx) {
      checkListNote[oldIndex].position = newIdenx - 1;
      clNotes.put(checkListNote[oldIndex].key, checkListNote[oldIndex]);
      for (int i = oldIndex + 1; i < newIdenx; i++) {
        checkListNote[i].position = checkListNote[i].position - 1;
        clNotes.put(checkListNote[i].key, checkListNote[i]);
      }
    } else {
      checkListNote[oldIndex].position = newIdenx;
      clNotes.put(checkListNote[oldIndex].key, checkListNote[oldIndex]);
      for (int i = newIdenx; i < oldIndex; i++) {
        checkListNote[i].position = checkListNote[i].position + 1;
        clNotes.put(checkListNote[i].key, checkListNote[i]);
      }
    }
    Code().changeUpdatedDate(widget.noteParent);
    setState(() {});
  }

  reorderNoteItems(Box<CheckListNote> clNotes) {
    for (CheckListNote item in checkListNote) {
      item.position = item.position + 1;
      clNotes.put(item.key, item);
    }
  }

  getUpdateItemInfo(CheckListNote item) {
    item = Hive.box<CheckListNote>(checkListNotesBox)
        .values
        .singleWhere((value) => value.key == item.key);
  }
}

class CheckListItemText extends StatelessWidget {
  final int noteParent;
  final int itemID;
  CheckListItemText({Key key, @required this.itemID, @required this.noteParent})
      : super(key: key);

  final TextEditingController _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    CheckListNote checkListItem = Hive.box<CheckListNote>(checkListNotesBox)
        .values
        .singleWhere((value) => value.key == itemID);
    _textController.text = checkListItem.text;
    return TextFormField(
      keyboardType: TextInputType.multiline,
      expands: false,
      minLines: 1,
      maxLines: 999,
      onChanged: (value) async {
        checkListItem.text = value;
        Box<CheckListNote> clNotes = Hive.box<CheckListNote>(checkListNotesBox);
        await clNotes.put(checkListItem.key, checkListItem);
        Code().changeUpdatedDate(noteParent);
      },
      controller: _textController,
      style: TextStyle(fontSize: 18),
    );
  }
}

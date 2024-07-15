import 'package:flutter/foundation.dart';
import 'package:simple_notes/db.dart';

class NoteBook extends ValueNotifier<List<(int, String, String)>> {
  NoteBook._sharedInstance() : super([]);
  static final NoteBook _shared = NoteBook._sharedInstance();
  factory NoteBook() => _shared;

  int get length => value.length;

  void add({required (String, String) note}) async {
    await DbHelper.addData(note.$1, note.$2);
    await fetchContacts();
  }

  void remove(
      {required int index, required (int, String, String) record}) async {
    await DbHelper.delete(index);
    value.remove(record);
    notifyListeners();
  }

  (int, String, String)? contact({required int index}) =>
      value.length > index ? value[index] : null;

  Future<void> fetchContacts() async {
    List<(int, String, String)> fetchedContacts = await DbHelper.fetchAll();
    value = fetchedContacts;
  }
}

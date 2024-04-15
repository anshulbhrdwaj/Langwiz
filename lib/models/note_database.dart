import 'dart:io';
import "package:flutter/material.dart";
import "package:isar/isar.dart";
import "package:langwiz/models/note.dart";
import "package:path_provider/path_provider.dart";

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;

  // --------> Initialise DB (Database)
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([NoteSchema], directory: dir.path);
    // await isar.close(deleteFromDisk: true);
  }

  // --------> clear DB (Database)
  Future<void> clearIsarDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath =
        '${dir.path}/isar'; // Adjust the path if your database is stored in a different location
    final dbFile = File(dbPath);

    if (await dbFile.exists()) {
      await dbFile.delete();
      print('Isar database cleared.');
    } else {
      print('Isar database file not found.');
    }
  }

  // this current notes list will contain all notes
  final List<Note> currentNotes = [];

  // --------> Create Note
  Future<void> addNote(String wordFromUser, String meaningFromUser, String sentenceFromUser) async {
    // create a new note object and add it to the currentNotes list
    final newNote = Note()
      ..word = wordFromUser
      ..meaning = meaningFromUser
      ..sentence = sentenceFromUser;

    currentNotes.add(newNote);

    // add the note to the database
    await isar.writeTxn(() => isar.notes.put(newNote));

    // re-read from db
    fetchNotes();
  }

  // --------> Read Note
  Future<void> fetchNotes() async {
    try {
      // read from db
      List<Note> fetchedNotes = await isar.notes.where().findAll();
      currentNotes.clear();
      currentNotes.addAll(fetchedNotes);
      notifyListeners();
    } catch (e) {
      // Log the error or handle it as needed
      print('Error fetching notes: $e');
    }
  }

  // --------> Update Note with finding it using its id and updating sentence with new sentence from user if it exists
  Future<void> updateNote(int id, String wordFromUser, String meaningFromUser, String sentenceFromUser) async {
    // find the note with the id
    final noteToUpdate = await isar.notes.get(id);

    // if the note exists, update its sentence
    if (noteToUpdate != null) {
      noteToUpdate.word = wordFromUser;
      noteToUpdate.meaning = meaningFromUser;
      noteToUpdate.sentence = sentenceFromUser;
      await isar.writeTxn(() => isar.notes.put(noteToUpdate));
      // re-read from db
      await fetchNotes();
    }
  }

  // --------> Delete Note with its id
  Future<void> deleteNote(int id) async {
    // find the note with the id
    final noteToDelete = await isar.notes.get(id);

    // if the note exists, delete it
    if (noteToDelete != null) {
      await isar.writeTxn(() => isar.notes.delete(noteToDelete.id));
      // re-read from db
      await fetchNotes();
    } else {
      print('Note not found');
    }
  }
}

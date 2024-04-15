import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:langwiz/components/drawer.dart';
import 'package:langwiz/models/note_database.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final wordController = TextEditingController();
  final meaningController = TextEditingController();
  final sentenceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // on app start get existing notes
    readNotes();
  }

  // function to create a note using a dialog asking for word and sentence to remember it with
  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remember a new word'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: wordController,
              decoration: const InputDecoration(
                labelText: 'Word',
              ),
            ),
            TextField(
              controller: meaningController,
              decoration: const InputDecoration(
                labelText: 'Meaning',
              ),
            ),
            TextField(
              controller: sentenceController,
              decoration: const InputDecoration(
                labelText: 'Sentence',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary)),
          ),
          TextButton(
            onPressed: () {
              // add note to db
              context.read<NoteDatabase>().addNote(
                    wordController.text,
                    meaningController.text,
                    sentenceController.text,
                  );

              // Pop Dialogue Box
              Navigator.pop(context);

              // Clear TextFields
              wordController.clear();
              meaningController.clear();
              sentenceController.clear();
            },
            child: Text('Create',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary)),
          ),
        ],
      ),
    );
  }

  // function to read notes
  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  // function to update a note
  void updateNote(Note note) {
    wordController.text = note.word;
    meaningController.text = note.meaning;
    sentenceController.text = note.sentence;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: wordController,
              decoration: const InputDecoration(
                labelText: 'Word',
              ),
            ),
            TextField(
              controller: meaningController,
              decoration: const InputDecoration(
                labelText: 'Meaning',
              ),
            ),
            TextField(
              controller: sentenceController,
              decoration: const InputDecoration(
                labelText: 'Sentence',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary))),
          TextButton(
            onPressed: () {
              // update note
              context.read<NoteDatabase>().updateNote(
                    note.id,
                    wordController.text,
                    meaningController.text,
                    sentenceController.text,
                  );

              // Pop Dialogue Box
              Navigator.pop(context);

              // Clear TextFields
              wordController.clear();
              meaningController.clear();
              sentenceController.clear();
            },
            child: Text('Update',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary)),
          ),
        ],
      ),
    );
  }

  // function to delete a note
  void deleteNote(Note note) {
    context.read<NoteDatabase>().deleteNote(note.id);
  }

  @override
  Widget build(BuildContext context) {
    // get note database
    final noteDatabase = context.watch<NoteDatabase>();

    // create current notes list
    List<Note> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      drawer: const MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 10.0),
            child: Text(
              "Langwiz",
              style: GoogleFonts.dmSerifText(
                  fontSize: 48,
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
          ),

          // List of Notes
          Expanded(
            child: ListView.builder(
                itemCount: currentNotes.length,
                itemBuilder: (context, index) {
                  if (index >= 0 && index < currentNotes.length) {
                    return Container(
                      margin: const EdgeInsets.only(left:12, right: 12),
                      child: Card(
                        child: ListTile(
                            title: Text(currentNotes[index].word),
                            subtitle: Text(currentNotes[index].sentence),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      updateNote(currentNotes[index]),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () =>
                                      deleteNote(currentNotes[index]),
                                ),
                              ],
                            )),
                      ),
                    );
                  } else {
                    // Handle the case where the index is out of bounds
                    return Container(); // Or any other widget to indicate an error
                  }
                }),
          ),
        ],
      ),
    );
  }
}

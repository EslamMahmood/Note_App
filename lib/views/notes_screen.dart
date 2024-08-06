import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../controllers/hive_controller.dart';
import '../models/note.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final HiveController _hiveController = HiveController();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _initialHive();
    _loadNotes();
  }

  void _initialHive() async {
    await _hiveController.init();
    _loadNotes();
  }

  void _loadNotes() async {
    final notes = await _hiveController.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  void _addNote() async {
    final note = Note(
      title: _titleController.text,
      content: _contentController.text,
      timestamp: DateTime.now().toString(),
    );

    await _hiveController.add(note);

    _titleController.clear();
    _contentController.clear();

    _loadNotes();
  }

  void _deleteNote(int index) async {
    await _hiveController.delete(index);
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image(image: AssetImage('lib/images/note_icon.png')),
                ),
                Text(
                  'My Notes',
                  style: TextStyle(fontFamily: 'Pacifico', fontSize: 30),
                ),
                Text('${_notes.length} notes',
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintText: 'title',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintText: 'content',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  final note = _notes[index];
                  return Card(
                    color: Colors.white,
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.title,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '• ${note.content}',
                                style: TextStyle(
                                    color: Colors.grey[800], fontSize: 13),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${note.timestamp.toString().substring(0, 16)}',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(CupertinoIcons.delete_solid),
                            onPressed: () => _deleteNote(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        foregroundColor: Colors.grey,
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }
}

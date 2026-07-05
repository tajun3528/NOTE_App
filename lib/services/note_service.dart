import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class NoteService {
  final CollectionReference<Map<String, dynamic>> _notes =
      FirebaseFirestore.instance.collection('notes');

  /// Fetch all notes, ordered by most recently updated.
  Stream<List<Note>> getNotes() {
    return _notes
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return Note.fromFirestore(doc.id, data);
            }).toList());
  }

  /// Add a new note.
  Future<void> addNote({required String title, required String description}) async {
    final now = DateTime.now();
    await _notes.add({
      'title': title,
      'description': description,
      'createdAt': Timestamp.fromDate(now),
      'updatedAt': Timestamp.fromDate(now),
    });
  }

  /// Update an existing note.
  Future<void> updateNote({
    required String id,
    required String title,
    required String description,
  }) async {
    final now = DateTime.now();
    await _notes.doc(id).update({
      'title': title,
      'description': description,
      'updatedAt': Timestamp.fromDate(now),
    });
  }

  /// Delete a note.
  Future<void> deleteNote(String id) async {
    await _notes.doc(id).delete();
  }
}
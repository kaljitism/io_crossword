import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_domain/game_domain.dart';

/// {@template crossword_repository}
/// Repository to manage the crossword.
/// {@endtemplate}
class CrosswordRepository {
  /// {@macro crossword_repository}
  CrosswordRepository({
    required this.db,
  }) {
    sectionCollection = db.collection('sections');
  }

  /// The [FirebaseFirestore] instance.
  final FirebaseFirestore db;

  /// The [CollectionReference] for the matches.
  late final CollectionReference<Map<String, dynamic>> sectionCollection;

  /// Watches a section of the crossword board
  Stream<BoardSection> watchSection(String id) {
    final ref = sectionCollection.doc(id);
    final docStream = ref.snapshots();
    return docStream.map((snapshot) {
      final id = snapshot.id;
      final data = {...snapshot.data() ?? {}, 'id': id};
      return BoardSection.fromJson(data);
    });
  }

  /// Watches all the sections of the crossword board
  Stream<List<BoardSection>> watchSections() {
    final snapshot = sectionCollection.snapshots();
    return snapshot.map(
      (snapshot) => snapshot.docs.map((doc) {
        final dataJson = doc.data();
        dataJson['id'] = doc.id;
        return BoardSection.fromJson(dataJson);
      }).toList(),
    );
  }

  /// Adds a board section
  Future<void> addSection(BoardSection section) async {
    await sectionCollection.doc(section.id).set(section.toJson());
  }
}
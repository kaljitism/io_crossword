import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:game_domain/game_domain.dart';

/// {@template crossword_repository}
/// Repository to manage the crossword.
/// {@endtemplate}
class CrosswordRepository {
  /// {@macro crossword_repository}
  CrosswordRepository({
    required this.db,
    Random? rng,
  }) : _rng = rng ?? Random(DateTime.now().millisecondsSinceEpoch) {
    sectionCollection = db.collection('boardChunks');
  }

  /// The [FirebaseFirestore] instance.
  final FirebaseFirestore db;

  /// The [CollectionReference] for the matches.
  late final CollectionReference<Map<String, dynamic>> sectionCollection;

  final Random _rng;

  /// Returns the position of a random section that has empty words.
  Future<BoardSection?> getRandomUncompletedSection(
    Point<int> bottomRight,
  ) async {
    final docsCount = await sectionCollection.count().get();
    final sectionCount = docsCount.count;
    if (sectionCount == null) {
      return null;
    }

    const minPos = Point(0, 0);
    final maxPos = bottomRight;

    final positions = <(int, int)>[];

    // Get all the possible positions from top left to bottom right
    for (var x = minPos.x; x <= maxPos.x; x++) {
      for (var y = minPos.y; y <= maxPos.y; y++) {
        positions.add((x, y));
      }
    }

    const batchSize = 20;

    // Get batches of 20 random sections until finding one with unsolved word
    for (var index = 0; index < positions.length; index += batchSize) {
      var endIndex = index + batchSize;
      if (endIndex > positions.length) {
        endIndex = positions.length;
      }

      final batchPositions = positions.sublist(index, endIndex);

      final result = await sectionCollection
          .where(
            'position',
            whereIn: batchPositions.map((e) => {'x': e.$1, 'y': e.$2}),
          )
          .get();

      // The coverage is ignored due to a bug in the fake_cloud_firestore
      // package. It does not handle the case when the whereIn query
      // has to match a map, which makes it difficult to test query results.
      // https://github.com/atn832/fake_cloud_firestore/issues/301.
      // coverage:ignore-start
      final sections = result.docs.map((sectionDoc) {
        return BoardSection.fromJson({
          'id': sectionDoc.id,
          ...sectionDoc.data(),
        });
      });

      final randomizedSections = sections.toList()..shuffle(_rng);

      final section = randomizedSections.firstWhereOrNull(
        (section) => section.words.any((word) => word.solvedTimestamp == null),
      );

      if (section != null) {
        return section;
      }
      // coverage:ignore-end
    }
    return null;
  }

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

  /// Watches the section having the corresponding position
  Stream<BoardSection?> watchSectionFromPosition(
    int x,
    int y,
  ) {
    final snapshot = sectionCollection
        .where(
          'position.x',
          isEqualTo: x,
        )
        .where(
          'position.y',
          isEqualTo: y,
        )
        .snapshots();
    return snapshot.map(
      (snapshot) {
        final doc = snapshot.docs.firstOrNull;
        if (doc != null) {
          final dataJson = doc.data();
          dataJson['id'] = doc.id;
          return BoardSection.fromJson(dataJson);
        }
        return null;
      },
    );
  }

  /// Loads all the sections of the crossword board.
  Stream<List<BoardSection>> loadBoardSections() {
    final snapshot = sectionCollection.snapshots().map(
          (snapshot) => snapshot.docs.map((doc) {
            final dataJson = doc.data();
            dataJson['id'] = doc.id;
            return BoardSection.fromJson(dataJson);
          }).toList(),
        );
    return snapshot;
  }
}

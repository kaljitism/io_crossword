// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/crossword/extensions/extensions.dart';

void main() {
  group('WordSize', () {
    final verticalWord = Word(
      position: Point(2, 7),
      axis: Axis.vertical,
      answer: 'hello',
      clue: '',
      hints: const [],
      solvedTimestamp: null,
    );
    final horizontalWord = Word(
      position: Point(3, 7),
      axis: Axis.horizontal,
      answer: 'exactly',
      clue: '',
      hints: const [],
      solvedTimestamp: null,
    );

    test('returns correct width for vertical word', () {
      expect(verticalWord.width, 1 * CrosswordGame.cellSize);
    });

    test('returns correct width for horizontal word', () {
      expect(horizontalWord.width, 7 * CrosswordGame.cellSize);
    });

    test('returns correct height for horizontal word', () {
      expect(horizontalWord.height, 1 * CrosswordGame.cellSize);
    });

    test('returns correct height for vertical word', () {
      expect(verticalWord.height, 5 * CrosswordGame.cellSize);
    });
  });
}
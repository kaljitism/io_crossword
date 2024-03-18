// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/game_intro/game_intro.dart';

void main() {
  group('GameIntroEvent', () {
    group('BoardProgressRequested', () {
      test('supports value comparisons', () {
        expect(
          BoardProgressRequested(),
          equals(BoardProgressRequested()),
        );
      });
    });

    group('WelcomeCompleted', () {
      test('supports value comparisons', () {
        expect(
          WelcomeCompleted(),
          equals(WelcomeCompleted()),
        );
      });
    });

    group('MascotUpdated', () {
      test('supports value comparisons', () {
        expect(
          MascotUpdated(Mascots.sparky),
          equals(MascotUpdated(Mascots.sparky)),
        );
      });
    });

    group('MascotSubmitted', () {
      test('supports value comparisons', () {
        expect(
          MascotSubmitted(),
          equals(MascotSubmitted()),
        );
      });
    });

    group('InitialsSubmitted', () {
      test('supports value comparisons', () {
        expect(
          InitialsSubmitted(),
          equals(InitialsSubmitted()),
        );
      });
    });
  });
}

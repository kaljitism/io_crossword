// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/leaderboard/bloc/leaderboard_bloc.dart';
import 'package:mocktail/mocktail.dart';

class _MockLeaderboardResource extends Mock implements LeaderboardResource {}

void main() {
  group('$LeaderboardBloc', () {
    late LeaderboardResource leaderboardResource;
    late LeaderboardBloc bloc;

    setUp(() {
      leaderboardResource = _MockLeaderboardResource();
      bloc = LeaderboardBloc(
        leaderboardResource: leaderboardResource,
      );
    });

    group('$LoadRequestedLeaderboardEvent', () {
      blocTest<LeaderboardBloc, LeaderboardState>(
        'emits [empty] when getLeaderboardResults returns no players',
        setUp: () {
          when(() => leaderboardResource.getLeaderboardResults())
              .thenAnswer((_) async => []);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(LoadRequestedLeaderboardEvent()),
        expect: () => [
          LeaderboardState(
            status: LeaderboardStatus.empty,
          ),
        ],
      );

      blocTest<LeaderboardBloc, LeaderboardState>(
        'emits [success] when getLeaderboardResults returns players',
        setUp: () {
          when(() => leaderboardResource.getLeaderboardResults()).thenAnswer(
            (_) async => [
              LeaderboardPlayer(userId: '1', initials: 'AAA', score: 100),
              LeaderboardPlayer(userId: '2', initials: 'BBB', score: 80),
              LeaderboardPlayer(userId: '3', initials: 'CCC', score: 60),
            ],
          );
        },
        build: () => bloc,
        act: (bloc) => bloc.add(LoadRequestedLeaderboardEvent()),
        expect: () => [
          LeaderboardState(
            status: LeaderboardStatus.success,
            players: [
              LeaderboardPlayer(userId: '1', initials: 'AAA', score: 100),
              LeaderboardPlayer(userId: '2', initials: 'BBB', score: 80),
              LeaderboardPlayer(userId: '3', initials: 'CCC', score: 60),
            ],
          ),
        ],
      );

      blocTest<LeaderboardBloc, LeaderboardState>(
        'emits [failure] when getLeaderboardResults throws exception',
        setUp: () {
          when(() => leaderboardResource.getLeaderboardResults())
              .thenThrow(Exception());
        },
        build: () => bloc,
        act: (bloc) => bloc.add(LoadRequestedLeaderboardEvent()),
        expect: () => [
          LeaderboardState(
            status: LeaderboardStatus.failure,
          ),
        ],
      );
    });
  });
}
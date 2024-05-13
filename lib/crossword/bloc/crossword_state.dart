part of 'crossword_bloc.dart';

enum CrosswordStatus {
  initial,
  success,
  failure,
}

enum BoardStatus {
  inProgress,
  resetInProgress,
}

class CrosswordState extends Equatable {
  const CrosswordState({
    this.status = CrosswordStatus.initial,
    this.gameStatus = GameStatus.inProgress,
    this.boardStatus = BoardStatus.inProgress,
    this.sectionSize = 0,
    this.sections = const {},
    this.zoomLimit = 0.35,
    this.mascotVisible = true,
    this.bottomRight = (0, 0),
  });

  final CrosswordStatus status;
  final GameStatus gameStatus;
  final BoardStatus boardStatus;
  final int sectionSize;
  final Map<(int, int), BoardSection> sections;
  final double zoomLimit;
  final bool mascotVisible;
  final CrosswordChunkIndex bottomRight;

  CrosswordState copyWith({
    CrosswordStatus? status,
    GameStatus? gameStatus,
    BoardStatus? boardStatus,
    int? sectionSize,
    Map<(int, int), BoardSection>? sections,
    double? zoomLimit,
    bool? mascotVisible,
    CrosswordConfiguration? configuration,
    CrosswordChunkIndex? bottomRight,
  }) {
    return CrosswordState(
      status: status ?? this.status,
      gameStatus: gameStatus ?? this.gameStatus,
      boardStatus: boardStatus ?? this.boardStatus,
      sectionSize: sectionSize ?? this.sectionSize,
      sections: sections ?? this.sections,
      zoomLimit: zoomLimit ?? this.zoomLimit,
      mascotVisible: mascotVisible ?? this.mascotVisible,
      bottomRight: bottomRight ?? this.bottomRight,
    );
  }

  @override
  List<Object?> get props => [
        status,
        gameStatus,
        boardStatus,
        sectionSize,
        sections,
        zoomLimit,
        mascotVisible,
        bottomRight,
      ];
}

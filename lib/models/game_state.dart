import 'tile.dart';

class Position {
  final int row;
  final int col;

  const Position(this.row, this.col);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Position && runtimeType == other.runtimeType && row == other.row && col == other.col;

  @override
  int get hashCode => row.hashCode ^ col.hashCode;

  @override
  String toString() => 'Position($row, $col)';
}

class Move {
  final Position from;
  final Position to;
  final List<List<Tile>> previousGrid;

  Move({
    required this.from,
    required this.to,
    required this.previousGrid,
  });
}

class GameState {
  List<List<Tile>> grid;
  List<Move> moveHistory;
  Position? selectedTile;
  List<Position> validMoves;
  int gridSize;
  bool isGameWon;

  GameState({
    required this.gridSize,
    List<List<Tile>>? initialGrid,
  })  : grid = initialGrid ?? _createEmptyGrid(gridSize),
        moveHistory = [],
        selectedTile = null,
        validMoves = [],
        isGameWon = false;

  static List<List<Tile>> _createEmptyGrid(int size) {
    return List.generate(
      size,
      (i) => List.generate(
        size,
        (j) => Tile(color: TileColor.empty),
      ),
    );
  }

  void initializeRandomGrid() {
    final colors = [
      TileColor.red,
      TileColor.blue,
      TileColor.yellow,
      TileColor.violet,
      TileColor.orange,
      TileColor.green,
    ];

    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        colors.shuffle();
        grid[i][j] = Tile(color: colors.first);
      }
    }
  }

  Tile getTile(Position pos) {
    if (pos.row >= 0 && pos.row < gridSize && pos.col >= 0 && pos.col < gridSize) {
      return grid[pos.row][pos.col];
    }
    return Tile(color: TileColor.empty);
  }

  void setTile(Position pos, Tile tile) {
    if (pos.row >= 0 && pos.row < gridSize && pos.col >= 0 && pos.col < gridSize) {
      grid[pos.row][pos.col] = tile;
    }
  }

  List<Position> getAdjacentPositions(Position pos) {
    final positions = <Position>[];
    final directions = [
      [-1, -1], [-1, 0], [-1, 1], // Top row
      [0, -1], [0, 1], // Middle row (excluding center)
      [1, -1], [1, 0], [1, 1], // Bottom row
    ];

    for (final dir in directions) {
      final newRow = pos.row + dir[0];
      final newCol = pos.col + dir[1];
      if (newRow >= 0 && newRow < gridSize && newCol >= 0 && newCol < gridSize) {
        positions.add(Position(newRow, newCol));
      }
    }
    return positions;
  }

  int getNonEmptyTileCount() {
    int count = 0;
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (!grid[i][j].isEmpty) {
          count++;
        }
      }
    }
    return count;
  }

  void checkWinCondition() {
    isGameWon = getNonEmptyTileCount() == 1;
  }

  List<List<Tile>> copyGrid() {
    return grid.map((row) => row.map((tile) => tile.copy()).toList()).toList();
  }

  void clearHighlights() {
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        grid[i][j].isHighlighted = false;
        grid[i][j].isSelected = false;
      }
    }
  }
} 
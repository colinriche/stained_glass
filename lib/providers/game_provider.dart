import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';
import '../models/tile.dart';
import 'dart:convert';

class GameProvider extends ChangeNotifier {
  GameState _gameState = GameState(gridSize: 6);
  bool _isLoading = false;

  GameState get gameState => _gameState;
  bool get isLoading => _isLoading;

  void newGame({int gridSize = 6}) {
    _gameState = GameState(gridSize: gridSize);
    _gameState.initializeRandomGrid();
    _gameState.checkWinCondition();
    notifyListeners();
    _saveGame();
  }

  void selectTile(Position position) {
    final tile = _gameState.getTile(position);
    
    if (tile.isEmpty) return;

    _gameState.clearHighlights();
    
    if (_gameState.selectedTile == position) {
      // Deselect if clicking the same tile
      _gameState.selectedTile = null;
      _gameState.validMoves.clear();
    } else {
      // Select new tile
      _gameState.selectedTile = position;
      tile.isSelected = true;
      _gameState.validMoves = _calculateValidMoves(position);
      
      // Highlight valid moves
      for (final move in _gameState.validMoves) {
        _gameState.getTile(move).isHighlighted = true;
      }
    }
    
    notifyListeners();
  }

  void makeMove(Position to) {
    if (_gameState.selectedTile == null) return;
    if (!_gameState.validMoves.contains(to)) return;

    final from = _gameState.selectedTile!;
    final fromTile = _gameState.getTile(from);
    final toTile = _gameState.getTile(to);

    // Save the move for undo functionality
    final previousGrid = _gameState.copyGrid();
    _gameState.moveHistory.add(Move(
      from: from,
      to: to,
      previousGrid: previousGrid,
    ));

    // Execute the move based on game rules
    _executeMoveLogic(from, to);

    _gameState.clearHighlights();
    _gameState.selectedTile = null;
    _gameState.validMoves.clear();
    _gameState.checkWinCondition();
    
    notifyListeners();
    _saveGame();
  }

  List<Position> _calculateValidMoves(Position from) {
    final validMoves = <Position>[];
    final fromTile = _gameState.getTile(from);
    
    if (fromTile.isEmpty) return validMoves;

    // Get all adjacent positions (including diagonals)
    final adjacentPositions = _gameState.getAdjacentPositions(from);
    
    for (final adjacent in adjacentPositions) {
      final adjacentTile = _gameState.getTile(adjacent);
      
      // Rule 1: Same color adjacent - can move onto
      if (!adjacentTile.isEmpty && adjacentTile.color == fromTile.color) {
        validMoves.add(adjacent);
      }
      
      // Rule 2: Same color jump over middle tile
      final direction = Position(adjacent.row - from.row, adjacent.col - from.col);
      final jumpTo = Position(adjacent.row + direction.row, adjacent.col + direction.col);
      
      if (_isValidPosition(jumpTo)) {
        final jumpToTile = _gameState.getTile(jumpTo);
        
        // Can jump to same color or empty space
        if (!adjacentTile.isEmpty && 
            (jumpToTile.isEmpty || jumpToTile.color == fromTile.color)) {
          validMoves.add(jumpTo);
        }
        
        // Rule 3: Primary over secondary color logic
        if (fromTile.isPrimary && adjacentTile.isSecondary) {
          final components = adjacentTile.getPrimaryComponents();
          if (components.contains(fromTile.color)) {
            validMoves.add(jumpTo);
          }
        }
        
        // Rule 4: Primary color combination logic
        if (fromTile.isPrimary && adjacentTile.isPrimary && 
            fromTile.color != adjacentTile.color && jumpToTile.isPrimary &&
            jumpToTile.color != fromTile.color && jumpToTile.color != adjacentTile.color) {
          validMoves.add(jumpTo);
        }
      }
      
      // Can also jump into empty adjacent cells
      if (adjacentTile.isEmpty) {
        validMoves.add(adjacent);
      }
    }
    
    return validMoves;
  }

  bool _isValidPosition(Position pos) {
    return pos.row >= 0 && pos.row < _gameState.gridSize && 
           pos.col >= 0 && pos.col < _gameState.gridSize;
  }

  void _executeMoveLogic(Position from, Position to) {
    final fromTile = _gameState.getTile(from);
    final toTile = _gameState.getTile(to);
    
    // Calculate the middle position if this is a jump
    final rowDiff = to.row - from.row;
    final colDiff = to.col - from.col;
    
    if (rowDiff.abs() <= 1 && colDiff.abs() <= 1) {
      // Adjacent move - simple replacement
      _gameState.setTile(to, fromTile.copy());
      _gameState.setTile(from, Tile(color: TileColor.empty));
    } else {
      // Jump move - need to handle middle tile
      final middleRow = from.row + (rowDiff ~/ 2);
      final middleCol = from.col + (colDiff ~/ 2);
      final middle = Position(middleRow, middleCol);
      final middleTile = _gameState.getTile(middle);
      
      // Apply complex color logic
      if (fromTile.isPrimary && middleTile.isSecondary) {
        // Primary jumping over secondary
        final components = middleTile.getPrimaryComponents();
        if (components.contains(fromTile.color)) {
          final remainingColor = Tile.removePrimaryFromSecondary(middleTile.color, fromTile.color);
          _gameState.setTile(middle, Tile(color: remainingColor));
          
          if (toTile.isEmpty) {
            _gameState.setTile(to, fromTile.copy());
          } else {
            // Combine colors at destination
            final combinedColor = _combineColors(fromTile.color, toTile.color);
            _gameState.setTile(to, Tile(color: combinedColor));
          }
        }
      } else if (fromTile.isPrimary && middleTile.isPrimary && toTile.isPrimary) {
        // Three different primary colors
        final combinedColor = Tile.combinePrimaries(fromTile.color, toTile.color);
        _gameState.setTile(to, Tile(color: combinedColor));
        _gameState.setTile(middle, Tile(color: TileColor.empty));
      } else {
        // Standard jump
        _gameState.setTile(to, fromTile.copy());
        _gameState.setTile(middle, Tile(color: TileColor.empty));
      }
      
      _gameState.setTile(from, Tile(color: TileColor.empty));
    }
  }

  TileColor _combineColors(TileColor color1, TileColor color2) {
    if (color1 == color2) return color1;
    
    // If both are primary, combine them
    if ([TileColor.red, TileColor.blue, TileColor.yellow].contains(color1) &&
        [TileColor.red, TileColor.blue, TileColor.yellow].contains(color2)) {
      return Tile.combinePrimaries(color1, color2);
    }
    
    // If one is secondary and contains all three primaries, result is white
    if (color1 == TileColor.white || color2 == TileColor.white) {
      return TileColor.white;
    }
    
    return color1; // Default fallback
  }

  void undoMove() {
    if (_gameState.moveHistory.isNotEmpty) {
      final lastMove = _gameState.moveHistory.removeLast();
      _gameState.grid = lastMove.previousGrid;
      _gameState.clearHighlights();
      _gameState.selectedTile = null;
      _gameState.validMoves.clear();
      _gameState.checkWinCondition();
      notifyListeners();
      _saveGame();
    }
  }

  void resetGame() {
    _gameState.grid = _gameState.copyGrid();
    _gameState.moveHistory.clear();
    _gameState.clearHighlights();
    _gameState.selectedTile = null;
    _gameState.validMoves.clear();
    _gameState.isGameWon = false;
    _gameState.initializeRandomGrid();
    _gameState.checkWinCondition();
    notifyListeners();
    _saveGame();
  }

  Future<void> _saveGame() async {
    try {
      final gameData = {
        'gridSize': _gameState.gridSize,
        'grid': _gameState.grid.map((row) => 
          row.map((tile) => tile.color.index).toList()
        ).toList(),
        'isGameWon': _gameState.isGameWon,
      };
      
      // Use SharedPreferences for all platforms
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_game', jsonEncode(gameData));
    } catch (e) {
      if (kDebugMode) {
        print('Error saving game: $e');
      }
    }
  }

  Future<void> loadGame() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final prefs = await SharedPreferences.getInstance();
      final savedGame = prefs.getString('saved_game');
      
      if (savedGame != null) {
        final gameData = jsonDecode(savedGame);
        final gridSize = gameData['gridSize'] as int;
        final gridData = gameData['grid'] as List;
        
        _gameState = GameState(gridSize: gridSize);
        
        for (int i = 0; i < gridSize; i++) {
          for (int j = 0; j < gridSize; j++) {
            final colorIndex = gridData[i][j] as int;
            _gameState.grid[i][j] = Tile(color: TileColor.values[colorIndex]);
          }
        }
        
        _gameState.isGameWon = gameData['isGameWon'] as bool;
      } else {
        newGame();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading game: $e');
      }
      newGame();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 
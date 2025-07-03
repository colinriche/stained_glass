import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/game_state.dart';
import 'game_tile.dart';

class GameGrid extends StatelessWidget {
  const GameGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final gameState = gameProvider.gameState;
        final screenWidth = MediaQuery.of(context).size.width;
        final maxGridWidth = screenWidth * 0.45; // 45% of screen width
        final tileSize = (maxGridWidth / gameState.gridSize) - 4;
        
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.grey.shade100,
                Colors.grey.shade200,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Game status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: gameState.isGameWon 
                      ? Colors.green.shade100
                      : Colors.blue.shade50,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tiles: ${gameState.getNonEmptyTileCount()}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    if (gameState.isGameWon)
                      Row(
                        children: [
                          Icon(
                            Icons.celebration,
                            color: Colors.green.shade600,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'You Won!',
                            style: TextStyle(
                              color: Colors.green.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              
              // Game grid
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(8),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gameState.gridSize,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    childAspectRatio: 1,
                  ),
                  itemCount: gameState.gridSize * gameState.gridSize,
                  itemBuilder: (context, index) {
                    final row = index ~/ gameState.gridSize;
                    final col = index % gameState.gridSize;
                    final position = Position(row, col);
                    final tile = gameState.getTile(position);

                    return GameTile(
                      tile: tile,
                      size: tileSize,
                      onTap: () {
                        if (gameState.selectedTile == null) {
                          // Select tile
                          gameProvider.selectTile(position);
                        } else if (gameState.selectedTile == position) {
                          // Deselect tile
                          gameProvider.selectTile(position);
                        } else if (gameState.validMoves.contains(position)) {
                          // Make move
                          gameProvider.makeMove(position);
                        } else {
                          // Select different tile
                          gameProvider.selectTile(position);
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 
import 'package:flutter/material.dart';
import '../models/tile.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How to Play'),
        backgroundColor: Colors.deepPurple.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade50,
              Colors.indigo.shade100,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildObjectiveCard(),
              const SizedBox(height: 16),
              _buildColorsCard(),
              const SizedBox(height: 16),
              _buildRulesCard(),
              const SizedBox(height: 16),
              _buildTipsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildObjectiveCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.flag,
                  color: Colors.green.shade600,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  'Objective',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Clear the board until only ONE tile remains. Use color combinations and strategic moves to eliminate tiles according to the game rules.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.palette,
                  color: Colors.purple.shade600,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  'Color System',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Primary Colors
            Text(
              'Primary Colors:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildColorTile(TileColor.red, 'Red'),
                const SizedBox(width: 12),
                _buildColorTile(TileColor.blue, 'Blue'),
                const SizedBox(width: 12),
                _buildColorTile(TileColor.yellow, 'Yellow'),
              ],
            ),
            const SizedBox(height: 16),
            
            // Secondary Colors
            Text(
              'Secondary Colors:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildColorTile(TileColor.violet, 'Violet\n(Red + Blue)'),
                const SizedBox(width: 12),
                _buildColorTile(TileColor.orange, 'Orange\n(Red + Yellow)'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildColorTile(TileColor.green, 'Green\n(Blue + Yellow)'),
                const SizedBox(width: 12),
                _buildColorTile(TileColor.white, 'White\n(All Colors)'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorTile(TileColor color, String label) {
    final tile = Tile(color: color);
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: tile.displayColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRulesCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.rule,
                  color: Colors.blue.shade600,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  'Game Rules',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildRuleItem(
              '1. Same Color Adjacent',
              'If two adjacent tiles are the same color, one can move onto the other, replacing it and leaving an empty cell.',
              Icons.arrow_forward,
              Colors.green,
            ),
            
            _buildRuleItem(
              '2. Same Color Jump',
              'If three tiles in a line are the same color, the first can jump over the middle to land on the third, leaving the first two cells empty.',
              Icons.redo,
              Colors.orange,
            ),
            
            _buildRuleItem(
              '3. Primary over Secondary',
              'When a primary color jumps over a secondary color that contains it, the secondary color is reduced to its remaining primary color.',
              Icons.remove_circle,
              Colors.red,
            ),
            
            _buildRuleItem(
              '4. Primary Combination',
              'When three different primary colors are adjacent, one can jump to the third position, creating a secondary color from the combination.',
              Icons.add_circle,
              Colors.purple,
            ),
            
            _buildRuleItem(
              '5. Empty Cell Moves',
              'You can jump into empty cells. Diagonal moves are allowed. Each move is independent.',
              Icons.grid_on,
              Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleItem(String title, String description, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb,
                  color: Colors.amber.shade600,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  'Tips & Controls',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildTipItem('Tap a tile to select it and see available moves'),
            _buildTipItem('Valid moves are highlighted in amber'),
            _buildTipItem('Tap a highlighted tile to make your move'),
            _buildTipItem('Use the Undo button to reverse your last move'),
            _buildTipItem('Try different grid sizes in Settings'),
            _buildTipItem('The game saves automatically'),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.amber.shade600,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 
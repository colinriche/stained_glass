import 'package:flutter/material.dart';
import '../models/tile.dart';

class GameTile extends StatefulWidget {
  final Tile tile;
  final VoidCallback onTap;
  final double size;

  const GameTile({
    super.key,
    required this.tile,
    required this.onTap,
    this.size = 60.0,
  });

  @override
  State<GameTile> createState() => _GameTileState();
}

class _GameTileState extends State<GameTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(GameTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Animate when tile becomes highlighted
    if (widget.tile.isHighlighted && !oldWidget.tile.isHighlighted) {
      _animationController.repeat(reverse: true);
    } else if (!widget.tile.isHighlighted && oldWidget.tile.isHighlighted) {
      _animationController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.tile.isSelected 
              ? _scaleAnimation.value 
              : widget.tile.isHighlighted 
                  ? _pulseAnimation.value 
                  : 1.0,
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: widget.tile.isEmpty
                    ? null
                    : [
                        BoxShadow(
                          color: widget.tile.displayColor.withOpacity(0.3),
                          blurRadius: widget.tile.isSelected ? 12 : 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: widget.tile.isEmpty 
                      ? Colors.grey.shade200
                      : widget.tile.displayColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: widget.tile.isSelected
                        ? Colors.white
                        : widget.tile.isHighlighted
                            ? Colors.amber
                            : Colors.transparent,
                    width: widget.tile.isSelected || widget.tile.isHighlighted ? 3 : 1,
                  ),
                  gradient: widget.tile.isEmpty
                      ? null
                      : LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            widget.tile.displayColor,
                            widget.tile.displayColor.withOpacity(0.8),
                          ],
                        ),
                ),
                child: widget.tile.isEmpty
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.shade100,
                        ),
                        child: widget.tile.isHighlighted
                            ? Icon(
                                Icons.radio_button_unchecked,
                                color: Colors.amber.shade600,
                                size: widget.size * 0.4,
                              )
                            : null,
                      )
                    : Stack(
                        children: [
                          // Main tile content
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  widget.tile.displayColor.withOpacity(0.9),
                                  widget.tile.displayColor,
                                ],
                              ),
                            ),
                          ),
                          // Highlight overlay
                          if (widget.tile.isHighlighted)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.amber.withOpacity(0.3),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: widget.size * 0.4,
                                ),
                              ),
                            ),
                          // Selection overlay
                          if (widget.tile.isSelected)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white.withOpacity(0.2),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.touch_app,
                                  color: Colors.white,
                                  size: widget.size * 0.4,
                                ),
                              ),
                            ),
                          // Glass effect
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.center,
                                colors: [
                                  Colors.white.withOpacity(0.3),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
} 
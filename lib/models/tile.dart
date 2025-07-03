import 'package:flutter/material.dart';

enum TileColor {
  empty,
  red,
  blue,
  yellow,
  violet,
  orange,
  green,
  white,
}

class Tile {
  TileColor color;
  bool isHighlighted;
  bool isSelected;

  Tile({
    required this.color,
    this.isHighlighted = false,
    this.isSelected = false,
  });

  bool get isEmpty => color == TileColor.empty;
  bool get isPrimary => [TileColor.red, TileColor.blue, TileColor.yellow].contains(color);
  bool get isSecondary => [TileColor.violet, TileColor.orange, TileColor.green].contains(color);

  Color get displayColor {
    switch (color) {
      case TileColor.empty:
        return Colors.transparent;
      case TileColor.red:
        return Colors.red.shade600;
      case TileColor.blue:
        return Colors.blue.shade600;
      case TileColor.yellow:
        return Colors.yellow.shade600;
      case TileColor.violet:
        return Colors.purple.shade600;
      case TileColor.orange:
        return Colors.orange.shade600;
      case TileColor.green:
        return Colors.green.shade600;
      case TileColor.white:
        return Colors.white;
    }
  }

  // Get the primary colors that make up a secondary color
  List<TileColor> getPrimaryComponents() {
    switch (color) {
      case TileColor.violet:
        return [TileColor.red, TileColor.blue];
      case TileColor.orange:
        return [TileColor.red, TileColor.yellow];
      case TileColor.green:
        return [TileColor.blue, TileColor.yellow];
      default:
        return [];
    }
  }

  // Combine two primary colors to create a secondary color
  static TileColor combinePrimaries(TileColor color1, TileColor color2) {
    final colors = {color1, color2};
    if (colors.contains(TileColor.red) && colors.contains(TileColor.blue)) {
      return TileColor.violet;
    } else if (colors.contains(TileColor.red) && colors.contains(TileColor.yellow)) {
      return TileColor.orange;
    } else if (colors.contains(TileColor.blue) && colors.contains(TileColor.yellow)) {
      return TileColor.green;
    }
    return TileColor.empty;
  }

  // Remove a primary color from a secondary color
  static TileColor removePrimaryFromSecondary(TileColor secondary, TileColor primary) {
    switch (secondary) {
      case TileColor.violet:
        if (primary == TileColor.red) return TileColor.blue;
        if (primary == TileColor.blue) return TileColor.red;
        break;
      case TileColor.orange:
        if (primary == TileColor.red) return TileColor.yellow;
        if (primary == TileColor.yellow) return TileColor.red;
        break;
      case TileColor.green:
        if (primary == TileColor.blue) return TileColor.yellow;
        if (primary == TileColor.yellow) return TileColor.blue;
        break;
      default:
        break;
    }
    return TileColor.empty;
  }

  Tile copy() {
    return Tile(
      color: color,
      isHighlighted: isHighlighted,
      isSelected: isSelected,
    );
  }
} 
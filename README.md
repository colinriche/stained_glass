# Stained Glass - Flutter Puzzle Game

A modern Flutter implementation of the classic DOS puzzle game "Stained Glass". This cross-platform app works seamlessly on mobile devices and in web browsers, featuring beautiful animations, intuitive controls, and the complete rule set from the original game.

## 🎮 Game Overview

Stained Glass is a single-player puzzle game based on color combinations. The objective is to clear the board of all but one tile using strategic moves and color combination rules.

### Key Features

- **Cross-Platform**: Works on Android, iOS, and Web browsers
- **Modern UI**: Beautiful gradient backgrounds, smooth animations, and glass-effect tiles
- **Complete Rule Set**: All original game mechanics faithfully implemented
- **Save System**: Automatic game saving and loading
- **Undo Functionality**: Reverse your moves when needed
- **Multiple Grid Sizes**: Choose from 4x4 to 8x8 grids
- **Responsive Design**: Adapts to different screen sizes
- **Offline Play**: No internet connection required

## 🎯 How to Play

### Objective
Clear the board until only **ONE** tile remains using the color combination rules.

### Color System
- **Primary Colors**: Red, Blue, Yellow
- **Secondary Colors**: 
  - Violet (Red + Blue)
  - Orange (Red + Yellow) 
  - Green (Blue + Yellow)
- **White**: All three primary colors combined

### Game Rules

1. **Same Color Adjacent**: Move one tile onto an adjacent tile of the same color
2. **Same Color Jump**: Jump over a middle tile to land on a tile of the same color
3. **Primary over Secondary**: When a primary color jumps over a secondary color containing it, the secondary reduces to its remaining primary color
4. **Primary Combination**: Combine three different primary colors to create secondary colors
5. **Empty Cell Moves**: Jump into empty cells, diagonal moves allowed

### Controls
- Tap a tile to select it and see available moves
- Valid moves are highlighted in amber
- Tap a highlighted tile to make your move
- Use game controls for New Game, Undo, and Reset

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.10.0 or higher)
- Dart SDK (3.0.0 or higher)
- For mobile: Android Studio/Xcode
- For web: Chrome/Firefox/Safari

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd stained_glass
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   
   **For mobile devices:**
   ```bash
   flutter run
   ```
   
   **For web browser:**
   ```bash
   flutter run -d chrome
   ```

### Building for Production

**Android APK:**
```bash
flutter build apk --release
```

**iOS (requires macOS and Xcode):**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── tile.dart            # Tile model and color logic
│   └── game_state.dart      # Game state management
├── providers/
│   └── game_provider.dart   # Game logic and state provider
├── screens/
│   ├── game_screen.dart     # Main game screen
│   └── rules_screen.dart    # How to play screen
└── widgets/
    ├── game_tile.dart       # Individual tile widget
    └── game_grid.dart       # Game board widget
```

## 🎨 Technical Features

### Architecture
- **Provider Pattern**: State management using Flutter Provider
- **Model-View-ViewModel**: Clean separation of concerns
- **Responsive Design**: Adapts to different screen sizes

### Animations
- Smooth tile selection and highlighting
- Pulsing animations for valid moves
- Scale animations for tile interactions
- Gradient transitions and shadow effects

### Game Logic
- Complete implementation of all original game rules
- Complex color combination algorithms
- Move validation and highlighting
- Undo/Redo functionality with move history

### Cross-Platform Features
- **Mobile**: Touch-optimized controls, haptic feedback
- **Web**: Mouse and touch support, PWA capabilities
- **Responsive**: Scales beautifully on all screen sizes

## 🔧 Configuration

### Grid Sizes
The game supports multiple grid sizes (4x4 to 8x8). Change the default in `GameProvider`:

```dart
void newGame({int gridSize = 6}) {
  // Default is 6x6, can be changed via settings
}
```

### Colors
Customize tile colors in `models/tile.dart`:

```dart
Color get displayColor {
  switch (color) {
    case TileColor.red:
      return Colors.red.shade600;
    // Add custom colors here
  }
}
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📱 Screenshots

The game features:
- Beautiful gradient backgrounds
- Glass-effect tiles with shadows
- Smooth animations and transitions
- Intuitive touch controls
- Clear visual feedback for valid moves

## 🔮 Future Enhancements

- [ ] Hint system for suggesting moves
- [ ] Achievement system
- [ ] Multiple puzzle layouts
- [ ] Sound effects and music
- [ ] Multiplayer mode
- [ ] Puzzle generator with difficulty levels
- [ ] Statistics and progress tracking

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Original Stained Glass DOS game creators
- Flutter team for the amazing framework
- Community contributors and testers

---

**Enjoy playing Stained Glass!** 🌈✨ 
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class MemoryGame extends StatefulWidget {
  const MemoryGame({super.key});

  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  // Colores según el diseño: verde, amarillo, azul, rojo
  final List<Color> _colors = const [
    Color(0xFF4CAF50), // Verde
    Color(0xFFFFEB3B), // Amarillo
    Color(0xFF2196F3), // Azul
    Color(0xFFF44336), // Rojo
  ];

  final List<Color> _activeColors = const [
    Color(0xFF8BC34A), // Verde brillante
    Color(0xFFFFF176), // Amarillo brillante
    Color(0xFF64B5F6), // Azul brillante
    Color(0xFFEF5350), // Rojo brillante
  ];

  List<int> _gameSequence = [];
  List<int> _playerSequence = [];
  int _level = 0;
  bool _isPlayerTurn = false;
  bool _gameInProgress = false;
  int? _activeColorIndex;
  String _message = "START";

  void _startGame() {
    setState(() {
      _gameInProgress = true;
      _level = 0;
      _gameSequence = [];
      _nextLevel();
    });
  }

  void _nextLevel() {
    setState(() {
      _level++;
      _message = "$_level";
      _playerSequence = [];
      _isPlayerTurn = false;
    });

    final random = Random();
    _gameSequence.add(random.nextInt(4));
    _playSequence();
  }

  Future<void> _playSequence() async {
    await Future.delayed(const Duration(milliseconds: 600));

    for (int colorIndex in _gameSequence) {
      await _lightUpQuadrant(colorIndex);
      await Future.delayed(const Duration(milliseconds: 300));
    }

    setState(() {
      _isPlayerTurn = true;
      _message = "YOUR TURN!";
    });
  }

  Future<void> _lightUpQuadrant(int colorIndex) async {
    setState(() => _activeColorIndex = colorIndex);
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() => _activeColorIndex = null);
  }

  void _onPlayerTap(int colorIndex) {
    if (!_isPlayerTurn || !_gameInProgress) return;

    _lightUpQuadrant(colorIndex);
    _playerSequence.add(colorIndex);
    _checkPlayerSequence();
  }

  void _checkPlayerSequence() {
    int currentTapIndex = _playerSequence.length - 1;

    if (_playerSequence[currentTapIndex] != _gameSequence[currentTapIndex]) {
      _gameOver();
      return;
    }

    if (_playerSequence.length == _gameSequence.length) {
      setState(() {
        _isPlayerTurn = false;
        _message = "GOOD!";
      });
      Future.delayed(const Duration(seconds: 1), _nextLevel);
    }
  }

  void _gameOver() {
    setState(() {
      _message = "FAIL\nLevel $_level";
      _isPlayerTurn = false;
      _gameInProgress = false;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && !_gameInProgress) {
        setState(() {
          _message = "START";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double gameSize = screenWidth * 0.9;

    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2C2C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Level $_level',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: gameSize,
            height: gameSize,
            child: Stack(
              children: [
                // Cuadrantes de colores con el nuevo diseño
                _buildQuadrant(0, Alignment.topLeft),
                _buildQuadrant(1, Alignment.topRight),
                _buildQuadrant(2, Alignment.bottomRight),
                _buildQuadrant(3, Alignment.bottomLeft),

                // Botón central
                Center(
                  child: GestureDetector(
                    onTap: _gameInProgress ? null : _startGame,
                    child: Container(
                      width: gameSize * 0.35,
                      height: gameSize * 0.35,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2C2C),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(4, 4),
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(-4, -4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: gameSize * 0.06,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuadrant(int colorIndex, Alignment alignment) {
    BorderRadius borderRadius;
    switch (alignment.toString()) {
      case 'Alignment.topLeft':
        borderRadius = const BorderRadius.only(topLeft: Radius.circular(1000));
        break;
      case 'Alignment.topRight':
        borderRadius = const BorderRadius.only(topRight: Radius.circular(1000));
        break;
      case 'Alignment.bottomLeft':
        borderRadius = const BorderRadius.only(bottomLeft: Radius.circular(1000));
        break;
      case 'Alignment.bottomRight':
        borderRadius = const BorderRadius.only(bottomRight: Radius.circular(1000));
        break;
      default:
        borderRadius = BorderRadius.zero;
    }

    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: () => _onPlayerTap(colorIndex),
        child: FractionallySizedBox(
          widthFactor: 0.5,
          heightFactor: 0.5,
          child: Container(
            decoration: BoxDecoration(
              color: _activeColorIndex == colorIndex 
                  ? _activeColors[colorIndex] 
                  : _colors[colorIndex],
              borderRadius: borderRadius,
              border: Border.all(color: Colors.black, width: 4),
              boxShadow: _activeColorIndex == colorIndex
                  ? [
                      BoxShadow(
                        color: _colors[colorIndex].withOpacity(0.8),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

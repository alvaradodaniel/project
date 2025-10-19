import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class MemoryGame extends StatefulWidget {
  const MemoryGame({super.key});

  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  final List<Color> _colors = const [
    Color(0xFF30FE15),
    Color(0xFFFED215),
    Color(0xFF0066B2),
    Color(0xFFFE1616),
  ];

  final List<Color> _activeColors = const [
    Color.fromARGB(255, 14, 75, 7),
    Color.fromARGB(255, 99, 82, 9),
    Color.fromARGB(255, 0, 53, 94),
    Color.fromARGB(255, 104, 9, 9),
  ];

  List<int> _gameSequence = [];
  List<int> _playerSequence = [];
  int _level = 0;
  bool _isPlayerTurn = false;
  bool _gameInProgress = false;
  bool _isPlayingSequence = false;
  bool _isAnimatingPlayerTap = false;
  int? _activeColorIndex;

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
      _playerSequence = [];
      _isPlayerTurn = false;
    });

    final random = Random();
    _gameSequence.add(random.nextInt(4));
    _playSequence();
  }

  Future<void> _playSequence() async {
    setState(() {
      _isPlayingSequence = true;
    });

    await Future.delayed(const Duration(milliseconds: 400));

    for (int colorIndex in _gameSequence) {
      await _lightUpQuadrant(colorIndex);
      await Future.delayed(const Duration(milliseconds: 200));
    }

    setState(() {
      _isPlayerTurn = true;
      _isPlayingSequence = false;
    });
  }

  Future<void> _lightUpQuadrant(int colorIndex) async {
    setState(() => _activeColorIndex = colorIndex);
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) setState(() => _activeColorIndex = null);
  }

  void _onPlayerTap(int colorIndex) async {
    if (!_isPlayerTurn ||
        !_gameInProgress ||
        _isPlayingSequence ||
        _isAnimatingPlayerTap)
      return;

    _isAnimatingPlayerTap = true;
    await _lightUpQuadrant(colorIndex);
    _playerSequence.add(colorIndex);
    _checkPlayerSequence();
    _isAnimatingPlayerTap = false;
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
      });
      Future.delayed(const Duration(milliseconds: 700), _nextLevel);
    }
  }

  void _gameOver() {
    setState(() {
      _isPlayerTurn = false;
      _gameInProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double gameSize = screenWidth * 0.9;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: gameSize,
            height: gameSize,
            child: Stack(
              children: [
                _buildQuadrant(0, Alignment(0, -.83), 0.54, 0.15),
                _buildQuadrant(1, Alignment(.83, .0), 0.15, 0.54),
                _buildQuadrant(2, Alignment(0, .83), 0.54, 0.15),
                _buildQuadrant(3, Alignment(-.83, .0), 0.15, 0.54),

                Center(
                  child: SizedBox(
                    width: 90,
                    height: 90,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Score: $_level',
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w900,
                                fontSize: 9,
                              ),
                            ),
                            const SizedBox(height: 6),
                            if (!_gameInProgress && _level == 0) ...[
                              GestureDetector(
                                onTap: _startGame,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF826C00),
                                    border: Border.all(
                                      color: const Color(0xFFFFCB00),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ] else if (!_gameInProgress && _level > 0) ...[
                              GestureDetector(
                                onTap: _startGame,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF826C00),
                                    border: Border.all(
                                      color: const Color(0xFFFFCB00),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.refresh,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
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
  }

  Widget _buildQuadrant(
    int colorIndex,
    Alignment alignment,
    double width,
    double height,
  ) {
    final Color base = _colors[colorIndex];
    final Color active = _activeColors[colorIndex];

    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: () => _onPlayerTap(colorIndex),
        child: FractionallySizedBox(
          widthFactor: width,
          heightFactor: height,
          child: Container(
            decoration: BoxDecoration(
              color: _activeColorIndex == colorIndex ? active : base,
              borderRadius: BorderRadius.circular(500),
              boxShadow: [
                BoxShadow(color: base.withOpacity(0.3), blurRadius: 25),
                BoxShadow(
                  color: Colors.black.withOpacity(0.8),
                  blurRadius: 12,
                  offset: const Offset(4, 5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

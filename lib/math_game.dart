import 'dart:math';
import 'package:flutter/material.dart';

class MathGame extends StatefulWidget {
  const MathGame({super.key});

  @override
  State<MathGame> createState() => _MathGameState();
}

class _MathGameState extends State<MathGame> {
  int _score = 0;
  int _currentAnswer = 0;
  List<int> _options = [];
  String _currentProblem = '';
  bool _gameActive = true;

  @override
  void initState() {
    super.initState();
    _generateNewProblem();
  }

  void _generateNewProblem() {
    final random = Random();
    int a = random.nextInt(10) + 1;
    int b = random.nextInt(10) + 1;
    int c = random.nextInt(5) + 1;
    
    _currentAnswer = a + b + c;
    _currentProblem = '$a+$b+$c';
    
    // Generar opciones incorrectas
    Set<int> optionSet = {_currentAnswer};
    while (optionSet.length < 3) {
      int wrongAnswer = _currentAnswer + random.nextInt(10) - 5;
      if (wrongAnswer != _currentAnswer && wrongAnswer > 0) {
        optionSet.add(wrongAnswer);
      }
    }
    
    _options = optionSet.toList()..shuffle();
  }

  void _selectAnswer(int selectedAnswer) {
    if (!_gameActive) return;
    
    setState(() {
      if (selectedAnswer == _currentAnswer) {
        _score++;
        _generateNewProblem();
      } else {
        _gameActive = false;
      }
    });
  }

  void _restartGame() {
    setState(() {
      _score = 0;
      _gameActive = true;
      _generateNewProblem();
    });
  }

  @override
  Widget build(BuildContext context) {
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
          'Score: $_score',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Área del problema
              Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF3C3C3C),
                  borderRadius: BorderRadius.circular(15),
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
                  child: _gameActive
                      ? Text(
                          _currentProblem,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Game Over!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Final Score: $_score',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              
              // Opciones de respuesta
              if (_gameActive) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _options.map((option) => Flexible(child: _buildAnswerButton(option))).toList(),
                ),
              ] else ...[
                // Botón de reinicio
                GestureDetector(
                  onTap: _restartGame,
                  child: Container(
                    width: 200,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700),
                      borderRadius: BorderRadius.circular(30),
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
                    child: const Center(
                      child: Text(
                        'Play Again',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerButton(int option) {
    return GestureDetector(
      onTap: () => _selectAnswer(option),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFFFD700),
            width: 2,
          ),
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
            option.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:math';
import 'package:flutter/material.dart';

class MathGame extends StatefulWidget {
  const MathGame({super.key});

  @override
  State<MathGame> createState() => _MathGameState();
}

class _MathGameState extends State<MathGame> {
  int _currentAnswer = 0;
  List<int> _options = [];
  String _currentProblem = '';
  bool _gameActive = true;

  final Color accentGold = const Color(0xFFFFCB00);

  @override
  void initState() {
    super.initState();
    _generateNewProblem();
  }

  void _generateNewProblem() {
    final random = Random();
    int a = random.nextInt(9) + 1;
    int b = random.nextInt(9) + 1;
    int c = random.nextInt(5) + 1;

    _currentAnswer = a + b + c;
    _currentProblem = '$a + $b + $c';

    Set<int> optionSet = {_currentAnswer};
    while (optionSet.length < 3) {
      int wrongAnswer = _currentAnswer + random.nextInt(9) - 4;
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
        _generateNewProblem();
      } else {
        _gameActive = false;
      }
    });
  }

  void _restartGame() {
    setState(() {
      _gameActive = true;
      _generateNewProblem();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 22.0),
          child: Column(
            children: [
              const SizedBox(height: 14),
              Container(
                width: 130,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 31, 31, 31),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Color(0xFFFFCB00).withOpacity(0.13),
                      blurRadius: 32,
                    ),
                  ],
                  border: Border.all(
                    color: const Color.fromARGB(255, 26, 23, 23),
                    width: 0.7,
                  ),
                ),
                child: Center(
                  child: Text(
                    _gameActive ? _currentProblem : 'Game Over!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                      fontSize: 20,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(height: 2),
              Expanded(
                child: Center(
                  child: _gameActive
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _options
                              .map(
                                (option) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                  ),
                                  child: _buildAnswerButton(option),
                                ),
                              )
                              .toList(),
                        )
                      : GestureDetector(
                          onTap: _restartGame,
                          child: Container(
                            width: 130,
                            height: 24,
                            decoration: BoxDecoration(
                              color: const Color(0xFF826C00),
                              border: Border.all(
                                color: const Color(0xFFFFCB00),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(color: Colors.black, blurRadius: 25),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'Play Again',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w800,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14,
                                  height: 28.35 / 30,
                                  letterSpacing: 0,
                                  color: Colors.white,
                                ),
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
    );
  }

  Widget _buildAnswerButton(int option) {
    return GestureDetector(
      onTap: () => _selectAnswer(option),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: const Color.fromARGB(255, 83, 83, 83),
            width: 0.4,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(0.5),
          child: Container(
            height: 32,
            width: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 17, 17, 17),
                  Color.fromARGB(255, 34, 33, 33),
                ],
              ),
              boxShadow: const [
                BoxShadow(color: Color.fromARGB(102, 0, 0, 0), blurRadius: 10),
              ],
            ),
            child: Center(
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 82, 82, 82),
                      Color.fromARGB(255, 254, 201, 3),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Container(
                  margin: const EdgeInsets.all(0.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F1F1F),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      option.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

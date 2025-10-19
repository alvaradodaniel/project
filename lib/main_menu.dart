import 'package:flutter/material.dart';
import 'math_game.dart';
import 'memory_game.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  String? selectedGame; // null = ningún juego seleccionado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGameButton(
                    context,
                    'Quick Math',
                    isSelected: selectedGame == 'Quick Math',
                    onTap: () {
                      setState(() {
                        selectedGame = 'Quick Math';
                      });
                    },
                  ),
                  const SizedBox(width: 5),
                  _buildGameButton(
                    context,
                    'Memory Tap',
                    isSelected: selectedGame == 'Memory Tap',
                    onTap: () {
                      setState(() {
                        selectedGame = 'Memory Tap';
                      });
                    },
                  ),
                ],
              ),

              _buildPlayButton(context),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameButton(
    BuildContext context,
    String text, {
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? Colors.yellow : const Color(0xFF333333),
          width: 0.5,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF000000), Color(0xFF1B1B1B)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 17, 17, 17),
                  Color.fromARGB(255, 34, 33, 33),
                ],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(102, 0, 0, 0),
                  offset: Offset(16.22, 16.22),
                  blurRadius: 20,
                ),
                BoxShadow(
                  color: Color.fromARGB(102, 0, 0, 0),
                  offset: Offset(-16.22, -16.22),
                  blurRadius: 30,
                ),
                BoxShadow(
                  color: Color.fromARGB(102, 0, 0, 0),
                  offset: Offset(16.22, 16.22),
                  blurRadius: 10,
                ),
                BoxShadow(
                  color: Color.fromARGB(102, 0, 0, 0),
                  offset: Offset(-16.22, -16.22),
                  blurRadius: 25,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onTap,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        fontSize: 7,
                        height: 1.0,
                        letterSpacing: 0,
                        color: Colors.white,
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

  Widget _buildPlayButton(BuildContext context) {
    final bool isDisabled = selectedGame == null;

    return GestureDetector(
      onTap: isDisabled
          ? null
          : () {
              if (selectedGame == 'Quick Math') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MathGame()),
                );
              } else if (selectedGame == 'Memory Tap') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MemoryGame()),
                );
              }
            },
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0, // baja el tono si está deshabilitado
        child: Container(
          width: 130,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFF826C00),
            border: Border.all(color: const Color(0xFFFFCB00), width: 1),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.black, blurRadius: 25)],
          ),
          child: const Center(
            child: Text(
              'Play',
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
    );
  }
}

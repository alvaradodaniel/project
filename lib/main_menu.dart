import 'package:flutter/material.dart';
import 'math_game.dart';
import 'memory_game.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C), // Fondo gris oscuro
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Sección superior con botones de juegos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Botón Quick Math
                  _buildGameButton(
                    context,
                    'Quick Math',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MathGame()),
                    ),
                  ),
                  // Botón Memory Tap
                  _buildGameButton(
                    context,
                    'Memory Tap',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MemoryGame()),
                    ),
                  ),
                ],
              ),
              
              // Botón Play principal
              _buildPlayButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameButton(BuildContext context, String text, VoidCallback onTap) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = (screenWidth * 0.35).clamp(60.0, 80.0); // Tamaño responsivo
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonSize,
        height: buttonSize,
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
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: buttonSize * 0.15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayButton(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = (screenWidth * 0.8).clamp(120.0, 180.0); // Tamaño responsivo
    
    return GestureDetector(
      onTap: () {
        // Aquí podrías agregar lógica para seleccionar un juego aleatorio
        // Por ahora navegamos al juego de memoria
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MemoryGame()),
        );
      },
      child: Container(
        width: buttonWidth,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFFFD700), // Dorado
          borderRadius: BorderRadius.circular(25),
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
            'Play',
            style: TextStyle(
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
